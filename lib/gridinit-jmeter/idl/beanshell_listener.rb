module Gridinit
  module Jmeter

    class DSL
      def beanshell_listener(params={}, &block)
        node = Gridinit::Jmeter::BeanshellListener.new(params)
        attach_node(node, &block)
      end
    end

    class BeanshellListener
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BeanShellListener guiclass="TestBeanGUI" testclass="BeanShellListener" testname="#{name}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <boolProp name="resetInterpreter">false</boolProp>
  <stringProp name="script"/>
</BeanShellListener>)
        EOS
        update params
      end
    end

  end
end
