module Gridinit
  module Jmeter

    class RandomOrderController
      attr_accessor :doc
      include Helper
      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <RandomOrderController guiclass="RandomOrderControllerGui" testclass="RandomOrderController" testname="#{name}" enabled="true"/>
        EOF
        update params
      end
    end  

  end
end
