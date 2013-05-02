module Gridinit
  module Jmeter

    class DSL
      def xml_assertion(params={}, &block)
        node = Gridinit::Jmeter::XmlAssertion.new(params)
        attach_node(node, &block)
      end
    end

    class XmlAssertion
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<XMLAssertion guiclass="XMLAssertionGui" testclass="XMLAssertion" testname="#{name}" enabled="true"/>)
        EOS
        update params
      end
    end

  end
end
