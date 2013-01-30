module Gridinit
  module Jmeter

    class RegexExtractor
      attr_accessor :doc
      include Helper
      def initialize(name, regex, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <RegexExtractor guiclass="RegexExtractorGui" testclass="RegexExtractor" testname="#{name}" enabled="true">
            <stringProp name="RegexExtractor.useHeaders">false</stringProp>
            <stringProp name="RegexExtractor.refname">#{name}</stringProp>
            <stringProp name="RegexExtractor.regex">#{CGI.escapeHTML regex}</stringProp>
            <stringProp name="RegexExtractor.template">$1$</stringProp>
            <stringProp name="RegexExtractor.default"></stringProp>
            <stringProp name="RegexExtractor.match_number">0</stringProp>
          </RegexExtractor>
        EOF
        update params
      end
    end  

  end
end
