module Gridinit
  module Jmeter

    class IfController
      attr_accessor :doc
      include Helper
      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <IfController guiclass="IfControllerPanel" testclass="IfController" testname="#{name}" enabled="true">
            <stringProp name="IfController.condition"></stringProp>
            <boolProp name="IfController.evaluateAll">false</boolProp>
          </IfController>
        EOF
        update params
      end
    end  

  end
end
