require "spec"
require "../src/gradientty"

describe "Gradientty" do
  it "generates ANSI-colored strings for predefined gradients" do
    test_str = "Gradient Test"

    gradients = {
      "rainbow" => Gradientty.rainbow(test_str),
      "crystal" => Gradientty.crystal(test_str),
      "pastel"  => Gradientty.pastel(test_str),
      "vice"    => Gradientty.vice(test_str),
    }

    gradients.each do |name, output|
      output.should_not eq ""
      # Check that ANSI escape codes exist
      output.should match(/\e\[38;2;\d+;\d+;\d+m/)
    end
  end

  it "generates ANSI-colored strings for custom gradients" do
    custom = Gradientty.gradient(["#ff5f6d", "#ffc371"])
    output_1 = custom.call("CUSTOM")
    output_2 = custom.multiline("LINE1\nLINE2", true)

    output_1.should_not eq ""
    output_2.should_not eq ""

    # Check that ANSI escape codes exist
    output_1.should match(/\e\[38;2;\d+;\d+;\d+m/)
    output_2.should match(/\e\[38;2;\d+;\d+;\d+m/)
  end
end
