module Gridinit
  module Jmeter

    class DSL
      def login_config_element(params={}, &block)
        node = Gridinit::Jmeter::LoginConfigElement.new(params)
        attach_node(node, &block)
      end
    end

    class LoginConfigElement
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ConfigTestElement guiclass="LoginConfigGui" testclass="ConfigTestElement" testname="#{name}" enabled="true">
  <stringProp name="ConfigTestElement.username"/>
  <stringProp name="ConfigTestElement.password"/>
</ConfigTestElement>)
        EOS
        update params
      end
    end

  end
end
