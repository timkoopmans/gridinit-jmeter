module Gridinit
  module Jmeter

    class DSL
      def foreach_controller(params={}, &block)
        node = Gridinit::Jmeter::ForeachController.new(params)
        attach_node(node, &block)
      end
    end

    class ForeachController
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ForeachController guiclass="ForeachControlPanel" testclass="ForeachController" testname="#{name}" enabled="true">
  <stringProp name="ForeachController.inputVal"/>
  <stringProp name="ForeachController.returnVal"/>
  <boolProp name="ForeachController.useSeparator">true</boolProp>
</ForeachController>)
        EOS
        update params
      end
    end

  end
end
