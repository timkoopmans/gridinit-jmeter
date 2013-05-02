module Gridinit
  module Jmeter

    class DSL
      def http_request_defaults(params={}, &block)
        node = Gridinit::Jmeter::HttpRequestDefaults.new(params)
        attach_node(node, &block)
      end
    end

    class HttpRequestDefaults
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ConfigTestElement guiclass="HttpDefaultsGui" testclass="ConfigTestElement" testname="#{name}" enabled="true">
  <elementProp name="HTTPsampler.Arguments" elementType="Arguments" guiclass="HTTPArgumentsPanel" testclass="Arguments" testname="#{name}" enabled="true">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
  <stringProp name="HTTPSampler.domain"/>
  <stringProp name="HTTPSampler.port"/>
  <stringProp name="HTTPSampler.connect_timeout"/>
  <stringProp name="HTTPSampler.response_timeout"/>
  <stringProp name="HTTPSampler.protocol"/>
  <stringProp name="HTTPSampler.contentEncoding"/>
  <stringProp name="HTTPSampler.path"/>
  <stringProp name="HTTPSampler.concurrentPool">4</stringProp>
</ConfigTestElement>)
        EOS
        update params
      end
    end

  end
end
