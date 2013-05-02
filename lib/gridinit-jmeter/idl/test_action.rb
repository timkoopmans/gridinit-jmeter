module Gridinit
  module Jmeter

    class DSL
      def test_action(params={}, &block)
        node = Gridinit::Jmeter::TestAction.new(params)
        attach_node(node, &block)
      end
    end

    class TestAction
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<TestAction guiclass="TestActionGui" testclass="TestAction" testname="#{name}" enabled="true">
  <intProp name="ActionProcessor.action">1</intProp>
  <intProp name="ActionProcessor.target">0</intProp>
  <stringProp name="ActionProcessor.duration"/>
</TestAction>)
        EOS
        update params
      end
    end

  end
end
