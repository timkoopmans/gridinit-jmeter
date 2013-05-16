module Gridinit
  module Jmeter

    class SoapSampler
      attr_accessor :doc
      include Helper
      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <SoapSampler guiclass="SoapSamplerGui" testclass="SoapSampler" testname="#{name}" enabled="true">
            <elementProp name="HTTPsampler.Arguments" elementType="Arguments">
              <collectionProp name="Arguments.arguments"/>
            </elementProp>
            <stringProp name="SoapSampler.URL_DATA"></stringProp>
            <stringProp name="HTTPSamper.xml_data"></stringProp>
            <stringProp name="SoapSampler.xml_data_file"></stringProp>
            <stringProp name="SoapSampler.SOAP_ACTION"></stringProp>
            <stringProp name="SoapSampler.SEND_SOAP_ACTION">true</stringProp>
            <boolProp name="HTTPSampler.use_keepalive">false</boolProp>
          </SoapSampler>
        EOF
        update params
      end
    end  

  end
end
