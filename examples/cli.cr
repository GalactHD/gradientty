require "option_parser"
require "gradientty"

title = Gradientty.gradient([
  "#eb1f82ff",
  "#e100ffff",
  "#3c00ffff",
])

OptionParser.parse do |parser|
  parser.banner = "Welcome to #{title.call("my CLI!")}"

  parser.on "-v", "--version", "Show version" do
    puts "version 1.0"
    exit
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
end
