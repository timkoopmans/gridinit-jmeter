module Gridinit
  module Jmeter

    class DSL
      def beanshell_postprocessor(params={}, &block)
        node = Gridinit::Jmeter::BeanshellPostprocessor.new(params)
        attach_node(node, &block)
      end
    end

    class BeanshellPostprocessor
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BeanShellPostProcessor guiclass="TestBeanGUI" testclass="BeanShellPostProcessor" testname="#{name}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <boolProp name="resetInterpreter">false</boolProp>
  <stringProp name="script"/>
</BeanShellPostProcessor>)
        EOS
        update params
      end
    end

  end
end
