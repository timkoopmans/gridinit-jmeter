module Gridinit
  module Jmeter

    class DSL
      def while_controller(params={}, &block)
        node = Gridinit::Jmeter::WhileController.new(params)
        attach_node(node, &block)
      end
    end

    class WhileController
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<WhileController guiclass="WhileControllerGui" testclass="WhileController" testname="#{name}" enabled="true">
  <stringProp name="WhileController.condition"/>
</WhileController>)
        EOS
        update params
      end
    end

  end
end
