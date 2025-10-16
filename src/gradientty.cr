module Gradientty
  # Represents a gradient color instance for rendering strings with color transitions.
  #
  # Create an instance using `Gradientty.gradient(["#hex1", "#hex2", ...])`.
  # Use `#call` for single-line strings or `#multiline` for multi-line strings.
  struct ColorInstance
    # The array of RGB color stops used for the gradient.
    # Each color is an Array of three Int32 values: [R, G, B].
    property colors : Array(Array(Int32))

    # Initializes a ColorInstance with an array of RGB color stops.
    #
    # *colors* - An array of RGB color stops.
    def initialize(colors : Array(Array(Int32)))
      @colors = colors
    end

    # Applies the gradient to a single-line string.
    #
    # Spaces and newlines are preserved.
    # The string is returned with ANSI color codes applied.
    #
    # *str* - The string to apply the gradient to.
    #
    # Example:
    # ```
    # custom = Gradientty.gradient(["#ff0000", "#00ff00"])
    # puts custom.call("Hello")
    # ```
    def call(str : String)
      return "" if str.empty?
      len = str.size

      String.build do |io|
        str.chars.each_with_index do |c, i|
          if c == ' ' || c == '\n'
            io << c
            next
          end

          r = interpolate(@colors, i, len, 0)
          g = interpolate(@colors, i, len, 1)
          b = interpolate(@colors, i, len, 2)

          io << "\e[38;2;#{r};#{g};#{b}m#{c}"
        end
        io << "\e[0m"
      end
    end

    # Applies the gradient to a multi-line string.
    #
    # Each line receives the full gradient individually by default.
    # If *continuous* is true, the gradient flows continuously across all lines.
    #
    # *str* - The multi-line string to color.
    # *continuous* - Whether to apply gradient continuously across all lines (default: false).
    #
    # Example:
    # ```
    # custom = Gradientty.gradient(["#ff0000", "#00ff00", "#0000ff"])
    # puts custom.multiline("Hello\nWorld", true)
    # ```
    def multiline(str : String, continuous = false)
      if continuous
        call(str.chomp) + "\e[0m"
      else
        str.lines.map { |line| call(line) }.join("\n")
      end
    end

    # Linearly interpolates between color stops for a given channel (R, G, or B).
    #
    # Used internally for gradient calculation.
    private def interpolate(colors : Array(Array(Int32)), i : Int32, len : Int32, channel : Int32) : Int32
      return colors.first[channel] if len <= 1

      pos = i.to_f / (len - 1) * (colors.size - 1)
      idx = pos.floor.to_i
      next_idx = Math.min(idx + 1, colors.size - 1)
      t = pos - idx

      start_c = colors[idx][channel]
      end_c = colors[next_idx][channel]

      (start_c + (end_c - start_c) * t).round.to_i
    end
  end

  # Converts a hex color string (e.g., "#ff00aa") to an array of RGB Int32 values.
  #
  # *hex* - The hex color string.
  #
  # Example:
  # ```
  # Gradientty.hex_to_rgb("#ff00aa") # => [255, 0, 170]
  # ```
  private def self.hex_to_rgb(hex : String) : Array(Int32)
    hex = hex.lstrip('#')
    [0, 2, 4].map { |i| hex[i, 2].to_i(16) }
  end

  # Factory method: creates a ColorInstance from an array of hex color strings.
  #
  # *colors* - Array of hex color strings for the gradient.
  #
  # Example:
  # ```
  # custom = Gradientty.gradient(["#ff0000", "#00ff00"])
  # puts custom.call("Hello")
  # ```
  def self.gradient(colors : Array(String))
    rgb_colors = colors.map { |h| hex_to_rgb(h) }
    ColorInstance.new(rgb_colors)
  end

  # Private helper to apply gradient directly to a string.
  private def self.apply_gradient(colors : Array(String), str : String)
    instance = gradient(colors)
    str.includes?("\n") ? instance.multiline(str) : instance.call(str)
  end

  # Predefined crystal-style gradient.
  #
  # *str* - The string to color.
  #
  # Example:
  # ```
  # puts Gradientty.crystal("Hello Crystal!")
  # ```
  def self.crystal(str : String)
    apply_gradient(["#000000", "#777777", "#FFFFFF"], str)
  end

  # Predefined rainbow gradient.
  #
  # *str* - The string to color.
  #
  # Example:
  # ```
  # puts Gradientty.rainbow("Hello Rainbow!")
  # ```
  def self.rainbow(str : String)
    apply_gradient([
      "#FF0000",
      "#FF7F00",
      "#FFFF00",
      "#7FFF00",
      "#00FF00",
      "#00FF7F",
      "#00FFFF",
      "#0000FF",
      "#8B00FF",
    ], str)
  end

  # Predefined pastel gradient.
  #
  # *str* - The string to color.
  #
  # Example:
  # ```
  # puts Gradientty.pastel("Hello Pastel!")
  # ```
  def self.pastel(str : String)
    apply_gradient(["#74ebd5", "#74ecd5"], str)
  end

  # Predefined vice-style gradient.
  #
  # *str* - The string to color.
  #
  # Example:
  # ```
  # puts Gradientty.vice("Hello Vice!")
  # ```
  def self.vice(str : String)
    apply_gradient(["#5ee7df", "#b490ca"], str)
  end
end
