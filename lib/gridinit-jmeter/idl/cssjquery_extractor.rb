module Gridinit
  module Jmeter

    class DSL
      def cssjquery_extractor(params={}, &block)
        node = Gridinit::Jmeter::CssjqueryExtractor.new(params)
        attach_node(node, &block)
      end
    end

    class CssjqueryExtractor
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<HtmlExtractor guiclass="HtmlExtractorGui" testclass="HtmlExtractor" testname="#{name}" enabled="true">
  <stringProp name="HtmlExtractor.refname"/>
  <stringProp name="HtmlExtractor.expr"/>
  <stringProp name="HtmlExtractor.attribute"/>
  <stringProp name="HtmlExtractor.default"/>
  <stringProp name="HtmlExtractor.match_number"/>
  <stringProp name="HtmlExtractor.extractor_impl"/>
</HtmlExtractor>)
        EOS
        update params
      end
    end

  end
end
