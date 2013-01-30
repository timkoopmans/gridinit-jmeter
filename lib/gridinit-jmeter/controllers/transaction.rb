module Gridinit
  module Jmeter

    class Transaction
      attr_accessor :doc
      include Helper
      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <TransactionController guiclass="TransactionControllerGui" testclass="TransactionController" testname="#{name}" enabled="true">
            <boolProp name="TransactionController.parent">true</boolProp>
          </TransactionController>
        EOF
        update params
      end
    end  

  end
end
