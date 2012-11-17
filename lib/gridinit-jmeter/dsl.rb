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
      end

      def threads(params={}, &block)
        node = Gridinit::Jmeter::ThreadGroup.new(params)
        @root.at_xpath("//TestPlan/following-sibling::hashTree") << node.doc.children
        @root.at_xpath("//ThreadGroup").add_next_sibling(Nokogiri::XML::Node.new("hashTree", @root))
        self.instance_exec(&block) if block
      end

      def transaction(params={}, &block)
        node = Gridinit::Jmeter::Transaction.new(params)
        @root.at_xpath("//ThreadGroup[last()]/following-sibling::hashTree") << node.doc.children
        @root.at_xpath("//TransactionController[last()]").add_next_sibling(Nokogiri::XML::Node.new("hashTree", @root))
        self.instance_exec(&block) if block
      end

      def visit(params={}, &block)
        params[:method] = 'GET'
        node = Gridinit::Jmeter::HttpSampler.new(params)
        @root.at_xpath("//TransactionController[last()]/following-sibling::hashTree") << node.doc.children
        @root.at_xpath("//HTTPSamplerProxy[last()]").add_next_sibling(Nokogiri::XML::Node.new("hashTree", @root))
        self.instance_exec(&block) if block
      end

      def submit(params={}, &block)
        params[:method] = 'POST'
        node = Gridinit::Jmeter::HttpSampler.new(params)
        @root.at_xpath("//TransactionController[last()]/following-sibling::hashTree") << node.doc.children
        @root.at_xpath("//HTTPSamplerProxy[last()]").add_next_sibling(Nokogiri::XML::Node.new("hashTree", @root))
        self.instance_exec(&block) if block
      end

      def extract(params={}, &block)
        node = Gridinit::Jmeter::RegexExtractor.new(params)
        @root.at_xpath("//HTTPSamplerProxy[last()]/following-sibling::hashTree") << node.doc.children
        @root.at_xpath("//RegexExtractor[last()]").add_next_sibling(Nokogiri::XML::Node.new("hashTree", @root))
        self.instance_exec(&block) if block
      end

      def jmx(params={})
        params[:file] ||= '/tmp/jmeter.jmx'
        File.open(params[:file], 'w') { |file| file.write(doc.to_xml(:indent => 2)) }
        puts doc.to_xml(:indent => 2)
      end

      def run(params={})
        params[:file] ||= '/tmp/jmeter.jmx'
        File.open(params[:file], 'w') { |file| file.write(doc.to_xml(:indent => 2)) }
        `/usr/share/jmeter/bin/jmeter -n -t /tmp/jmeter.jmx -j /tmp/jmeter.log -l /tmp/jmeter.jtl`
      end
      
      private

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