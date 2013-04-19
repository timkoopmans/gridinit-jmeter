module Gridinit
  module Jmeter

    class SwitchController
      attr_accessor :doc
      include Helper

      def initialize(name, switch_value, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
        <SwitchController guiclass="SwitchControllerGui" testclass="SwitchController" testname="#{name}" enabled="#{enabled(params)}">
          <stringProp name="SwitchController.value">#{switch_value}</stringProp>
        </SwitchController>

        EOF
        update params
      end
    end

  end
end
