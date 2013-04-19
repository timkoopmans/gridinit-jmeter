module Gridinit
  module Jmeter

    class ViewResultsFullVisualizer
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <ResultCollector guiclass="ViewResultsFullVisualizer" testclass="ResultCollector" testname="#{name}" enabled="#{enabled(params)}">
            <boolProp name="ResultCollector.error_logging">#{error_only(params)}</boolProp>
            <objProp>
              <name>saveConfig</name>
              <value class="SampleSaveConfiguration">
                <time>true</time>
                <latency>true</latency>
                <timestamp>true</timestamp>
                <success>true</success>
                <label>true</label>
                <code>true</code>
                <message>true</message>
                <threadName>true</threadName>
                <dataType>true</dataType>
                <encoding>false</encoding>
                <assertions>true</assertions>
                <subresults>true</subresults>
                <responseData>false</responseData>
                <samplerData>false</samplerData>
                <xml>true</xml>
                <fieldNames>false</fieldNames>
                <responseHeaders>false</responseHeaders>
                <requestHeaders>false</requestHeaders>
                <responseDataOnError>false</responseDataOnError>
                <saveAssertionResultsFailureMessage>false</saveAssertionResultsFailureMessage>
                <assertionsResultsToSave>0</assertionsResultsToSave>
                <bytes>true</bytes>
              </value>
            </objProp>
            <stringProp name="filename"></stringProp>
          </ResultCollector>
        EOF
        update params
      end

      def error_only(params)
        #default to true unless explicitly set to false
        if params.has_key?(:error_only) && params[:error_only] == true
          'true'
        else
          'false'
        end
      end
    end


  end
end
