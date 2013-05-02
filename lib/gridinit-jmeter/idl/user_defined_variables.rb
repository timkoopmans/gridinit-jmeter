module Gridinit
  module Jmeter

    class DSL
      def user_defined_variables(params={}, &block)
        node = Gridinit::Jmeter::UserDefinedVariables.new(params)
        attach_node(node, &block)
      end
    end

    class UserDefinedVariables
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<Arguments guiclass="ArgumentsPanel" testclass="Arguments" testname="#{name}" enabled="true">
  <collectionProp name="Arguments.arguments"/>
</Arguments>)
        EOS
        update params
      end
    end

  end
end
