module Gridinit
  module Jmeter

    class DSL
      def keystore_configuration(params={}, &block)
        node = Gridinit::Jmeter::KeystoreConfiguration.new(params)
        attach_node(node, &block)
      end
    end

    class KeystoreConfiguration
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<KeystoreConfig guiclass="TestBeanGUI" testclass="KeystoreConfig" testname="#{name}" enabled="true">
  <stringProp name="endIndex"/>
  <stringProp name="preload">True</stringProp>
  <stringProp name="startIndex"/>
</KeystoreConfig>)
        EOS
        update params
      end
    end

  end
end
