require "spec_helper"

describe "DSL" do

  it "test plan should respond to thread groups" do
    test {}.should respond_to :threads
  end

  it "test plan should respond to transactions" do
    test {}.should respond_to :transaction
  end

  it "test plan should respond to visit" do
    test {}.should respond_to :visit
  end

  it "test plan should respond to submit" do
    test {}.should respond_to :submit
  end

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

  describe 'Disabled reports' do
    let(:doc) do
      test do
        aggregate_report('Aggregate Report disabled', {enabled: false})
        aggregate_report('Aggregate Report enabled', {enabled: true})
        aggregate_report('Aggregate Report default', {enabled: true})
      end.to_doc
    end

    let(:aggregate_report_disabled) { doc.search("//ResultCollector[@testname='Aggregate Report disabled']").first }
    let(:aggregate_report_enabled) { doc.search("//ResultCollector[@testname='Aggregate Report enabled']").first }
    let(:aggregate_report_default) { doc.search("//ResultCollector[@testname='Aggregate Report default']").first }

    it 'should disable Aggregate Report disabled' do
      aggregate_report_disabled.attributes['enabled'].value.should == 'false'
    end

    it 'should disable Aggregate Report enabled' do
      aggregate_report_enabled.attributes['enabled'].value.should == 'true'
    end
    it 'should disable Aggregate Report default' do
      aggregate_report_enabled.attributes['enabled'].value.should == 'true'
    end
  end

  describe do

    let(:doc) do
      test do
        view_results_full_visualizer('View Results Tree error_only', {error_only: true})
        view_results_full_visualizer('View Results Tree not error_only', {error_only: false})
        view_results_full_visualizer('View Results Tree default')
      end.to_doc
    end

    let(:report_errors_only) { doc.search("//ResultCollector[@testname='View Results Tree error_only']").first }
    let(:report_not_errors_only) { doc.search("//ResultCollector[@testname='View Results Tree not error_only']").first }
    let(:report_default) { doc.search("//ResultCollector[@testname='View Results Tree default']").first }

    it 'should be true when errors only' do
      error_logging = report_errors_only.children.first
      error_logging.attributes['name'].value.should == 'ResultCollector.error_logging'
      error_logging.text.should == 'true'
    end

    it 'should be false when not errors only' do
      error_logging = report_not_errors_only.children.first
      error_logging.attributes['name'].value.should == 'ResultCollector.error_logging'
      error_logging.text.should == 'false'
    end
    it 'should default to false when not given' do
      error_logging = report_default.children.first
      error_logging.attributes['name'].value.should == 'ResultCollector.error_logging'
      error_logging.text.should == 'false'
    end
  end

  describe 'extract use_headers_type' do

    let(:doc) do
      test do
        extract :regex, 'match on url', 'blah', {match_on: 'URL'}
        extract :regex, 'match on default', 'blah'
      end.to_doc
    end

    let(:extract_url) { doc.search("//RegexExtractor[@testname='match on url']").first }
    let(:extract) { doc.search("//RegexExtractor[@testname='match on default']").first }

    it 'should match on URL' do
      extract_url.search(".//stringProp[@name='RegexExtractor.useHeaders']").text.should == 'URL'
    end

    it 'should default to false' do
      extract.search(".//stringProp[@name='RegexExtractor.useHeaders']").text.should == 'false'
    end

  end

  describe 'Nested controllers' do

    let(:doc) do
      test do
        simple 'blah1.1' do
          simple 'blah2.1'
          simple 'blah2.2' do
            simple 'blah3.1'
          end
          simple 'blah2.3'
        end
        simple 'blah1.2'
      end.to_doc
    end

    let(:blah1_1) { doc.search("//GenericController[@testname='blah1.1']").first }
    let(:blah1_2) { doc.search("//GenericController[@testname='blah1.2']").first }

    let(:blah2_1) { doc.search("//GenericController[@testname='blah2.1']").first }
    let(:blah2_2) { doc.search("//GenericController[@testname='blah2.2']").first }
    let(:blah2_3) { doc.search("//GenericController[@testname='blah2.3']").first }

    let(:blah3_1) { doc.search("//GenericController[@testname='blah3.1']").first }

    it 'nodes should have hashTree as its parent' do
      [blah1_1, blah1_2, blah2_1, blah2_2, blah2_3, blah3_1].each do |node|
        node.parent.name.should == 'hashTree'
      end
    end

    describe 'blah3_1' do
      it 'parent parent should be blah2_2' do
        blah3_1.parent.should == blah2_2.next
      end
    end

    describe 'blah1_2' do
      it 'previous non hashTree sibling is blah1_1' do
        blah1_2.previous.previous.should == blah1_1
      end
    end

  end

end
