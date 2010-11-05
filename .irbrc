# ~/.irbrc: Allan C. Lloyds <acl@acl.im>

begin
  # Remember:
  #  - the _ special variable
  #  - the cheat gem/command - http://cheat.errtheblog.com/
  #  - the following extras...

  class Object
    # Return a list of methods defined locally for a particular object.  Useful
    # for seeing what it does whilst losing all the guff that's implemented
    # by its parents (eg Object).
    def local_methods(obj = self)
      (obj.methods - obj.class.superclass.instance_methods).sort
    end
  end

  IRB.conf[:BACK_TRACE_LIMIT] = 100
  IRB.conf[:AUTO_INDENT]=true

  # Tab completion
  require 'irb/completion'

  # %w(1 2 3 4 5).map_to_i => [1, 2, 3, 4, 5]
  require 'map_by_method'

  # 3.45.what? 3 => gives list of methods that will return 3 from 3.45
  require 'what_methods'

  # Pretty printing and YAML: <y|pp> <some object>
  require 'pp'
  require 'yaml'

  # http://pablotron.org/software/wirble/README
  require 'wirble'
  Wirble.init
  Wirble.colorize

rescue LoadError => err
  warn "Problem in ~/.irbrc: #{err}"
end
