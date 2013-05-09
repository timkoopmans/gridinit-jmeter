module Gridinit
  module Jmeter

    class DSL
      def compare_assertion(params={}, &block)
        node = Gridinit::Jmeter::CompareAssertion.new(params)
        attach_node(node, &block)
      end
    end

    class CompareAssertion
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<CompareAssertion guiclass="TestBeanGUI" testclass="CompareAssertion" testname="#{name}" enabled="true">
  <boolProp name="compareContent">true</boolProp>
  <longProp name="compareTime">-1</longProp>
  <collectionProp name="stringsToSkip"/>
</CompareAssertion>)
        EOS
        update params
      end
    end

  end
end
