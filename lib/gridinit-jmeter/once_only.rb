module Gridinit
  module Jmeter

    class OnceOnly
      attr_accessor :doc
      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <OnceOnlyController guiclass="OnceOnlyControllerGui" testclass="OnceOnlyController" testname="#{name}" enabled="true">
          </OnceOnlyController>
        EOF
        params.each do |name, value|
          node = @doc.children.xpath("//*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = value unless node.empty? 
        end
      end
    end  

  end
end