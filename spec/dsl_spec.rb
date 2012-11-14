require "spec_helper"

describe "DSL" do

  it "should return the DSL object" do
    test(comments: 'Example test plan') do
      threads(quantity: 1000) do
        transaction do
          visit(url: 'http://127.0.0.1') {}
        end
      end

    end
  end

end
