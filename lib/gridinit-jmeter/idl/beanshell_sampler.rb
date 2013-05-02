module Gridinit
  module Jmeter

    class DSL
      def beanshell_sampler(params={}, &block)
        node = Gridinit::Jmeter::BeanshellSampler.new(params)
        attach_node(node, &block)
      end
    end

    class BeanshellSampler
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BeanShellSampler guiclass="BeanShellSamplerGui" testclass="BeanShellSampler" testname="#{name}" enabled="true">
  <stringProp name="BeanShellSampler.query"/>
  <stringProp name="BeanShellSampler.filename"/>
  <stringProp name="BeanShellSampler.parameters"/>
  <boolProp name="BeanShellSampler.resetInterpreter">false</boolProp>
</BeanShellSampler>)
        EOS
        update params
      end
    end

  end
end
