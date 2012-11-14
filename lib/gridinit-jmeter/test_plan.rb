module Gridinit
  module Jmeter

    class TestPlan < Hashie::Trash
      property :comments,                 :required => false, :default => ''
      property :functional_mode,          :required => false, :default => false
      property :serialize_threadgroups,   :required => false, :default => false
      property :user_define_classpath,    :required => false, :default => ''

      ##
      # BUILDER
      def build
        builder = ::Nokogiri::XML::Builder.new do |xml|
        xml.jmeterTestPlan {
          xml.hashTree {
            xml.TestPlan_(guiclass: "TestPlanGui", testclass: "TestPlan", testname: "Test Plan", enabled: "true") {
              properties(self, xml)
              xml.hashTree {
                @thread_groups.each do |thread_group|
                  xml.ThreadGroup_(guiclass: "ThreadGroupGui", testclass: "ThreadGroup", testname: "Thread Group", enabled: "true") {
                    properties(thread_group, xml)
                  }
                  thread_group.transactions
                end
              }
            }
          }
        }
        end
        puts builder.to_xml
      end

      def properties(obj, xml)
        obj.keys.each do |property|
          case obj.send(property)
          when String
            xml.stringProp(name: "#{obj.class.name.split('::').last}.#{property}") { xml.text obj.send(property) }
          when FalseClass
            xml.boolProp(name: "#{obj.class.name.split('::').last}.#{property}") { xml.text obj.send(property) }
          else
            xml.stringProp(name: "#{obj.class.name.split('::').last}.#{obj.send(property).class}") { xml.text obj.send(property) }
          end
        end
      end

      ##
      # DSL
      def threads(params={}, &block)
        @thread_groups ||= []
        @thread_groups << Docile.dsl_eval(Gridinit::Jmeter::ThreadGroup.new, params, &block)
      end

    end

  end
end

def test(params={}, &block)
  Docile.dsl_eval(Gridinit::Jmeter::TestPlan.new, params, &block).build
end