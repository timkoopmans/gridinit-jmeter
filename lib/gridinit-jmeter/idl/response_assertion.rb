module Gridinit
  module Jmeter

    class DSL
      def response_assertion(params={}, &block)
        node = Gridinit::Jmeter::ResponseAssertion.new(params)
        attach_node(node, &block)
      end
    end

    class ResponseAssertion
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ResponseAssertion guiclass="AssertionGui" testclass="ResponseAssertion" testname="#{name}" enabled="true">
  <collectionProp name="Asserion.test_strings"/>
  <stringProp name="Assertion.test_field">Assertion.response_data</stringProp>
  <boolProp name="Assertion.assume_success">false</boolProp>
  <intProp name="Assertion.test_type">2</intProp>
</ResponseAssertion>)
        EOS
        update params
      end
    end

  end
end
