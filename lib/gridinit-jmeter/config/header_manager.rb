module Gridinit
  module Jmeter

    class HeaderManager
      attr_accessor :doc
      include Helper
      def initialize(params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <HeaderManager guiclass="HeaderPanel" testclass="HeaderManager" testname="HTTP Header Manager" enabled="true">
            <collectionProp name="HeaderManager.headers"/>
          </HeaderManager>
        EOF
        params.each do |name, value|
          @doc.at_xpath('//collectionProp') << 
            Nokogiri::XML(<<-EOF.strip_heredoc).children
              <elementProp name="" elementType="Header">
                <stringProp name="Header.name">#{name}</stringProp>
                <stringProp name="Header.value">#{value}</stringProp>
              </elementProp>
            EOF
        end
      end
    end  

  end
end
