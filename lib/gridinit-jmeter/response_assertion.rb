module Gridinit
  module Jmeter

    class ResponseAssertion
      attr_accessor :doc
      def initialize(match, pattern, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <ResponseAssertion guiclass="AssertionGui" testclass="ResponseAssertion" testname="Response Assertion" enabled="true">
            <collectionProp name="Asserion.test_strings">
              <stringProp name="#{Time.now.to_i}">#{pattern}</stringProp>
            </collectionProp>
            <stringProp name="Assertion.test_field">Assertion.response_data</stringProp>
            <boolProp name="Assertion.assume_success">false</boolProp>
            <intProp name="Assertion.test_type">#{test_type(match)}</intProp>
          </ResponseAssertion>
        EOF
        if params[:scope]
          @doc.at_xpath('//ResponseAssertion') << 
            Nokogiri::XML(<<-EOF.strip_heredoc).children
              <stringProp name="Assertion.scope">#{params[:scope]}</stringProp>
              EOF
          params.delete [:scope]
        end
        params.each do |name, value|
          node = @doc.children.xpath("//*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = value unless node.empty? 
        end
      end

      private

      def test_type(match)
        case match
        when 'contains'
          2
        when 'not-contains'
          6
        when 'matches'
          1
        when 'not-matches'
          5
        when 'equals'
          8
        when 'not-equals'
          12
        when 'substring'
          16
        when 'not-substring'
          20
        else
          2
        end
      end

    end  

  end
end