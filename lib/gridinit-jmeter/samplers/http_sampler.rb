module Gridinit
  module Jmeter

    class HttpSampler
      attr_accessor :doc
      include Helper
      def initialize(name, url, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <HTTPSamplerProxy guiclass="HttpTestSampleGui" testclass="HTTPSamplerProxy" testname="#{name}" enabled="true">
            <elementProp name="HTTPsampler.Arguments" elementType="Arguments" guiclass="HTTPArgumentsPanel" testclass="Arguments" testname="User Defined Variables" enabled="true">
              <collectionProp name="Arguments.arguments"/>
            </elementProp>
            <stringProp name="HTTPSampler.domain"></stringProp>
            <stringProp name="HTTPSampler.port"></stringProp>
            <stringProp name="HTTPSampler.connect_timeout"></stringProp>
            <stringProp name="HTTPSampler.response_timeout"></stringProp>
            <stringProp name="HTTPSampler.protocol"></stringProp>
            <stringProp name="HTTPSampler.contentEncoding"></stringProp>
            <stringProp name="HTTPSampler.path">/</stringProp>
            <stringProp name="HTTPSampler.method">GET</stringProp>
            <boolProp name="HTTPSampler.follow_redirects">true</boolProp>
            <boolProp name="HTTPSampler.auto_redirects">false</boolProp>
            <boolProp name="HTTPSampler.use_keepalive">true</boolProp>
            <boolProp name="HTTPSampler.DO_MULTIPART_POST">false</boolProp>
            <boolProp name="HTTPSampler.monitor">false</boolProp>
            <boolProp name="HTTPSampler.image_parser">false</boolProp>
            <stringProp name="HTTPSampler.embedded_url_re"></stringProp>
            <boolProp name="HTTPSampler.concurrentDwn">false</boolProp>
            <stringProp name="HTTPSampler.concurrentPool">4</stringProp>
          </HTTPSamplerProxy>
        EOF
        parse_url(url, params) unless url.empty?
        fill_in(params)  if params[:fill_in]
        raw_body(params) if params[:raw_body]
        if params[:raw_path]
          params[:path] = url
        else
          params[:params] && params[:params].split('&').each do |param| 
            name,value = param.split('=')
            fill_in({ :fill_in => { "#{name}" => value }, :always_encode => params[:always_encode] })
          end
        end

        update params
      end

      def parse_uri(url)
        URI.parse(URI::encode(url)).scheme.nil? ? URI.parse(URI::encode("http://#{url}")) : URI.parse(URI::encode(url))   
      end

      def parse_url(url, params)
        if url[0] == '$'
          params[:path] = url # special case for named expressions
        else 
          uri               = parse_uri(url)
          params[:port]     ||= uri.port unless URI.parse(URI::encode(url)).scheme.nil?
          params[:protocol] ||= uri.scheme unless URI.parse(URI::encode(url)).scheme.nil?
          params[:domain]   ||= uri.host
          params[:path]     ||= uri.path && URI::decode(uri.path)
          params[:params]   ||= uri.query && URI::decode(uri.query)
        end
      end

      def fill_in(params)
        params[:fill_in].each do |name, value|
          @doc.at_xpath('//collectionProp') << 
            Nokogiri::XML(<<-EOF.strip_heredoc).children
              <elementProp name="#{name}" elementType="HTTPArgument">
                <boolProp name="HTTPArgument.always_encode">#{params[:always_encode] ? 'true' : false}</boolProp>
                <stringProp name="Argument.value">#{value}</stringProp>
                <stringProp name="Argument.metadata">=</stringProp>
                <boolProp name="HTTPArgument.use_equals">true</boolProp>
                <stringProp name="Argument.name">#{name}</stringProp>
              </elementProp>
              EOF
        end
        params.delete :fill_in
      end

      def raw_body(params)
        @doc.at_xpath('//HTTPSamplerProxy') << 
          Nokogiri::XML(<<-EOF.strip_heredoc).children
            <boolProp name="HTTPSampler.postBodyRaw">true</boolProp>
            EOF
        @doc.at_xpath('//collectionProp') << 
          Nokogiri::XML(<<-EOF.strip_heredoc).children  
            <elementProp name="" elementType="HTTPArgument">
              <boolProp name="HTTPArgument.always_encode">false</boolProp>
              <stringProp name="Argument.value">#{params[:raw_body]}</stringProp>
              <stringProp name="Argument.metadata">=</stringProp>
            </elementProp>
            EOF
        params.delete :raw_body
      end

    end  

  end
end
