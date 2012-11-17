require 'rubygems'
require 'nokogiri'
require 'docile'
require 'active_attr'
require 'active_support/core_ext'
require 'logger/colors'
require 'tree'

module Gridinit
  module Jmeter

    class DSL
      attr_accessor :test, :threads

      def initialize
        @root = Nokogiri::XML(<<-EOF.strip_heredoc)
          <?xml version="1.0" encoding="UTF-8"?>
          <jmeterTestPlan version="1.2" properties="2.1">
          <hashTree>
          </hashTree>
          </jmeterTestPlan>
        EOF
        test = Gridinit::Jmeter::TestPlan.new
        @root.at_xpath("//jmeterTestPlan/hashTree") << test.doc.children
      end

      def threads(params={}, &block)
        threads = Gridinit::Jmeter::ThreadGroup.new(params)
        @root.at_xpath("//jmeterTestPlan/hashTree") << hash_tree
        @root.at_xpath("//jmeterTestPlan/hashTree/hashTree") << threads.doc.children
        self.instance_exec(&block) if block
      end

      def visit(params={}, &block)
        sampler = Gridinit::Jmeter::HttpSampler.new(params)
        @root.at_xpath("//jmeterTestPlan/hashTree/hashTree/ThreadGroup") << hash_tree
        @root.at_xpath("//ThreadGroup/hashTree") << sampler.doc.children
        self.instance_exec(&block) if block
      end

      def to_jmx
        puts @root
      end

      private

      def hash_tree
        Nokogiri::XML('<hashTree/>').children
      end

      def logger
        @log ||= Logger.new(STDOUT)
        @log.level = Logger::DEBUG
        @log
      end
    end

    class TestPlan
      attr_accessor :doc
      def initialize
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <TestPlan guiclass="TestPlanGui" testclass="TestPlan" testname="Test Plan" enabled="true">
            <stringProp name="TestPlan.comments"></stringProp>
            <boolProp name="TestPlan.functional_mode">false</boolProp>
            <boolProp name="TestPlan.serialize_threadgroups">false</boolProp>
            <elementProp name="TestPlan.user_defined_variables" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="User Defined Variables" enabled="true">
              <collectionProp name="Arguments.arguments"/>
            </elementProp>
            <stringProp name="TestPlan.user_define_classpath"></stringProp>
          </TestPlan>
        EOF
      end
    end

    class ThreadGroup
      attr_accessor :doc
      def initialize(params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="Thread Group" enabled="true">
            <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
            <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
              <boolProp name="LoopController.continue_forever">false</boolProp>
              <stringProp name="LoopController.loops">1</stringProp>
            </elementProp>
            <stringProp name="ThreadGroup.num_threads">1</stringProp>
            <stringProp name="ThreadGroup.ramp_time">1</stringProp>
            <longProp name="ThreadGroup.start_time">1352677419000</longProp>
            <longProp name="ThreadGroup.end_time">1352677419000</longProp>
            <boolProp name="ThreadGroup.scheduler">false</boolProp>
            <stringProp name="ThreadGroup.duration"></stringProp>
            <stringProp name="ThreadGroup.delay"></stringProp>
          </ThreadGroup>
        EOF
        params.each do |name, value|
          node = @doc.children.xpath("*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = value unless node.empty? 
        end
      end
    end

    class Transaction
      attr_accessor :doc
      def initialize(params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <TransactionController guiclass="TransactionControllerGui" testclass="TransactionController" testname="Transaction Controller" enabled="true">
            <boolProp name="TransactionController.parent">false</boolProp>
          </TransactionController>
        EOF
        params.each do |name, value|
          node = @doc.children.xpath("*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = value unless node.empty? 
        end
      end
    end

    class HttpSampler
      attr_accessor :doc
      def initialize(params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <HTTPSamplerProxy guiclass="HttpTestSampleGui" testclass="HTTPSamplerProxy" testname="HTTP Request" enabled="true">
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
            <stringProp name="HTTPSampler.embedded_url_re"></stringProp>
          </HTTPSamplerProxy>
        EOF
        parse_url(params) if name == params[:url]
        params.each do |name, value|
          node = @doc.children.xpath("*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = value unless node.empty? 
        end
      end

      def parse_uri(url)
        URI.parse(url).scheme.nil? ? URI.parse("http://#{url}") : URI.parse(url)   
      end

      def parse_url(params)
        uri             = parse_uri(params[:url])
        params[:domain] = uri.host
        params[:port]   = uri.port
        params[:path]   = uri.path
        params.delete :url
      end
    end

  end
end

def test(&block)
  Docile.dsl_eval(Gridinit::Jmeter::DSL.new, &block)
end

test do
  threads(num_threads: 1000) do
    visit do
    end
  end
end.to_jmx