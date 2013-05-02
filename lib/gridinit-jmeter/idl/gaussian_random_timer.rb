module Gridinit
  module Jmeter

    class DSL
      def gaussian_random_timer(params={}, &block)
        node = Gridinit::Jmeter::GaussianRandomTimer.new(params)
        attach_node(node, &block)
      end
    end

    class GaussianRandomTimer
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<GaussianRandomTimer guiclass="GaussianRandomTimerGui" testclass="GaussianRandomTimer" testname="#{name}" enabled="true">
  <stringProp name="ConstantTimer.delay">300</stringProp>
  <stringProp name="RandomTimer.range">100.0</stringProp>
</GaussianRandomTimer>)
        EOS
        update params
      end
    end

  end
end
