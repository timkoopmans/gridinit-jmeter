module Gridinit
  module Jmeter

    class DSL
      def html_assertion(params={}, &block)
        node = Gridinit::Jmeter::HtmlAssertion.new(params)
        attach_node(node, &block)
      end
    end

    class HtmlAssertion
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<HTMLAssertion guiclass="HTMLAssertionGui" testclass="HTMLAssertion" testname="#{name}" enabled="true">
  <longProp name="html_assertion_error_threshold">0</longProp>
  <longProp name="html_assertion_warning_threshold">0</longProp>
  <stringProp name="html_assertion_doctype">omit</stringProp>
  <boolProp name="html_assertion_errorsonly">false</boolProp>
  <longProp name="html_assertion_format">0</longProp>
  <stringProp name="html_assertion_filename"/>
</HTMLAssertion>)
        EOS
        update params
      end
    end

  end
end
