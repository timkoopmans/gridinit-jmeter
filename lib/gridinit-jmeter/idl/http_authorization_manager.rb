module Gridinit
  module Jmeter

    class DSL
      def http_authorization_manager(params={}, &block)
        node = Gridinit::Jmeter::HttpAuthorizationManager.new(params)
        attach_node(node, &block)
      end
    end

    class HttpAuthorizationManager
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<AuthManager guiclass="AuthPanel" testclass="AuthManager" testname="#{name}" enabled="true">
  <collectionProp name="AuthManager.auth_list"/>
</AuthManager>)
        EOS
        update params
      end
    end

  end
end
