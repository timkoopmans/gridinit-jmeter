module Gridinit
  module Jmeter

    class DSL
      def regular_expression_extractor(params={}, &block)
        node = Gridinit::Jmeter::RegularExpressionExtractor.new(params)
        attach_node(node, &block)
      end
    end

    class RegularExpressionExtractor
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<RegexExtractor guiclass="RegexExtractorGui" testclass="RegexExtractor" testname="#{name}" enabled="true">
  <stringProp name="RegexExtractor.useHeaders">false</stringProp>
  <stringProp name="RegexExtractor.refname"/>
  <stringProp name="RegexExtractor.regex"/>
  <stringProp name="RegexExtractor.template"/>
  <stringProp name="RegexExtractor.default"/>
  <stringProp name="RegexExtractor.match_number"/>
</RegexExtractor>)
        EOS
        update params
      end
    end

  end
end
