require "spec"
require "../src/gradientty"

describe "Gradientty" do
  it "prints predefined gradients correctly" do
    custom = Gradientty.gradient(["#ff5f6d", "#ffc371"])

    output_0 = Gradientty.rainbow("A test for testing string with gradient.")
    output_1 = Gradientty.crystal("A test for testing string with gradient.")
    output_2 = Gradientty.pastel("A test for testing string with gradient.")
    output_3 = Gradientty.vice("A test for testing string with gradient.")
    output_4 = custom.call("CUSTOM")
    output_5 = custom.multiline("LINE1\nLINE2")

    output_0.should_not eq ""
    output_1.should_not eq ""
    output_2.should_not eq ""
    output_3.should_not eq ""
    output_4.should_not eq ""
    output_5.should_not eq ""

    puts output_0
    puts output_1
    puts output_2
    puts output_3
    puts output_4
    puts output_5
  end
end
