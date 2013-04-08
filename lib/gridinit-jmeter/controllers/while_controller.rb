module Gridinit
  module Jmeter

    class WhileController
      attr_accessor :doc
      include Helper
      def initialize(condition, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <WhileController guiclass="WhileControllerGui" testclass="WhileController" testname="While Controller" enabled="true">
            <stringProp name="WhileController.condition">#{condition}</stringProp>
          </WhileController>
          EOF
        update params
      end
    end

  end
end
