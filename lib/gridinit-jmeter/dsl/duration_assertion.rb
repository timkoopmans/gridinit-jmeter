module Gridinit
  module Jmeter

    class DSL
      def duration_assertion(params={}, &block)
        node = Gridinit::Jmeter::DurationAssertion.new(params)
        attach_node(node, &block)
      end
    end

    class DurationAssertion
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<DurationAssertion guiclass="DurationAssertionGui" testclass="DurationAssertion" testname="#{name}" enabled="true">
  <stringProp name="DurationAssertion.duration"/>
</DurationAssertion>)
        EOS
        update params
      end
    end

  end
end
