require "spec_helper"
require "pry-debugger"

describe "DSL" do

  describe 'aliased DSL methods' do
    it "test plan should respond to aliased methods" do
      test {}.should respond_to :variables
      test {}.should respond_to :defaults
      test {}.should respond_to :cookies
      test {}.should respond_to :cache
      test {}.should respond_to :header
      test {}.should respond_to :auth
    end
  end


  describe 'write to stdout and file' do
    it "should output a test plan to stdout" do
      $stdout.should_receive(:puts).with(/jmeterTestPlan/i)
      test do
      end.out
    end

    it "should output a test plan to jmx file" do
      file = mock('file')
      File.should_receive(:open).with("jmeter.jmx", "w").and_yield(file)
      file.should_receive(:write).with(/jmeterTestPlan/i)
      test do
      end.jmx
    end
  end


  describe 'user agent' do
    let(:doc) do
      test do
        with_user_agent :chrome
        threads
      end.to_doc
    end

    let(:fragment) { doc.search("//HeaderManager").first }

    it 'should match on user_agent' do
      fragment.search(".//stringProp[@name='Header.name']").text.should == 'User-Agent'
      fragment.search(".//stringProp[@name='Header.value']").text.should == 
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.46 Safari/536.5'
    end
  end


  describe 'thread groups' do
    let(:doc) do
      test do
        threads count: 101, continue_forever: true, duration: 69
      end.to_doc
    end

    let(:fragment) { doc.search("//ThreadGroup").first }

    it 'should match on num_threads' do
      fragment.search(".//stringProp[@name='ThreadGroup.num_threads']").text.should == '101'
    end

    it 'should match on continue_forever' do
      fragment.search(".//boolProp[@name='LoopController.continue_forever']").text.should == 'true'
    end

    it 'should match on loops' do
      fragment.search(".//stringProp[@name='LoopController.loops']").text.should == '-1'
    end

    it 'should match on duration' do
      fragment.search(".//stringProp[@name='ThreadGroup.duration']").text.should == '69'
    end
  end


  describe 'transaction controller' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_01", parent: true, include_timers: true
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//TransactionController").first }

    it 'should match on parent' do
      fragment.search(".//boolProp[@name='TransactionController.parent']").text.should == 'true'
    end

    it 'should match on includeTimers' do
      fragment.search(".//boolProp[@name='TransactionController.includeTimers']").text.should == 'true'
    end
  end


  describe 'visit' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_01", parent: true, include_timers: true do
            visit url: "/home?location=melbourne", always_encode: true
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//HTTPSamplerProxy").first }

    it 'should match on path' do
      fragment.search(".//stringProp[@name='HTTPSampler.path']").text.should == '/home'
    end

    it 'should match on always_encode' do
      fragment.search(".//boolProp[@name='HTTPArgument.always_encode']").text.should == 'true'
    end
  end


  describe 'https' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_01", parent: true, include_timers: true do
            visit url: "https://example.com"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//HTTPSamplerProxy").first }

    it 'should match on protocol' do
      fragment.search(".//stringProp[@name='HTTPSampler.protocol']").text.should == 'https'
    end
  end


  describe 'xhr' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_02", parent: true, include_timers: true do
            visit url: "/" do
              with_xhr
            end
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//HeaderManager").first }

    it 'should match on XHR' do
      fragment.search(".//stringProp[@name='Header.value']").text.should == 'XMLHttpRequest'
    end
  end


  describe 'submit' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_03", parent: true, include_timers: true do
            submit url: "/", fill_in: { username: 'tim', password: 'password' }
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//HTTPSamplerProxy").first }

    it 'should match on POST' do
      fragment.search(".//stringProp[@name='HTTPSampler.method']").text.should == 'POST'
    end
  end


  describe 'If' do
    let(:doc) do
      test do
        threads do
          If condition: '2>1' do
            visit url: "/"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//IfController").first }

    it 'should match on If' do
      fragment.search(".//stringProp[@name='IfController.condition']").text.should == '2>1'
    end
  end


  describe 'exists' do
    let(:doc) do
      test do
        threads do
          exists 'apple' do
            visit url: "/"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//IfController").first }

    it 'should match on exists' do
      fragment.search(".//stringProp[@name='IfController.condition']").text.should == "'${apple}'.length > 0"
    end
  end


  describe 'While' do
    let(:doc) do
      test do
        threads do
          While condition: 'true' do
            visit url: "/"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//WhileController").first }

    it 'should match on While' do
      fragment.search(".//stringProp[@name='WhileController.condition']").text.should == 'true'
    end
  end


  describe 'Loop' do
    let(:doc) do
      test do
        threads do
          Loop count: 5 do
            visit url: "/"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//LoopController").first }

    it 'should match on Loops' do
      fragment.search(".//stringProp[@name='LoopController.loops']").text.should == '5'
    end
  end


  describe 'Counter' do
    let(:doc) do
      test do
        threads do
          visit url: "/" do
            counter start: 1, per_user: true
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//CounterConfig").first }

    it 'should match on 5 Loops' do
      fragment.search(".//boolProp[@name='CounterConfig.per_user']").text.should == 'true'
    end
  end


  describe 'Switch' do
    let(:doc) do
      test do
        threads do
          Switch value: 'cat' do
            visit url: "/"
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//SwitchController").first }

    it 'should match on Switch' do
      fragment.search(".//stringProp[@name='SwitchController.value']").text.should == 'cat'
    end
  end





  # describe 'Disabled reports' do
  #   let(:doc) do
  #     test do
  #       aggregate_report('Aggregate Report disabled', {enabled: false})
  #       aggregate_report('Aggregate Report enabled', {enabled: true})
  #       aggregate_report('Aggregate Report default', {enabled: true})
  #     end.to_doc
  #   end

  #   let(:aggregate_report_disabled) { doc.search("//ResultCollector[@testname='Aggregate Report disabled']").first }
  #   let(:aggregate_report_enabled) { doc.search("//ResultCollector[@testname='Aggregate Report enabled']").first }
  #   let(:aggregate_report_default) { doc.search("//ResultCollector[@testname='Aggregate Report default']").first }

  #   it 'should disable Aggregate Report disabled' do
  #     aggregate_report_disabled.attributes['enabled'].value.should == 'false'
  #   end

  #   it 'should disable Aggregate Report enabled' do
  #     aggregate_report_enabled.attributes['enabled'].value.should == 'true'
  #   end
  #   it 'should disable Aggregate Report default' do
  #     aggregate_report_enabled.attributes['enabled'].value.should == 'true'
  #   end
  # end

  # describe do

  #   let(:doc) do
  #     test do
  #       view_results_full_visualizer('View Results Tree error_only', {error_only: true})
  #       view_results_full_visualizer('View Results Tree not error_only', {error_only: false})
  #       view_results_full_visualizer('View Results Tree default')
  #     end.to_doc
  #   end

  #   let(:report_errors_only) { doc.search("//ResultCollector[@testname='View Results Tree error_only']").first }
  #   let(:report_not_errors_only) { doc.search("//ResultCollector[@testname='View Results Tree not error_only']").first }
  #   let(:report_default) { doc.search("//ResultCollector[@testname='View Results Tree default']").first }

  #   it 'should be true when errors only' do
  #     error_logging = report_errors_only.children.first
  #     error_logging.attributes['name'].value.should == 'ResultCollector.error_logging'
  #     error_logging.text.should == 'true'
  #   end

  #   it 'should be false when not errors only' do
  #     error_logging = report_not_errors_only.children.first
  #     error_logging.attributes['name'].value.should == 'ResultCollector.error_logging'
  #     error_logging.text.should == 'false'
  #   end
  #   it 'should default to false when not given' do
  #     error_logging = report_default.children.first
  #     error_logging.attributes['name'].value.should == 'ResultCollector.error_logging'
  #     error_logging.text.should == 'false'
  #   end
  # end

  # describe 'extract use_headers_type' do

  #   let(:doc) do
  #     test do
  #       extract :regex, 'match on url', 'blah', {match_on: 'URL'}
  #       extract :regex, 'match on default', 'blah'
  #     end.to_doc
  #   end

  #   let(:extract_url) { doc.search("//RegexExtractor[@testname='match on url']").first }
  #   let(:extract) { doc.search("//RegexExtractor[@testname='match on default']").first }

  #   it 'should match on URL' do
  #     extract_url.search(".//stringProp[@name='RegexExtractor.useHeaders']").text.should == 'URL'
  #   end

  #   it 'should default to false' do
  #     extract.search(".//stringProp[@name='RegexExtractor.useHeaders']").text.should == 'false'
  #   end

  # end

  # describe 'Nested controllers' do

  #   let(:doc) do
  #     test do
  #       simple 'blah1.1' do
  #         simple 'blah2.1'
  #         simple 'blah2.2' do
  #           simple 'blah3.1'
  #         end
  #         simple 'blah2.3'
  #       end
  #       simple 'blah1.2'
  #     end.to_doc
  #   end

  #   let(:blah1_1) { doc.search("//GenericController[@testname='blah1.1']").first }
  #   let(:blah1_2) { doc.search("//GenericController[@testname='blah1.2']").first }

  #   let(:blah2_1) { doc.search("//GenericController[@testname='blah2.1']").first }
  #   let(:blah2_2) { doc.search("//GenericController[@testname='blah2.2']").first }
  #   let(:blah2_3) { doc.search("//GenericController[@testname='blah2.3']").first }

  #   let(:blah3_1) { doc.search("//GenericController[@testname='blah3.1']").first }

  #   it 'nodes should have hashTree as its parent' do
  #     [blah1_1, blah1_2, blah2_1, blah2_2, blah2_3, blah3_1].each do |node|
  #       node.parent.name.should == 'hashTree'
  #     end
  #   end

  #   describe 'blah3_1' do
  #     it 'parent parent should be blah2_2' do
  #       blah3_1.parent.should == blah2_2.next
  #     end
  #   end

  #   describe 'blah1_2' do
  #     it 'previous non hashTree sibling is blah1_1' do
  #       blah1_2.previous.previous.should == blah1_1
  #     end
  #   end

  # end

end
