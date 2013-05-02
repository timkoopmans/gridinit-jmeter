module Gridinit
  module Jmeter

    class DSL
      def poisson_random_timer(params={}, &block)
        node = Gridinit::Jmeter::PoissonRandomTimer.new(params)
        attach_node(node, &block)
      end
    end

    class PoissonRandomTimer
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<PoissonRandomTimer guiclass="PoissonRandomTimerGui" testclass="PoissonRandomTimer" testname="#{name}" enabled="true">
  <stringProp name="ConstantTimer.delay">300</stringProp>
  <stringProp name="RandomTimer.range">100</stringProp>
</PoissonRandomTimer>)
        EOS
        update params
      end
    end

  end
end
