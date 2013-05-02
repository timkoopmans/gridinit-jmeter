module Gridinit
  module Jmeter

    class DSL
      def save_responses_to_a_file(params={}, &block)
        node = Gridinit::Jmeter::SaveResponsesToAFile.new(params)
        attach_node(node, &block)
      end
    end

    class SaveResponsesToAFile
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ResultSaver guiclass="ResultSaverGui" testclass="ResultSaver" testname="#{name}" enabled="true">
  <stringProp name="FileSaver.filename"/>
  <boolProp name="FileSaver.errorsonly">false</boolProp>
  <boolProp name="FileSaver.skipautonumber">false</boolProp>
  <boolProp name="FileSaver.skipsuffix">false</boolProp>
  <boolProp name="FileSaver.successonly">false</boolProp>
</ResultSaver>)
        EOS
        update params
      end
    end

  end
end
