module Motion
  class Lager
    COLORS = {
      default: { fg: 39, bg: 49 },
      black:   { fg: 30, bg: 40 },
      red:     { fg: 31, bg: 41 },
      green:   { fg: 32, bg: 42 },
      yellow:  { fg: 33, bg: 43 },
      blue:    { fg: 34, bg: 44 },
      magenta: { fg: 35, bg: 45 },
      cyan:    { fg: 36, bg: 46 },
      white:   { fg: 37, bg: 47 },
      bright_black:   { fg: 90, bg: 100 },
      bright_red:     { fg: 91, bg: 101 },
      bright_green:   { fg: 92, bg: 102 },
      bright_yellow:  { fg: 93, bg: 103 },
      bright_blue:    { fg: 94, bg: 104 },
      bright_magenta: { fg: 95, bg: 105 },
      bright_cyan:    { fg: 96, bg: 106 },
      bright_white:   { fg: 97, bg: 107 },
    }
    # Aliases
    COLORS[:gray] = COLORS[:bright_black]
    COLORS[:light_blue] = COLORS[:bright_cyan]

    def initialize(config = {})
      @config = {}
      @config[:level] = config.fetch(:level, :debug).to_sym
    end

    def debug(obj, color = :gray, bg_color = :default)
      log_with_level(:debug, obj, color, bg_color)
    end

    def info(obj, color = :default, bg_color = :default)
      log_with_level(:info, obj, color, bg_color)
    end
    alias_method :log, :info

    def warn(obj, color = :yellow, bg_color = :default)
      log_with_level(:warn, obj, color, bg_color)
    end

    def error(obj, color = :red, bg_color = :default)
      log_with_level(:error, obj, color, bg_color)
    end

    private

    def log_with_level(level, obj, color = :white, bg_color = :default)
      return unless enabled?(level)
      if obj.is_a? String
        str = obj
      else
        str = inspect_object(obj)
      end
      puts str.to_s.split("\n").map {|line| colorize(line, color, bg_color) }.join("\n")
    end

    def enabled?(level)
      case @config[:level]
      when :debug
        return true
      when :info
        return level != :debug
      when :warn
        return level != :debug && level != :info
      when :error
        return level == :error
      end
    end

    def colorize(str, fg_color, bg_color = :default)
      return str unless defined?(MotionRepl) # only colorize when displaying in REPL
      "\e[#{COLORS[fg_color][:fg]};#{COLORS[bg_color][:bg]}m#{str}\e[0m"
    end

    def inspect_object(obj)
      case obj
      when Hash    then inspect_hash(obj)
      when NSError then inspect_nserror(obj)
      when NSURL   then obj.to_s
      else
        obj.inspect
      end
    end

    def inspect_hash(hash)
      message = "{"
      hash.each do |k, v|
        value_lines = []
        inspect_object(v).lines.each_with_index do |line, i|
          line = "  #{line}" unless i == 0
          value_lines << line
        end
        message += "\n  #{inspect_object(k)} => #{value_lines.join},"
      end
      message += "\n}"
    end

    def inspect_nserror(err)
      return "NSError was actually #{err.inspect}" unless err

      message = "<#{err.class}" \
        "\n  Domain: #{err.domain}" \
        "\n  Code: #{err.code}" \
        "\n  Description: #{err.localizedDescription}"
      user_info_lines = []
      inspect_object(err.userInfo).lines.each_with_index do |line, i|
        line = "  #{line}" unless i == 0
        user_info_lines << line
      end
      message +=
        "\n  UserInfo: #{user_info_lines.join}" \
        "\n  RecoveryOptions: #{err.localizedRecoveryOptions.inspect}" \
        "\n  RecoverySuggestion: #{err.localizedRecoverySuggestion.inspect}" \
        "\n  FailureReason: #{err.localizedFailureReason.inspect}" \
        ">"
    end

  end
end
