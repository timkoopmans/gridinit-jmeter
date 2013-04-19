module Gridinit
  module Jmeter

    class RegexExtractor
      attr_accessor :doc
      include Helper

      def initialize(name, regex, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <RegexExtractor guiclass="RegexExtractorGui" testclass="RegexExtractor" testname="#{name}" enabled="true">
            <stringProp name="RegexExtractor.useHeaders">#{use_headers_type(params)}</stringProp>
            <stringProp name="RegexExtractor.refname">#{name}</stringProp>
            <stringProp name="RegexExtractor.regex">#{CGI.escapeHTML regex}</stringProp>
            <stringProp name="RegexExtractor.template">$1$</stringProp>
            <stringProp name="RegexExtractor.default">#{params[:default]}</stringProp>
            <stringProp name="RegexExtractor.match_number">0</stringProp>
            <stringProp name="Sample.scope">all</stringProp>
          </RegexExtractor>
        EOF
        update params
      end

      def use_headers_type(params)
        #default to true unless explicitly set to false
        if params.has_key?(:match_on)
          params[:match_on]
        else
          'false'
        end
      end
    end

  end
end
