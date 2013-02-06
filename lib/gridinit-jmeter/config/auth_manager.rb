module Gridinit
  module Jmeter

    class AuthManager
      attr_accessor :doc
      include Helper
      def initialize(params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <AuthManager guiclass="AuthPanel" testclass="AuthManager" testname="HTTP Authorization Manager" enabled="true">
            <collectionProp name="AuthManager.auth_list">
              <elementProp name="" elementType="Authorization">
                <stringProp name="Authorization.url"></stringProp>
                <stringProp name="Authorization.username"></stringProp>
                <stringProp name="Authorization.password"></stringProp>
                <stringProp name="Authorization.domain"></stringProp>
                <stringProp name="Authorization.realm"></stringProp>
              </elementProp>
            </collectionProp>
          </AuthManager>
        EOF
        update params
      end
    end  

  end
end
