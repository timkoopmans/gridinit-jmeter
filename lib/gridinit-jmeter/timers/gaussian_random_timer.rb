module Gridinit
  module Jmeter

    class GaussianRandomTimer
      attr_accessor :doc
      include Helper
      def initialize(delay, range)
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <GaussianRandomTimer guiclass="GaussianRandomTimerGui" testclass="GaussianRandomTimer" testname="Think Time" enabled="true">
            <stringProp name="ConstantTimer.delay">#{delay}</stringProp>
            <stringProp name="RandomTimer.range">#{range}</stringProp>
          </GaussianRandomTimer>
        EOF
      end
    end 

  end
end
