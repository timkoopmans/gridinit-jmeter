module Gridinit
  module Jmeter

    class DSL
      def random_order_controller(params={}, &block)
        node = Gridinit::Jmeter::RandomOrderController.new(params)
        attach_node(node, &block)
      end
    end

    class RandomOrderController
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<RandomOrderController guiclass="RandomOrderControllerGui" testclass="RandomOrderController" testname="#{name}" enabled="true"/>)
        EOS
        update params
      end
    end

  end
end
