module Gridinit
  module Jmeter

    class CacheManager
      attr_accessor :doc
      def initialize(params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <CacheManager guiclass="CacheManagerGui" testclass="CacheManager" testname="HTTP Cache Manager" enabled="true">
            <boolProp name="clearEachIteration">#{params[:clear_each_iteration] ? 'true' : 'false'}</boolProp>
            <boolProp name="useExpires">#{params[:use_expires] ? 'true' : 'false'}</boolProp>
          </CacheManager>
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