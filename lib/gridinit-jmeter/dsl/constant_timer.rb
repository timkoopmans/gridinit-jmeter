module Gridinit
  module Jmeter

    class DSL
      def constant_timer(params={}, &block)
        node = Gridinit::Jmeter::ConstantTimer.new(params)
        attach_node(node, &block)
      end
    end

    class ConstantTimer
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ConstantTimer guiclass="ConstantTimerGui" testclass="ConstantTimer" testname="#{name}" enabled="true">
  <stringProp name="ConstantTimer.delay">300</stringProp>
</ConstantTimer>)
        EOS
        update params
      end
    end

  end
end
