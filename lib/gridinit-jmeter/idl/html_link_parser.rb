module Gridinit
  module Jmeter

    class DSL
      def html_link_parser(params={}, &block)
        node = Gridinit::Jmeter::HtmlLinkParser.new(params)
        attach_node(node, &block)
      end
    end

    class HtmlLinkParser
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<AnchorModifier guiclass="AnchorModifierGui" testclass="AnchorModifier" testname="#{name}" enabled="true"/>)
        EOS
        update params
      end
    end

  end
end
