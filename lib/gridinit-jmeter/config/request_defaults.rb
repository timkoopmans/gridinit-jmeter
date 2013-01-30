module Gridinit
  module Jmeter

    class RequestDefaults
      attr_accessor :doc
      include Helper
      def initialize(params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <ConfigTestElement guiclass="HttpDefaultsGui" testclass="ConfigTestElement" testname="HTTP Request Defaults" enabled="true">
            <elementProp name="HTTPsampler.Arguments" elementType="Arguments" guiclass="HTTPArgumentsPanel" testclass="Arguments" testname="User Defined Variables" enabled="true">
              <collectionProp name="Arguments.arguments"/>
            </elementProp>
            <stringProp name="HTTPSampler.domain"></stringProp>
            <stringProp name="HTTPSampler.port"></stringProp>
            <stringProp name="HTTPSampler.connect_timeout"></stringProp>
            <stringProp name="HTTPSampler.response_timeout"></stringProp>
            <stringProp name="HTTPSampler.protocol"></stringProp>
            <stringProp name="HTTPSampler.contentEncoding"></stringProp>
            <stringProp name="HTTPSampler.path"></stringProp>
            <boolProp name="HTTPSampler.image_parser">false</boolProp>
            <stringProp name="HTTPSampler.embedded_url_re"></stringProp>
            <boolProp name="HTTPSampler.concurrentDwn">false</boolProp>
            <stringProp name="HTTPSampler.concurrentPool">4</stringProp>
          </ConfigTestElement>
        EOF
        update params
      end
    end  

  end
end
