module Gridinit
  module Jmeter

    class DSL
      def synchronizing_timer(params={}, &block)
        node = Gridinit::Jmeter::SynchronizingTimer.new(params)
        attach_node(node, &block)
      end
    end

    class SynchronizingTimer
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<SyncTimer guiclass="TestBeanGUI" testclass="SyncTimer" testname="#{name}" enabled="true">
  <intProp name="groupSize">0</intProp>
</SyncTimer>)
        EOS
        update params
      end
    end

  end
end
