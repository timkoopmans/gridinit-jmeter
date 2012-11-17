module Gridinit
  module Jmeter

    class GaussianRandomTimer
      attr_accessor :doc
      def initialize(params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <GaussianRandomTimer guiclass="GaussianRandomTimerGui" testclass="GaussianRandomTimer" testname="Think Time" enabled="true">
            <stringProp name="ConstantTimer.delay"></stringProp>
            <stringProp name="RandomTimer.range"></stringProp>
          </GaussianRandomTimer>
        EOF
        params.each do |name, value|
          node = @doc.children.xpath("//*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = value unless node.empty? 
        end
      end
    end 

  end
end