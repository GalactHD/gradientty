require "gradientty"

ascii = "
 _____         _
|_   _|       | |
  | | _____  _| |_
  | |/ _ \\ \\/ / __|
  | |  __/>  <| |_
  \\_/\\___/_/\\_\\__|
"

# Custom gradient: red -> blue, applied continuously across all lines
puts "Custom Gradient (continuous):"
puts Gradientty.gradient(["#ff0000", "#0000ff"]).multiline(ascii, true)
puts "\n"

# Custom gradient: red -> blue, applied per line
puts "Custom Gradient (per line):"
puts Gradientty.gradient(["#ff0000", "#0000ff"]).multiline(ascii)
puts "\n"

# Predefined Rainbow gradient
puts "Rainbow Gradient:"
puts Gradientty.rainbow(ascii)
puts "\n"

# Predefined Vice gradient
puts "Vice Gradient:"
puts Gradientty.vice(ascii)
