module Gridinit
  module Jmeter

    class DSL
      def include_controller(params={}, &block)
        node = Gridinit::Jmeter::IncludeController.new(params)
        attach_node(node, &block)
      end
    end

    class IncludeController
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<IncludeController guiclass="IncludeControllerGui" testclass="IncludeController" testname="#{name}" enabled="true">
  <stringProp name="IncludeController.includepath"/>
</IncludeController>)
        EOS
        update params
      end
    end

  end
end
