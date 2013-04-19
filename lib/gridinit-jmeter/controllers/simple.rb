module Gridinit
  module Jmeter

    class SimpleController
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <GenericController guiclass="LogicControllerGui" testclass="GenericController" testname="#{name}" enabled="true"/>
        EOF
        update params
      end
    end

  end
end
