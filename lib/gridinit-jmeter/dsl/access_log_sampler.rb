module Gridinit
  module Jmeter

    class DSL
      def access_log_sampler(params={}, &block)
        node = Gridinit::Jmeter::AccessLogSampler.new(params)
        attach_node(node, &block)
      end
    end

    class AccessLogSampler
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<AccessLogSampler guiclass="TestBeanGUI" testclass="AccessLogSampler" testname="#{name}" enabled="true">
  <elementProp name="HTTPsampler.Arguments" elementType="Arguments">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
  <stringProp name="domain"/>
  <boolProp name="imageParsing">false</boolProp>
  <stringProp name="logFile"/>
  <stringProp name="parserClassName">org.apache.jmeter.protocol.http.util.accesslog.TCLogParser</stringProp>
  <stringProp name="portString"/>
</AccessLogSampler>)
        EOS
        update params
      end
    end

  end
end
