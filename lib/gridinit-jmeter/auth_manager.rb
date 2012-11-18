module Gridinit
  module Jmeter

    class AuthManager
      attr_accessor :doc
      def initialize(params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <AuthManager guiclass="AuthPanel" testclass="AuthManager" testname="HTTP Authorization Manager" enabled="true">
            <collectionProp name="AuthManager.auth_list">
              <elementProp name="" elementType="Authorization">
                <stringProp name="Authorization.url">/</stringProp>
                <stringProp name="Authorization.username"></stringProp>
                <stringProp name="Authorization.password"></stringProp>
                <stringProp name="Authorization.domain"></stringProp>
                <stringProp name="Authorization.realm"></stringProp>
              </elementProp>
            </collectionProp>
          </AuthManager>
        EOF
        params.each do |name, value|
          node = @doc.children.xpath("//*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = value unless node.empty? 
        end
      end
    end  

  end
end