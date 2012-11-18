module Gridinit
  module Jmeter

    class DSL
      attr_accessor :root

      def initialize
        @root = Nokogiri::XML(<<-EOF.strip_heredoc)
          <?xml version="1.0" encoding="UTF-8"?>
          <jmeterTestPlan version="1.2" properties="2.1">
          <hashTree>
          </hashTree>
          </jmeterTestPlan>
        EOF
        node = Gridinit::Jmeter::TestPlan.new
        @root.at_xpath("//jmeterTestPlan/hashTree") << node.doc.children << hash_tree
        
        variables(
          name: 'testguid', 
          value: '${__P(testguid,${__time(,)})}',
          comments: 'The testguid variable is mandatory when running on the Grid.') {} 
      end

      def variables(params={}, &block)
        node = Gridinit::Jmeter::UserDefinedVariable.new(params)
        @root.at_xpath(xpath_from(caller)) << node.doc.children << hash_tree
        self.instance_exec(&block) if block
      end

      def threads(num_threads=1, params={}, &block)
        node = Gridinit::Jmeter::ThreadGroup.new(num_threads, params)
        @root.at_xpath(xpath_from(caller)) << node.doc.children << hash_tree
        self.instance_exec(&block) if block
      end

      def transaction(name="Transaction Contoller", params={}, &block)
        node = Gridinit::Jmeter::Transaction.new(name, params)
        @root.at_xpath(xpath_from(caller)) << node.doc.children << hash_tree
        self.instance_exec(&block) if block
      end

      def visit(name="HTTP Request", url="", params={}, &block)
        params[:method] = 'GET'
        node = Gridinit::Jmeter::HttpSampler.new(name, url, params)
        @root.at_xpath(xpath_from(caller)) << node.doc.children << hash_tree
        self.instance_exec(&block) if block
      end

      def submit(name="HTTP Request", url="", params={}, &block)
        params[:method] = 'POST'
        node = Gridinit::Jmeter::HttpSampler.new(name, url, params)
        @root.at_xpath(xpath_from(caller)) << node.doc.children << hash_tree
        self.instance_exec(&block) if block
      end

      alias_method :post, :submit

      def extract(name="", regex="", params={}, &block)
        node = Gridinit::Jmeter::RegexExtractor.new(name, regex, params)
        @root.at_xpath(xpath_from(caller)) << node.doc.children << hash_tree
        self.instance_exec(&block) if block
      end

      def random_timer(delay=0, range=0, &block)
        node = Gridinit::Jmeter::GaussianRandomTimer.new(delay, range)
        @root.at_xpath(xpath_from(caller)) << node.doc.children << hash_tree
        self.instance_exec(&block) if block
      end

      alias_method :think_time, :random_timer

      def jmx(params={})
        file(params)
        puts doc.to_xml(:indent => 2)
        logger.info "JMX saved to: #{params[:file]}"
      end

      def run(params={})
        file(params)
        logger.warn "Test executing locally ..."
        cmd = "#{params[:path]}jmeter -n -t #{params[:file]} -j #{params[:log] ? params[:log] : 'jmeter.log' } -l #{params[:jtl] ? params[:jtl] : 'jmeter.jtl' }"
        logger.info cmd
        `#{cmd}`
        logger.info "Results at: #{params[:jtl] ? params[:jtl] : 'jmeter.jtl'}"
      end

      def grid(token, params={})
        file(params)
        begin
          response = RestClient.post "http://#{params[:endpoint] ? params[:endpoint] : 'gridinit.com'}/api?token=#{token}", {
            :name => 'attachment', 
            :attachment => File.new("#{params[:file]}", 'rb'),
            :multipart => true,
            :content_type => 'application/octet-stream'
          }
          logger.info "Results at: #{JSON.parse(response)["results"]}" if response.code == 200
        rescue => e
          logger.fatal "There was an error: #{e.message}"
        end
      end
      
      private

      def hash_tree
        Nokogiri::XML::Node.new("hashTree", @root)
      end

      def xpath_from(calling_method)
        case calling_method.grep(/dsl/)[1][/`.*'/][1..-2]
        when 'threads'
          '//ThreadGroup[last()]/following-sibling::hashTree'
        when 'transaction'
          '//TransactionController[last()]/following-sibling::hashTree'
        when 'visit'
          '//HTTPSamplerProxy[last()]/following-sibling::hashTree'
        when 'submit'
          '//HTTPSamplerProxy[last()]/following-sibling::hashTree'
        when 'extract'
          '//RegexExtractor[last()]/following-sibling::hashTree'
        when 'random_timer'
          '//GaussianRandomTimer[last()]/following-sibling::hashTree'
        else 
          '//TestPlan/following-sibling::hashTree'
        end
      end

      def file(params={})
        params[:file] ||= 'jmeter.jmx'
        File.open(params[:file], 'w') { |file| file.write(doc.to_xml(:indent => 2)) }
      end

      def doc
        Nokogiri::XML(@root.to_s,&:noblanks)
      end

      def logger
        @log ||= Logger.new(STDOUT)
        @log.level = Logger::DEBUG
        @log
      end

    end

  end
end

def test(&block)
  Docile.dsl_eval(Gridinit::Jmeter::DSL.new, &block)
end