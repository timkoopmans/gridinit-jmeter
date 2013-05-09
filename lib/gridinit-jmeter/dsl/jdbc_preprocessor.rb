module Gridinit
  module Jmeter

    class DSL
      def jdbc_preprocessor(params={}, &block)
        node = Gridinit::Jmeter::JdbcPreprocessor.new(params)
        attach_node(node, &block)
      end
    end

    class JdbcPreprocessor
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JDBCPreProcessor guiclass="TestBeanGUI" testclass="JDBCPreProcessor" testname="#{name}" enabled="true">
  <stringProp name="dataSource"/>
  <stringProp name="query"/>
  <stringProp name="queryArguments"/>
  <stringProp name="queryArgumentsTypes"/>
  <stringProp name="queryType">Select Statement</stringProp>
  <stringProp name="resultVariable"/>
  <stringProp name="variableNames"/>
</JDBCPreProcessor>)
        EOS
        update params
      end
    end

  end
end
