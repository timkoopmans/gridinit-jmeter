module Gridinit
  module Jmeter

    class DSL
      def md5hex_assertion(params={}, &block)
        node = Gridinit::Jmeter::Md5hexAssertion.new(params)
        attach_node(node, &block)
      end
    end

    class Md5hexAssertion
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<MD5HexAssertion guiclass="MD5HexAssertionGUI" testclass="MD5HexAssertion" testname="#{name}" enabled="true">
  <stringProp name="MD5HexAssertion.size"/>
</MD5HexAssertion>)
        EOS
        update params
      end
    end

  end
end
