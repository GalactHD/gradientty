module Gradientty
  # Represents a gradient color instance for rendering strings with color transitions.
  struct ColorInstance
    # The array of RGB color stops used for the gradient.
    property colors : Array(Array(Int32))

    # Initializes a ColorInstance with an array of RGB color stops.
    def initialize(colors : Array(Array(Int32)))
      @colors = colors
    end

    # Applies the gradient to a string, returning the string with ANSI color codes.
    # Does not add a line break at the end.
    #
    # Skips coloring for spaces and newlines.
    #
    # Example:
    # ```
    # puts Gradientty.gradient(["#ff0000", "#0000ff"]).call("Hello")
    # ```
    def call(str : String)
      return "" if str.empty?
      len = str.size
      result = ""

      str.chars.each_with_index do |c, i|
        if c == " " || c == "\n"
          result += c
          next
        end

        r = interpolate(@colors, i, len, 0)
        g = interpolate(@colors, i, len, 1)
        b = interpolate(@colors, i, len, 2)

        result += "\e[38;2;#{r};#{g};#{b}m#{c}"
      end

      result + "\e[0m"
    end

    # Applies a gradient to a multiline string.
    #
    # Each line receives the full gradient individually by default.
    # If `continuous` is true, the gradient is applied as if the entire
    # string were a single long line, so the color flows across lines.
    #
    # Parameters:
    # - *str* = The multiline string to color.
    # - *continuous* = false - Whether to apply the gradient continuously across all lines.
    #
    # Returns:
    # - String - The colored string with ANSI codes, ready for terminal output.
    def multiline(str : String, continuous = false)
      if continuous
        call(str.chomp) + "\e[0m"
      else
        str.lines.map { |line| call(line) }.join("\n")
      end
    end

    # Linearly interpolates between color stops for a given channel (R, G, or B).
    # Used internally for gradient calculation.
    private def interpolate(colors : Array(Array(Int32)), i : Int32, len : Int32, channel : Int32) : Int32
      start_c = colors.first[channel]
      end_c = colors.last[channel]
      ((start_c + ((end_c - start_c) * i.to_f / (len - 1))).round).to_i
    end
  end

  # Converts a hex color string (e.g., "#ff00aa") to an array of RGB `Int32` values.
  # Used internally.
  private def self.hex_to_rgb(hex : String) : Array(Int32)
    hex = hex.gsub("#", "")
    [
      hex[0..1].to_i(16),
      hex[2..3].to_i(16),
      hex[4..5].to_i(16),
    ]
  end

  # Factory method: creates a `ColorInstance` from an array of hex color strings.
  #
  # Example:
  # ```
  # = Gradientty.gradient(["#ff0000", "#00ff00"])
  # ```
  def self.gradient(colors : Array(String))
    rgb_colors = colors.map { |h| hex_to_rgb(h) }
    ColorInstance.new(rgb_colors)
  end

  private def self.apply_gradient(colors : Array(String), str : String)
    instance = gradient(colors)
    str.includes?("\n") ? instance.multiline(str) : instance.call(str)
  end

  def self.crystal(str : String)
    apply_gradient(["#000000", "#777777", "#FFFFFF"], str)
  end

  def self.rainbow(str : String)
    apply_gradient(["#ff0000", "#ff7f00", "#ffff00", "#00ff00", "#0000ff", "#4b0082", "#9400d3"], str)
  end

  def self.pastel(str : String)
    apply_gradient(["#74ebd5", "#74ecd5"], str)
  end

  def self.vice(str : String)
    apply_gradient(["#5ee7df", "#b490ca"], str)
  end
end
