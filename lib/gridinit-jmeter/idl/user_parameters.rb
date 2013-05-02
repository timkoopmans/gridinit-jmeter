module Gridinit
  module Jmeter

    class DSL
      def user_parameters(params={}, &block)
        node = Gridinit::Jmeter::UserParameters.new(params)
        attach_node(node, &block)
      end
    end

    class UserParameters
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<UserParameters guiclass="UserParametersGui" testclass="UserParameters" testname="#{name}" enabled="true">
  <collectionProp name="UserParameters.names"/>
  <collectionProp name="UserParameters.thread_values">
    <collectionProp name="1"/>
  </collectionProp>
  <boolProp name="UserParameters.per_iteration">false</boolProp>
</UserParameters>)
        EOS
        update params
      end
    end

  end
end
