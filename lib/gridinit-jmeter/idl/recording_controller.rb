module Gridinit
  module Jmeter

    class DSL
      def recording_controller(params={}, &block)
        node = Gridinit::Jmeter::RecordingController.new(params)
        attach_node(node, &block)
      end
    end

    class RecordingController
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<RecordingController guiclass="RecordController" testclass="RecordingController" testname="#{name}" enabled="true"/>)
        EOS
        update params
      end
    end

  end
end
