module Gridinit
  module Jmeter

    class DSL
      def ldap_request(params={}, &block)
        node = Gridinit::Jmeter::LdapRequest.new(params)
        attach_node(node, &block)
      end
    end

    class LdapRequest
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<LDAPSampler guiclass="LdapTestSamplerGui" testclass="LDAPSampler" testname="#{name}" enabled="true">
  <stringProp name="servername"/>
  <stringProp name="port"/>
  <stringProp name="rootdn"/>
  <boolProp name="user_defined">false</boolProp>
  <stringProp name="test">add</stringProp>
  <stringProp name="base_entry_dn"/>
  <elementProp name="arguments" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{name}" enabled="true">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
  <stringProp name="ConfigTestElement.username"/>
  <stringProp name="ConfigTestElement.password"/>
</LDAPSampler>)
        EOS
        update params
      end
    end

  end
end
