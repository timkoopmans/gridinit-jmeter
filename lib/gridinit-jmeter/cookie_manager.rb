module Gridinit
  module Jmeter

    class CookieManager
      attr_accessor :doc
      def initialize(params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <CookieManager guiclass="CookiePanel" testclass="CookieManager" testname="HTTP Cookie Manager" enabled="true">
            <collectionProp name="CookieManager.cookies"/>
            <boolProp name="CookieManager.clearEachIteration">#{params[:clear_each_iteration] ? 'true' : 'false'}</boolProp>
            <stringProp name="CookieManager.policy">default</stringProp>
          </CookieManager>
        EOF
        params.delete :clear_each_iteration
        params.each do |name, value|
          node = @doc.children.xpath("//*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = value unless node.empty? 
        end
      end
    end  

  end
end