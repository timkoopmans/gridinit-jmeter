module Gridinit
  module Jmeter

    class LoopController
      attr_accessor :doc
      include Helper
      def initialize(loops, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <LoopController guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
            <boolProp name="LoopController.continue_forever">true</boolProp>
            <stringProp name="LoopController.loops">#{loops}</stringProp>
          </LoopController>
        EOF
        update params
      end
    end  

  end
end
