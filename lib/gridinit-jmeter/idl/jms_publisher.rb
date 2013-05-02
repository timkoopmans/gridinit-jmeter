module Gridinit
  module Jmeter

    class DSL
      def jms_publisher(params={}, &block)
        node = Gridinit::Jmeter::JmsPublisher.new(params)
        attach_node(node, &block)
      end
    end

    class JmsPublisher
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<PublisherSampler guiclass="JMSPublisherGui" testclass="PublisherSampler" testname="#{name}" enabled="true">
  <stringProp name="jms.jndi_properties">false</stringProp>
  <stringProp name="jms.initial_context_factory"/>
  <stringProp name="jms.provider_url"/>
  <stringProp name="jms.connection_factory"/>
  <stringProp name="jms.topic"/>
  <stringProp name="jms.security_principle"/>
  <stringProp name="jms.security_credentials"/>
  <stringProp name="jms.text_message"/>
  <stringProp name="jms.input_file"/>
  <stringProp name="jms.random_path"/>
  <stringProp name="jms.config_choice">jms_use_text</stringProp>
  <stringProp name="jms.config_msg_type">jms_text_message</stringProp>
  <stringProp name="jms.iterations">1</stringProp>
  <boolProp name="jms.authenticate">false</boolProp>
  <elementProp name="jms.jmsProperties" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{name}" enabled="true">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
</PublisherSampler>)
        EOS
        update params
      end
    end

  end
end
