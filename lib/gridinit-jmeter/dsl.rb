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
        @root.at_xpath("//jmeterTestPlan/hashTree") << node.doc.children
        @root.at_xpath("//TestPlan").add_next_sibling(Nokogiri::XML::Node.new("hashTree", @root))

        variables(
          name: 'testguid', 
          value: '${__P(testguid,${__time(,)})}',
          comments: 'The testguid variable is mandatory when running on the Grid.') {} 
      end

      def variables(params={}, &block)
        node = Gridinit::Jmeter::UserDefinedVariable.new(params)
        @root.at_xpath("//TestPlan/following-sibling::hashTree") << node.doc.children
        @root.at_xpath("//Arguments").add_next_sibling(Nokogiri::XML::Node.new("hashTree", @root))
        self.instance_exec(&block) if block
      end

      def random_timer(params={}, &block)
        node = Gridinit::Jmeter::GaussianRandomTimer.new(params)
        @root.at_xpath("//TestPlan/following-sibling::hashTree") << node.doc.children
        @root.at_xpath("//GaussianRandomTimer").add_next_sibling(Nokogiri::XML::Node.new("hashTree", @root))
        self.instance_exec(&block) if block
      end

      def threads(params={}, &block)
        node = Gridinit::Jmeter::ThreadGroup.new(params)
        @root.at_xpath("//TestPlan/following-sibling::hashTree") << node.doc.children
        @root.at_xpath("//ThreadGroup").add_next_sibling(Nokogiri::XML::Node.new("hashTree", @root))
        self.instance_exec(&block) if block
      end

      def transaction(name="Transaction Contoller", params={}, &block)
        node = Gridinit::Jmeter::Transaction.new(name, params)
        @root.at_xpath("//ThreadGroup[last()]/following-sibling::hashTree") << node.doc.children
        @root.at_xpath("//TransactionController[last()]").add_next_sibling(Nokogiri::XML::Node.new("hashTree", @root))
        self.instance_exec(&block) if block
      end

      def visit(name="HTTP Request", url="", params={}, &block)
        params[:method] = 'GET'
        node = Gridinit::Jmeter::HttpSampler.new(name, url, params)
        @root.at_xpath("//TransactionController[last()]/following-sibling::hashTree") << node.doc.children
        @root.at_xpath("//HTTPSamplerProxy[last()]").add_next_sibling(Nokogiri::XML::Node.new("hashTree", @root))
        self.instance_exec(&block) if block
      end

      def submit(name="HTTP Request", url="", params={}, &block)
        params[:method] = 'POST'
        node = Gridinit::Jmeter::HttpSampler.new(name, url, params)
        @root.at_xpath("//TransactionController[last()]/following-sibling::hashTree") << node.doc.children
        @root.at_xpath("//HTTPSamplerProxy[last()]").add_next_sibling(Nokogiri::XML::Node.new("hashTree", @root))
        self.instance_exec(&block) if block
      end

      def extract(name="", regex="", params={}, &block)
        node = Gridinit::Jmeter::RegexExtractor.new(name, regex, params)
        @root.at_xpath("//HTTPSamplerProxy[last()]/following-sibling::hashTree") << node.doc.children
        @root.at_xpath("//RegexExtractor[last()]").add_next_sibling(Nokogiri::XML::Node.new("hashTree", @root))
        self.instance_exec(&block) if block
      end

      def jmx(params={})
        file(params)
        puts doc.to_xml(:indent => 2)
      end

      def local(params={})
        file(params)
        `jmeter -n -t #{params[:file]} -j #{params.try(:log) || 'jmeter.log' } -l #{params.try(:jtl) || 'jmeter.jtl' }`
      end

      def grid(token, params={})
        file(params)
        `curl -i -F name=attachment -F attachment=@#{params[:file]} http://gridinit.com/api?token=#{token}`
      end
      
      private

      def file(params={})
        params[:file] ||= '/tmp/jmeter.jmx'
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