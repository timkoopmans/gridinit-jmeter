module Gridinit
  module Jmeter

    class DSL
      def simple_controller(params={}, &block)
        node = Gridinit::Jmeter::SimpleController.new(params)
        attach_node(node, &block)
      end
    end

    class SimpleController
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<GenericController guiclass="LogicControllerGui" testclass="GenericController" testname="#{name}" enabled="true"/>)
        EOS
        update params
      end
    end

  end
end
