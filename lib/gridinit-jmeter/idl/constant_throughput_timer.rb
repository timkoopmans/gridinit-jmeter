module Gridinit
  module Jmeter

    class DSL
      def constant_throughput_timer(params={}, &block)
        node = Gridinit::Jmeter::ConstantThroughputTimer.new(params)
        attach_node(node, &block)
      end
    end

    class ConstantThroughputTimer
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ConstantThroughputTimer guiclass="TestBeanGUI" testclass="ConstantThroughputTimer" testname="#{name}" enabled="true">
  <stringProp name="calcMode">this thread only</stringProp>
  <doubleProp>
    <name>throughput</name>
    <value>0.0</value>
    <savedValue>0.0</savedValue>
  </doubleProp>
</ConstantThroughputTimer>)
        EOS
        update params
      end
    end

  end
end
