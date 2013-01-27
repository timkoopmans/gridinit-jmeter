module Gridinit
  module Jmeter

    class LDAPExtSampler
      attr_accessor :doc
      include Helper
      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <LDAPExtSampler guiclass="LdapExtTestSamplerGui" testclass="LDAPExtSampler" testname="#{name}" enabled="true">
            <stringProp name="servername"></stringProp>
            <stringProp name="port">389</stringProp>
            <stringProp name="rootdn"></stringProp>
            <stringProp name="scope">2</stringProp>
            <stringProp name="countlimit"></stringProp>
            <stringProp name="timelimit"></stringProp>
            <stringProp name="attributes"></stringProp>
            <stringProp name="return_object">false</stringProp>
            <stringProp name="deref_aliases">false</stringProp>
            <stringProp name="connection_timeout"></stringProp>
            <stringProp name="parseflag">false</stringProp>
            <stringProp name="secure">false</stringProp>
            <stringProp name="user_dn"></stringProp>
            <stringProp name="user_pw"></stringProp>
            <stringProp name="comparedn"></stringProp>
            <stringProp name="comparefilt"></stringProp>
            <stringProp name="modddn"></stringProp>
            <stringProp name="newdn"></stringProp>
            <stringProp name="test">bind</stringProp>
          </LDAPExtSampler>
        EOF
        update params
      end
    end  

  end
end
