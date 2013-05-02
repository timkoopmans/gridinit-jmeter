module Gridinit
  module Jmeter

    class DSL
      def if_controller(params={}, &block)
        node = Gridinit::Jmeter::IfController.new(params)
        attach_node(node, &block)
      end
    end

    class IfController
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<IfController guiclass="IfControllerPanel" testclass="IfController" testname="#{name}" enabled="true">
  <stringProp name="IfController.condition"/>
  <boolProp name="IfController.evaluateAll">false</boolProp>
</IfController>)
        EOS
        update params
      end
    end

  end
end
