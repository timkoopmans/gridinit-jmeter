module Gridinit
  module Jmeter

    class DSL
      def beanshell_preprocessor(params={}, &block)
        node = Gridinit::Jmeter::BeanshellPreprocessor.new(params)
        attach_node(node, &block)
      end
    end

    class BeanshellPreprocessor
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BeanShellPreProcessor guiclass="TestBeanGUI" testclass="BeanShellPreProcessor" testname="#{name}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <boolProp name="resetInterpreter">false</boolProp>
  <stringProp name="script"/>
</BeanShellPreProcessor>)
        EOS
        update params
      end
    end

  end
end
