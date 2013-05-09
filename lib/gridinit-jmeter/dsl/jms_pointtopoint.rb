module Gridinit
  module Jmeter

    class DSL
      def jms_pointtopoint(params={}, &block)
        node = Gridinit::Jmeter::JmsPointtopoint.new(params)
        attach_node(node, &block)
      end
    end

    class JmsPointtopoint
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JMSSampler guiclass="JMSSamplerGui" testclass="JMSSampler" testname="#{name}" enabled="true">
  <stringProp name="JMSSampler.queueconnectionfactory"/>
  <stringProp name="JMSSampler.SendQueue"/>
  <stringProp name="JMSSampler.ReceiveQueue"/>
  <boolProp name="JMSSampler.isFireAndForget">true</boolProp>
  <boolProp name="JMSSampler.isNonPersistent">false</boolProp>
  <boolProp name="JMSSampler.useReqMsgIdAsCorrelId">false</boolProp>
  <stringProp name="JMSSampler.timeout"/>
  <stringProp name="HTTPSamper.xml_data"/>
  <stringProp name="JMSSampler.initialContextFactory"/>
  <stringProp name="JMSSampler.contextProviderUrl"/>
  <elementProp name="JMSSampler.jndiProperties" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{name}" enabled="true">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
  <elementProp name="arguments" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{name}" enabled="true">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
</JMSSampler>)
        EOS
        update params
      end
    end

  end
end
