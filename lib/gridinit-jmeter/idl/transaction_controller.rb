module Gridinit
  module Jmeter

    class DSL
      def transaction_controller(params={}, &block)
        node = Gridinit::Jmeter::TransactionController.new(params)
        attach_node(node, &block)
      end
    end

    class TransactionController
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<TransactionController guiclass="TransactionControllerGui" testclass="TransactionController" testname="#{name}" enabled="true">
  <boolProp name="TransactionController.parent">false</boolProp>
</TransactionController>)
        EOS
        update params
      end
    end

  end
end
