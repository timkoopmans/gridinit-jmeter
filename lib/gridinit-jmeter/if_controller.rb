module Gridinit
  module Jmeter

    class IfController
      attr_accessor :doc
      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <IfController guiclass="IfControllerPanel" testclass="IfController" testname="#{name}" enabled="true">
            <stringProp name="IfController.condition">/stringProp>
            <boolProp name="IfController.evaluateAll">false</boolProp>
          </IfController>
        EOF
        params.each do |name, value|
          node = @doc.children.xpath("//*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = value unless node.empty? 
        end
      end
    end  

  end
end