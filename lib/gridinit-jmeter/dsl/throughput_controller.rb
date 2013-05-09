module Gridinit
  module Jmeter

    class DSL
      def throughput_controller(params={}, &block)
        node = Gridinit::Jmeter::ThroughputController.new(params)
        attach_node(node, &block)
      end
    end

    class ThroughputController
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ThroughputController guiclass="ThroughputControllerGui" testclass="ThroughputController" testname="#{name}" enabled="true">
  <intProp name="ThroughputController.style">0</intProp>
  <boolProp name="ThroughputController.perThread">true</boolProp>
  <intProp name="ThroughputController.maxThroughput">1</intProp>
  <FloatProperty>
    <name>ThroughputController.percentThroughput</name>
    <value>100.0</value>
    <savedValue>0.0</savedValue>
  </FloatProperty>
</ThroughputController>)
        EOS
        update params
      end
    end

  end
end
