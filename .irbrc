# ~/.irbrc: Allan C. Lloyds <acl@acl.im>
# vim: set et ff=unix ft=ruby fdm=marker ts=2 sw=2 sts=2 tw=0:

begin
  # Remember:
  #  - the _ special variable
  #  - the cheat gem/command for cheatsheets => http://cheat.errtheblog.com/
  #  - the following extras...
  #
  # map_by_method => %w(1 2 3 4 5).map_to_i => [1, 2, 3, 4, 5]
  #                    http://drnicwilliams.com/category/ruby/map_by_method/
  # what_methods  => 3.45.what? 3 => list methods that will return 3 from 3.45
  #                    http://drnicutilities.rubyforge.org/
  # pp/yaml       => Pretty printing and YAML: <pp|y> <object>
  #                    <Ruby Stdlib>
  # awesome_print => Really pretty printing: <ap> <object>
  #                    https://github.com/michaeldv/awesome_print
  # looksee       => Examine method lookup path: <lp> <object>
  #                    https://github.com/oggy/looksee
  # wirble        => Colorize IRB output and more
  #                    http://pablotron.org/software/wirble/README
  # hirb          => Print tables and way more: <table> 1..3
  #                    https://github.com/cldwalker/hirb

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

  # IRB Options => http://ruby-doc.org/docs/ProgrammingRuby/html/irb.html

  require 'irb/completion'       # Tab completion
  require 'irb/ext/save-history' # History
  require 'irb/xmp'              # Example printer

  IRB.conf[:SAVE_HISTORY]        = 1000
  IRB.conf[:HISTORY_FILE]        = "#{ENV['HOME']}/.irb_history"
  IRB.conf[:BACK_TRACE_LIMIT]    = 100
  IRB.conf[:AUTO_INDENT]         = true

  %w(rubygems map_by_method what_methods awesome_print looksee/shortcuts wirble
     pp yaml hirb).each do |gem|
    begin
      require gem
    rescue LoadError => error
      warn "Problem in ~/.irbrc loading #{gem}: #{error}"
    end
  end

  Wirble.init          if Wirble # Wirble must be enabled before Hirb
  Wirble.colorize      if Wirble # Since they both override IRB's default output
  Hirb.enable          if Hirb
  extend Hirb::Console if Hirb
rescue Exception => error
  warn "Problem in ~/.irbrc: #{error}"
end
