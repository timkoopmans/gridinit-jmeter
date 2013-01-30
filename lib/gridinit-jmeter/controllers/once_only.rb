module Gridinit
  module Jmeter

    class OnceOnly
      attr_accessor :doc
      include Helper
      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <OnceOnlyController guiclass="OnceOnlyControllerGui" testclass="OnceOnlyController" testname="#{name}" enabled="true">
          </OnceOnlyController>
        EOF
        update params
      end
    end  

  end
end
