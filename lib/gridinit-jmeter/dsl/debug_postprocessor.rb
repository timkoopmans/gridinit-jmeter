module Gridinit
  module Jmeter

    class DSL
      def debug_postprocessor(params={}, &block)
        node = Gridinit::Jmeter::DebugPostprocessor.new(params)
        attach_node(node, &block)
      end
    end

    class DebugPostprocessor
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<DebugPostProcessor guiclass="TestBeanGUI" testclass="DebugPostProcessor" testname="#{name}" enabled="true">
  <boolProp name="displayJMeterProperties">false</boolProp>
  <boolProp name="displayJMeterVariables">true</boolProp>
  <boolProp name="displaySamplerProperties">true</boolProp>
  <boolProp name="displaySystemProperties">false</boolProp>
</DebugPostProcessor>)
        EOS
        update params
      end
    end

  end
end
