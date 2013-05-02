module Gridinit
  module Jmeter

    class DSL
      def xml_schema_assertion(params={}, &block)
        node = Gridinit::Jmeter::XmlSchemaAssertion.new(params)
        attach_node(node, &block)
      end
    end

    class XmlSchemaAssertion
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<XMLSchemaAssertion guiclass="XMLSchemaAssertionGUI" testclass="XMLSchemaAssertion" testname="#{name}" enabled="true">
  <stringProp name="xmlschema_assertion_filename"/>
</XMLSchemaAssertion>)
        EOS
        update params
      end
    end

  end
end
