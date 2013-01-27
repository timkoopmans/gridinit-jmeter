module Gridinit
  module Jmeter

    class LoopController
      attr_accessor :doc
      def initialize(loops, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <LoopController guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
            <boolProp name="LoopController.continue_forever">true</boolProp>
            <stringProp name="LoopController.loops">#{loops}</stringProp>
          </LoopController>
        EOF
        params.each do |name, value|
          node = @doc.children.xpath("//*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = value unless node.empty? 
        end
      end
    end  

  end
end