module Gridinit
  module Jmeter

    class DSL
      def tcp_sampler_config(params={}, &block)
        node = Gridinit::Jmeter::TcpSamplerConfig.new(params)
        attach_node(node, &block)
      end
    end

    class TcpSamplerConfig
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ConfigTestElement guiclass="TCPConfigGui" testclass="ConfigTestElement" testname="#{name}" enabled="true">
  <stringProp name="TCPSampler.server"/>
  <boolProp name="TCPSampler.reUseConnection">true</boolProp>
  <stringProp name="TCPSampler.port"/>
  <boolProp name="TCPSampler.nodelay">false</boolProp>
  <stringProp name="TCPSampler.timeout"/>
  <stringProp name="TCPSampler.request"/>
  <boolProp name="TCPSampler.closeConnection">false</boolProp>
</ConfigTestElement>)
        EOS
        update params
      end
    end

  end
end
