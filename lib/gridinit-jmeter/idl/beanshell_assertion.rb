module Gridinit
  module Jmeter

    class DSL
      def beanshell_assertion(params={}, &block)
        node = Gridinit::Jmeter::BeanshellAssertion.new(params)
        attach_node(node, &block)
      end
    end

    class BeanshellAssertion
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BeanShellAssertion guiclass="BeanShellAssertionGui" testclass="BeanShellAssertion" testname="#{name}" enabled="true">
  <stringProp name="BeanShellAssertion.query"/>
  <stringProp name="BeanShellAssertion.filename"/>
  <stringProp name="BeanShellAssertion.parameters"/>
  <boolProp name="BeanShellAssertion.resetInterpreter">false</boolProp>
</BeanShellAssertion>)
        EOS
        update params
      end
    end

  end
end
