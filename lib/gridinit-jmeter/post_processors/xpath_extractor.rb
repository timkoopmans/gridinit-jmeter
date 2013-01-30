module Gridinit
  module Jmeter

    class XpathExtractor
      attr_accessor :doc
      include Helper
      def initialize(name, xpath, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <XPathExtractor guiclass="XPathExtractorGui" testclass="XPathExtractor" testname="#{name}" enabled="true">
            <stringProp name="XPathExtractor.default"></stringProp>
            <stringProp name="XPathExtractor.refname">#{name}</stringProp>
            <stringProp name="XPathExtractor.xpathQuery">#{xpath}</stringProp>
            <boolProp name="XPathExtractor.validate">false</boolProp>
            <boolProp name="XPathExtractor.tolerant">false</boolProp>
            <boolProp name="XPathExtractor.namespace">false</boolProp>
          </XPathExtractor>
        EOF
        update params
      end
    end

  end
end