module Gridinit
  module Jmeter

    class RegexExtractor
      attr_accessor :doc
      def initialize(params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <RegexExtractor guiclass="RegexExtractorGui" testclass="RegexExtractor" testname="Regular Expression Extractor" enabled="true">
            <stringProp name="RegexExtractor.useHeaders">false</stringProp>
            <stringProp name="RegexExtractor.refname">session_id</stringProp>
            <stringProp name="RegexExtractor.regex">sessionId=&quot;(.+?)&quot;</stringProp>
            <stringProp name="RegexExtractor.template">$1$</stringProp>
            <stringProp name="RegexExtractor.default"></stringProp>
            <stringProp name="RegexExtractor.match_number">0</stringProp>
          </RegexExtractor>
        EOF
        params.each do |name, value|
          node = @doc.children.xpath("*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = CGI.escapeHTML(value) unless node.empty? 
        end
      end
    end  

  end
end