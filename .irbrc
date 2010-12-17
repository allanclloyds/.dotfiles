# ~/.irbrc: Allan C. Lloyds <acl@acl.im>
# vim: set et ff=unix ft=ruby fdm=marker ts=2 sw=2 sts=2 tw=0:

begin
  # Remember:
  #  - the _ special variable
  #  - the cheat gem/command for cheatsheets => http://cheat.errtheblog.com/
  #  - the following extras...
  #
  # map_by_method      => %w(1 2 3 4 5).map_to_i => [1, 2, 3, 4, 5]
  #                         http://drnicwilliams.com/category/ruby/map_by_method/
  # what_methods       => 3.45.what? 3 => methods that will return 3 from 3.45
  #                         http://drnicutilities.rubyforge.org/
  # pp/yaml            => Pretty printing and YAML: <pp|y> <object>
  #                         <Ruby Stdlib>
  # awesome_print      => Really pretty printing: <ap> <object>
  #                         https://github.com/michaeldv/awesome_print
  # looksee            => Examine method lookup path: <lp> <object>
  #                         https://github.com/oggy/looksee
  # wirble             => Colorize IRB output and more
  #                         http://pablotron.org/software/wirble/README
  # boson              => Command/task framework for commandline and IRB
  #                         http://tagaholic.me/boson/
  # hirb               => Print tables and way more: <table> 1..3
  #                         http://tagaholic.me/hirb/
  # bond               => Better IRB autocompletion
  #                         http://tagaholic.me/bond/
  # interactive_editor => Run Vim from inside IRB
  #                         https://github.com/jberkel/interactive_editor

  class Object
    # Return a list of methods defined locally for a particular object. Useful
    # for seeing what it does whilst losing all the guff that's implemented
    # by its parent classes (eg Object).
    def local_methods(obj = self)
      (obj.methods - obj.class.superclass.instance_methods).sort
    end

    # Print documentation => https://github.com/ryanb/dotfiles/blob/master/irbrc
    # eg. ri 'Array#pop' / Array.ri / Array.ri :pop / arr.ri :pop
    def ri(method = nil)
      unless method && method =~ /^[A-Z]/ # if class isn't specified
        klass = self.kind_of?(Class) ? name : self.class.name
        method = [klass, method].compact.join('#')
      end
      system 'ri', method.to_s
    end
  end

  # Another IRB log
  # http://blog.nicksieger.com/articles/2006/04/23/tweaking-irb
  module Readline
    module History
      LOG = "#{ENV['HOME']}/.irb-readline-history"

      def self.write_log(line)
        File.open(LOG, 'ab') {|f| f << "#{line}\n"}
      end

      def self.start_session_log
        write_log("\n# session start: #{Time.now}\n\n")
        at_exit { write_log("\n# session stop: #{Time.now}\n") }
      end
    end

    alias :old_readline :readline
    def readline(*args)
      ln = old_readline(*args)
      begin
        History.write_log(ln)
      rescue
      end
      ln
    end
  end

  Readline::History.start_session_log

  # IRB Options => http://ruby-doc.org/docs/ProgrammingRuby/html/irb.html

  require 'irb/completion'       # Tab completion
  require 'irb/ext/save-history' # History
  require 'irb/xmp'              # Example printer

  IRB.conf[:SAVE_HISTORY]        = 1000
  IRB.conf[:HISTORY_FILE]        = "#{ENV['HOME']}/.irb-save-history"
  IRB.conf[:BACK_TRACE_LIMIT]    = 100
  IRB.conf[:AUTO_INDENT]         = false
  IRB.conf[:USE_READLINE]        = true

  # Reset terminal title to 'irb' or 'irb/railsapp/env' (needed especially when
  # using Vim from inside IRB with the interactive_editor gem, otherwise we're
  # left with the filename in the title, or worse, 'Thank you for flying Vim').

  term_title = defined?(RAILS_ROOT) ? "irb/#{RAILS_ROOT.split('/').last}/#{RAILS_ENV[0,1]}" : 'irb'

  case ENV['TERM']
  when /screen/
    term_title = "\ek#{term_title}\e\\"
  when /(xterm|rxvt)/
    term_title = "\e]0;#{term_title}\a"
  else
    term_title = ''
  end

  # Less verbosity, more color in our prompt. These escape sequences might mess
  # things up for some versions of IRB/readline, but it doesn't affect me any,
  # especially with auto indentation disabled (which is far too broken for my
  # taste anyway). See ~/.zshrc for ANSI color code table.

  IRB.conf[:PROMPT][:CUSTOM] = {
    :PROMPT_N => "\e[0;1;31m+ \e[0m",
    :PROMPT_I => "\n#{term_title}\e[0;1;31m> \e[0m",
    :PROMPT_S => "  ",
    :PROMPT_C => "\e[0;1;31m~ \e[0m",
    :RETURN   => "\e[0;0;37m= \e[0m%s \n"
  }
  IRB.conf[:PROMPT_MODE] = :CUSTOM

  %w(rubygems map_by_method what_methods awesome_print looksee/shortcuts wirble
     pp yaml boson hirb bond interactive_editor).each do |gem|
    begin
      require gem
    rescue LoadError => error
      warn "Problem in ~/.irbrc loading #{gem}: #{error}"
    end
  end

  # Wirble must be enabled before Hirb as they both override IRB's output
  if defined? Wirble
    Wirble.init({
      :skip_history => true      # 3 logs is quite enough
    })
    Wirble.colorize
  end

  # Boson must be enabled before Hirb otherwise you get commands conflicts
  Boson.start          if defined? Boson
  Hirb.enable          if defined? Hirb
  extend Hirb::Console if defined? Hirb
  Bond.start           if defined? Bond
rescue Exception => error
  warn "Problem in ~/.irbrc: #{error}"
end
