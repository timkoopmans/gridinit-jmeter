module Gridinit
  module Jmeter

    class DSL
      def jdbc_postprocessor(params={}, &block)
        node = Gridinit::Jmeter::JdbcPostprocessor.new(params)
        attach_node(node, &block)
      end
    end

    class JdbcPostprocessor
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JDBCPostProcessor guiclass="TestBeanGUI" testclass="JDBCPostProcessor" testname="#{name}" enabled="true">
  <stringProp name="dataSource"/>
  <stringProp name="query"/>
  <stringProp name="queryArguments"/>
  <stringProp name="queryArgumentsTypes"/>
  <stringProp name="queryType">Select Statement</stringProp>
  <stringProp name="resultVariable"/>
  <stringProp name="variableNames"/>
</JDBCPostProcessor>)
        EOS
        update params
      end
    end

  end
end
