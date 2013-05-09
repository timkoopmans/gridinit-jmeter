module Gridinit
  module Jmeter

    class DSL
      def http_cookie_manager(params={}, &block)
        node = Gridinit::Jmeter::HttpCookieManager.new(params)
        attach_node(node, &block)
      end
    end

    class HttpCookieManager
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<CookieManager guiclass="CookiePanel" testclass="CookieManager" testname="#{name}" enabled="true">
  <collectionProp name="CookieManager.cookies"/>
  <boolProp name="CookieManager.clearEachIteration">false</boolProp>
</CookieManager>)
        EOS
        update params
      end
    end

  end
end
