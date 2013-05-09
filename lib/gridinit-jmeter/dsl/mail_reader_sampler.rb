module Gridinit
  module Jmeter

    class DSL
      def mail_reader_sampler(params={}, &block)
        node = Gridinit::Jmeter::MailReaderSampler.new(params)
        attach_node(node, &block)
      end
    end

    class MailReaderSampler
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<MailReaderSampler guiclass="MailReaderSamplerGui" testclass="MailReaderSampler" testname="#{name}" enabled="true">
  <stringProp name="host_type">pop3</stringProp>
  <stringProp name="folder">INBOX</stringProp>
  <stringProp name="host"/>
  <stringProp name="username"/>
  <stringProp name="password"/>
  <intProp name="num_messages">-1</intProp>
  <boolProp name="delete">false</boolProp>
  <stringProp name="SMTPSampler.useSSL">false</stringProp>
  <stringProp name="SMTPSampler.useStartTLS">false</stringProp>
  <stringProp name="SMTPSampler.trustAllCerts">false</stringProp>
  <stringProp name="SMTPSampler.enforceStartTLS">false</stringProp>
  <stringProp name="SMTPSampler.useLocalTrustStore">false</stringProp>
  <stringProp name="SMTPSampler.trustStoreToUse"/>
</MailReaderSampler>)
        EOS
        update params
      end
    end

  end
end
