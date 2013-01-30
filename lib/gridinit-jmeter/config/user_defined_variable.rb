module Gridinit
  module Jmeter

    class UserDefinedVariable
      attr_accessor :doc
      include Helper
      def initialize(params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <Arguments guiclass="ArgumentsPanel" testclass="Arguments" testname="User Defined Variables" enabled="true">
            <collectionProp name="Arguments.arguments">
              <elementProp name="testguid" elementType="Argument">
                <stringProp name="Argument.name"></stringProp>
                <stringProp name="Argument.value"></stringProp>
                <stringProp name="Argument.metadata">=</stringProp>
              </elementProp>
            </collectionProp>
            <stringProp name="TestPlan.comments"></stringProp>
          </Arguments>
        EOF
        update params
      end
    end 

  end
end