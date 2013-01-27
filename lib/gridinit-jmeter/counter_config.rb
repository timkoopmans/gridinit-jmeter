module Gridinit
  module Jmeter

    class CounterConfig
      attr_accessor :doc
      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <CounterConfig guiclass="CounterConfigGui" testclass="CounterConfig" testname="#{name}" enabled="true">
            <stringProp name="CounterConfig.start">1</stringProp>
            <stringProp name="CounterConfig.end"></stringProp>
            <stringProp name="CounterConfig.incr">1</stringProp>
            <stringProp name="CounterConfig.name">#{name}</stringProp>
            <stringProp name="CounterConfig.format"></stringProp>
            <boolProp name="CounterConfig.per_user">true</boolProp>
            <boolProp name="CounterConfig.reset_on_tg_iteration">true</boolProp>
          </CounterConfig>
        EOF
        params.each do |name, value|
          node = @doc.children.xpath("//*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = value unless node.empty? 
        end
      end
    end  

  end
end