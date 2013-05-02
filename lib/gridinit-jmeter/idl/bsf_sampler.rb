module Gridinit
  module Jmeter

    class DSL
      def bsf_sampler(params={}, &block)
        node = Gridinit::Jmeter::BsfSampler.new(params)
        attach_node(node, &block)
      end
    end

    class BsfSampler
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BSFSampler guiclass="TestBeanGUI" testclass="BSFSampler" testname="#{name}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</BSFSampler>)
        EOS
        update params
      end
    end

  end
end
