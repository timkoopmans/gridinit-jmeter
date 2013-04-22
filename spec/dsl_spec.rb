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

  it "test plan should respond to soap" do
    test {}.should respond_to :soap
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

end
