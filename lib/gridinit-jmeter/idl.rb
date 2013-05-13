#!/usr/bin/env ruby
# This is an IDL script to translate a JMeter testplan into Ruby DSL objects
require 'nokogiri'
require 'pathname'

home = Pathname("..").expand_path(__FILE__)
dsl  = File.join(home, "/dsl")

file = File.open File.join(home, "idl.xml")
doc = Nokogiri::XML file.read.gsub! /\n\s+/, ''
nodes = doc.xpath '//jmeterTestPlan/hashTree'

class String
  def classify
    return self if self !~ / / && self =~ /[A-Z]+.*/
    split(' ').map{|e| e.capitalize}.join.gsub /[\(\)-\/\.]/, ''
  end

  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end

results = []
doc.traverse do |node| 
  results << node if node.class != 
    Nokogiri::XML::Document && 
    node.attributes['testclass'] &&
    node.name != 'elementProp'
end

results.each do |element|
  klass = element.attributes['testname'].to_s.classify
  Dir.mkdir(dsl, 0700) unless Dir.exist? dsl
  File.open("#{dsl}/#{klass.underscore}.rb", 'w') { |file| file.write(<<EOC)
module Gridinit
  module Jmeter

    class DSL
      def #{klass.underscore}(params={}, &block)
        node = Gridinit::Jmeter::#{klass}.new(params)
        attach_node(node, &block)
      end
    end

    class #{klass}
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
#{element.to_xml.gsub /testname=".+?"/, 'testname="#{name}"'})
        EOS
        update params
      end
    end

  end
end
EOC
}
end
