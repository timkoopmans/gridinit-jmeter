module Gridinit
  module Jmeter

    class DSL
      def ftp_request(params={}, &block)
        node = Gridinit::Jmeter::FtpRequest.new(params)
        attach_node(node, &block)
      end
    end

    class FtpRequest
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<FTPSampler guiclass="FtpTestSamplerGui" testclass="FTPSampler" testname="#{name}" enabled="true">
  <stringProp name="FTPSampler.server"/>
  <stringProp name="FTPSampler.port"/>
  <stringProp name="FTPSampler.filename"/>
  <stringProp name="FTPSampler.localfilename"/>
  <stringProp name="FTPSampler.inputdata"/>
  <boolProp name="FTPSampler.binarymode">false</boolProp>
  <boolProp name="FTPSampler.saveresponse">false</boolProp>
  <boolProp name="FTPSampler.upload">false</boolProp>
  <stringProp name="ConfigTestElement.username"/>
  <stringProp name="ConfigTestElement.password"/>
</FTPSampler>)
        EOS
        update params
      end
    end

  end
end
