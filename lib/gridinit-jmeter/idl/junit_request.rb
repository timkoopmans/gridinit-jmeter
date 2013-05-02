module Gridinit
  module Jmeter

    class DSL
      def junit_request(params={}, &block)
        node = Gridinit::Jmeter::JunitRequest.new(params)
        attach_node(node, &block)
      end
    end

    class JunitRequest
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JUnitSampler guiclass="JUnitTestSamplerGui" testclass="JUnitSampler" testname="#{name}" enabled="true">
  <stringProp name="junitSampler.classname">test.RerunTest</stringProp>
  <stringProp name="junitsampler.constructorstring"/>
  <stringProp name="junitsampler.method">testRerun</stringProp>
  <stringProp name="junitsampler.pkg.filter"/>
  <stringProp name="junitsampler.success">Test successful</stringProp>
  <stringProp name="junitsampler.success.code">1000</stringProp>
  <stringProp name="junitsampler.failure">Test failed</stringProp>
  <stringProp name="junitsampler.failure.code">0001</stringProp>
  <stringProp name="junitsampler.error">An unexpected error occured</stringProp>
  <stringProp name="junitsampler.error.code">9999</stringProp>
  <stringProp name="junitsampler.exec.setup">false</stringProp>
  <stringProp name="junitsampler.append.error">false</stringProp>
  <stringProp name="junitsampler.append.exception">false</stringProp>
</JUnitSampler>)
        EOS
        update params
      end
    end

  end
end
