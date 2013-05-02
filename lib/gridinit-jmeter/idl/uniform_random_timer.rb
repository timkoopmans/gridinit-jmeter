module Gridinit
  module Jmeter

    class DSL
      def uniform_random_timer(params={}, &block)
        node = Gridinit::Jmeter::UniformRandomTimer.new(params)
        attach_node(node, &block)
      end
    end

    class UniformRandomTimer
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<UniformRandomTimer guiclass="UniformRandomTimerGui" testclass="UniformRandomTimer" testname="#{name}" enabled="true">
  <stringProp name="ConstantTimer.delay">0</stringProp>
  <stringProp name="RandomTimer.range">100.0</stringProp>
</UniformRandomTimer>)
        EOS
        update params
      end
    end

  end
end
