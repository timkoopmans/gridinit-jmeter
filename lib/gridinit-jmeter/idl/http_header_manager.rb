module Gridinit
  module Jmeter

    class DSL
      def http_header_manager(params={}, &block)
        node = Gridinit::Jmeter::HttpHeaderManager.new(params)
        attach_node(node, &block)
      end
    end

    class HttpHeaderManager
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<HeaderManager guiclass="HeaderPanel" testclass="HeaderManager" testname="#{name}" enabled="true">
  <collectionProp name="HeaderManager.headers"/>
</HeaderManager>)
        EOS
        update params
      end
    end

  end
end
