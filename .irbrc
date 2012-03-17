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

# {{{ Core Enhancements #######################################################

  class Object
    # Return a list of methods defined locally for a particular object. Useful
    # for seeing what it does whilst losing all the guff that's implemented
    # by its parent classes (eg Object).
    def local_methods(obj = self)
      (obj.methods - obj.class.superclass.instance_methods).sort
    end

    # Print documentation eg. ri 'Array#pop' / Array.ri / Array.ri :pop
    # From: https://github.com/ryanb/dotfiles/blob/master/irbrc
    def ri(method = nil)
      unless method && method =~ /^[A-Z]/ # if class isn't specified
        klass = self.kind_of?(Class) ? name : self.class.name
        method = [klass, method].compact.join('#')
      end
      system 'ri', method.to_s
    end
  end

  # Show matching text in a string for a given regexp
  # From: Pickaxe book
  def show_regexp(a, re); a =~ re ? "#{$`}<<#{$&}>>#{$'}" : "no match"; end

  # Convenience method on Regexp so you can do /an/.show_match("banana")
  # From: http://www.ruby-forum.com/topic/84414
  class Regexp; def show_match(a); show_regexp(a, self); end; end

  # Another IRB log
  # From: http://blog.nicksieger.com/articles/2006/04/23/tweaking-irb
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
      History.write_log(ln) rescue Exception
      ln
    end
  end

  Readline::History.start_session_log
# }}}

# {{{ IRB Configuration #######################################################

  # Check we're in IRB and not ripl

  if defined? IRB
    require 'irb/completion'       # Tab completion
    require 'irb/ext/save-history' # History
    require 'irb/xmp'              # Example printer

    # IRB Options => http://ruby-doc.org/docs/ProgrammingRuby/html/irb.html

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
      term_title = "\001\ek#{term_title}\e\\\002"
    when /(xterm|rxvt)/
      term_title = "\001\e]0;#{term_title}\a\002"
    else
      term_title = ''
    end

    # Less verbosity, more colour in our prompt. \001 + \002, prevent readline
    # from counting escape sequences. Later versions of Ruby/readline
    # theoretically wrap with these automatically. See ~/.zshrc for ANSI colour
    # code table.

    IRB.conf[:PROMPT][:CUSTOM_COLOR] = {
      :PROMPT_S => "  ",
      :PROMPT_I => "#{term_title}\n" + \
                   "\001\e[0;1;31m\002> \001\e[0m\002",
      :PROMPT_N => "\001\e[0;1;31m\002+ \001\e[0m\002",
      :PROMPT_C => "\001\e[0;1;31m\002~ \001\e[0m\002",
      :RETURN   => "\001\e[0;0;37m\002= \001\e[0m\002%s \n"
    }

    IRB.conf[:PROMPT][:CUSTOM] = {
      :PROMPT_S => "  ",
      :PROMPT_I => "#{term_title}\n" + \
                   "> ",
      :PROMPT_N => "+ ",
      :PROMPT_C => "~ ",
      :RETURN   => "= %s \n"
    }

    IRB.conf[:PROMPT_MODE] = :CUSTOM_COLOR
  end

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
  if defined? Boson
    Boson.start({
      :verbose     => false,
      :no_defaults => true
    })
  end

  Hirb.enable          if defined? Hirb
  extend Hirb::Console if defined? Hirb
  Bond.start           if defined? Bond
# }}}
rescue Exception => error
  warn "Problem in ~/.irbrc: #{error}"
end
