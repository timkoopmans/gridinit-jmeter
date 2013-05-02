module Gridinit
  module Jmeter

    class DSL
      def random_controller(params={}, &block)
        node = Gridinit::Jmeter::RandomController.new(params)
        attach_node(node, &block)
      end
    end

    class RandomController
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<RandomController guiclass="RandomControlGui" testclass="RandomController" testname="#{name}" enabled="true">
  <intProp name="InterleaveControl.style">1</intProp>
</RandomController>)
        EOS
        update params
      end
    end

  end
end
