module Gridinit
  module Jmeter

    class DSL
      def csv_data_set_config(params={}, &block)
        node = Gridinit::Jmeter::CsvDataSetConfig.new(params)
        attach_node(node, &block)
      end
    end

    class CsvDataSetConfig
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<CSVDataSet guiclass="TestBeanGUI" testclass="CSVDataSet" testname="#{name}" enabled="true">
  <stringProp name="delimiter">,</stringProp>
  <stringProp name="fileEncoding"/>
  <stringProp name="filename"/>
  <boolProp name="quotedData">false</boolProp>
  <boolProp name="recycle">true</boolProp>
  <stringProp name="shareMode">All threads</stringProp>
  <boolProp name="stopThread">false</boolProp>
  <stringProp name="variableNames"/>
</CSVDataSet>)
        EOS
        update params
      end
    end

  end
end
