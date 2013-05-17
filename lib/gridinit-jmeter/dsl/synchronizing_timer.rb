module Gridinit
  module Jmeter

    class DSL
      def synchronizing_timer(params, &block)
        node = Gridinit::Jmeter::SynchronizingTimer.new(params)
        attach_node(node, &block)
      end
    end

    class SynchronizingTimer
      attr_accessor :doc
      include Helper

      def initialize(params={})
        params[:name] ||= 'SynchronizingTimer'
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<SyncTimer guiclass="TestBeanGUI" testclass="SyncTimer" testname="#{params[:name]}" enabled="true">
  <intProp name="groupSize">0</intProp>
</SyncTimer>)
        EOS
        update params
        update_at_xpath params if params[:update_at_xpath]
      end
    end

  end
end
