module Gridinit
  module Jmeter

    class DSL
      def generate_summary_results(params={}, &block)
        node = Gridinit::Jmeter::GenerateSummaryResults.new(params)
        attach_node(node, &block)
      end
    end

    class GenerateSummaryResults
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<Summariser guiclass="SummariserGui" testclass="Summariser" testname="#{name}" enabled="true"/>)
        EOS
        update params
      end
    end

  end
end
