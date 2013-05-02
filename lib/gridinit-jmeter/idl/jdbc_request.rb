module Gridinit
  module Jmeter

    class DSL
      def jdbc_request(params={}, &block)
        node = Gridinit::Jmeter::JdbcRequest.new(params)
        attach_node(node, &block)
      end
    end

    class JdbcRequest
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JDBCSampler guiclass="TestBeanGUI" testclass="JDBCSampler" testname="#{name}" enabled="true">
  <stringProp name="dataSource"/>
  <stringProp name="query"/>
  <stringProp name="queryArguments"/>
  <stringProp name="queryArgumentsTypes"/>
  <stringProp name="queryType">Select Statement</stringProp>
  <stringProp name="resultVariable"/>
  <stringProp name="variableNames"/>
</JDBCSampler>)
        EOS
        update params
      end
    end

  end
end
