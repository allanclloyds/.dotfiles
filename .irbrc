# ~/.irbrc: Allan C. Lloyds <acl@acl.im>

begin
  # Remember the _ special variable

  class Object
    # Return a list of methods defined locally for a particular object.  Useful
    # for seeing what it does whilst losing all the guff that's implemented
    # by its parents (eg Object).
    def local_methods(obj = self)
      (obj.methods - obj.class.superclass.instance_methods).sort
    end
  end

  # Tab completion
  require 'irb/completion'
  # eg. %w(1 2 3 4 5).map_to_i => [1, 2, 3, 4, 5]
  require 'map_by_method'
  # eg. 3.45.what? 3 => gives list of methods that will return 3 from 3.45
  require 'what_methods'
  # Pretty printing, don't forget y as well.. eg y/pp <some object>
  require 'pp'

  IRB.conf[:BACK_TRACE_LIMIT] = 100
  IRB.conf[:AUTO_INDENT]=true

  require 'wirble'
  Wirble.init
  Wirble.colorize
rescue LoadError => err
  warn "Problem in ~/.irbrc: #{err}"
end
