module Gridinit
  module Jmeter

    class InterleaveController
      attr_accessor :doc
      include Helper
      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
        <InterleaveControl guiclass="InterleaveControlGui" testclass="InterleaveControl" testname="#{name}" enabled="true">
          <intProp name="InterleaveControl.style">1</intProp>
        </InterleaveControl>
        EOF
        update params
      end
    end  

  end
end
