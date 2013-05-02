module Gridinit
  module Jmeter

    class DSL
      def switch_controller(params={}, &block)
        node = Gridinit::Jmeter::SwitchController.new(params)
        attach_node(node, &block)
      end
    end

    class SwitchController
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<SwitchController guiclass="SwitchControllerGui" testclass="SwitchController" testname="#{name}" enabled="true">
  <stringProp name="SwitchController.value"/>
</SwitchController>)
        EOS
        update params
      end
    end

  end
end
