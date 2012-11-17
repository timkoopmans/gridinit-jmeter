module Gridinit
  module Jmeter

    class Transaction
      attr_accessor :doc
      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <TransactionController guiclass="TransactionControllerGui" testclass="TransactionController" testname="#{name}" enabled="true">
            <boolProp name="TransactionController.parent">false</boolProp>
          </TransactionController>
        EOF
        params.each do |name, value|
          node = @doc.children.xpath("//*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = value unless node.empty? 
        end
      end
    end  

  end
end