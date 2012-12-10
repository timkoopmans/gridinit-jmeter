module Gridinit
  module Jmeter

    class XpathExtractor
      attr_accessor :doc
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
        params.each do |name, value|
          node = @doc.children.xpath("//*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = value unless node.empty?
        end
      end
    end

  end
end