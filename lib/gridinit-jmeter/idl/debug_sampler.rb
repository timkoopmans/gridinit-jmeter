module Gridinit
  module Jmeter

    class DSL
      def debug_sampler(params={}, &block)
        node = Gridinit::Jmeter::DebugSampler.new(params)
        attach_node(node, &block)
      end
    end

    class DebugSampler
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<DebugSampler guiclass="TestBeanGUI" testclass="DebugSampler" testname="#{name}" enabled="true">
  <boolProp name="displayJMeterProperties">false</boolProp>
  <boolProp name="displayJMeterVariables">true</boolProp>
  <boolProp name="displaySystemProperties">false</boolProp>
</DebugSampler>)
        EOS
        update params
      end
    end

  end
end
