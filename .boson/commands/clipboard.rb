# Copyright (c) 2010 Allan C. Lloyds <acl@acl.im>
#
# Copy/paste to/from the system clipboard or the GNU Screen pastebuffer.

module Clipboard
  def self.included(mod)
    require 'rbconfig'
  end

  def copy(str); clipboard_copy(:string => str); end
  def paste;     clipboard_paste;                end

  # @option :string, :type => :string, :default => '', :desc => 'Text to copy'
  # @option :bufferfile,      :default => File.join(ENV['HOME'], '.screen-exchange'),
  #         :type => :string, :desc    => 'Bufferfile to use with GNU Screen'
  # Copies text to the clipboard
  def clipboard_copy(options = {})
    if ENV.include? 'STY'                               # Running under GNU Screen

      File.open(options[:bufferfile], 'w') { |file| file << options[:string].to_s }
      system "screen -S #{ENV['STY']} -X readbuf #{options[:bufferfile]}"
    else
      case Config::CONFIG['host_os']                    # XXX Not tested yet
      when /linux|bsd|sunos|solaris/i
        IO.popen('xsel', 'w')     { |f| f << str.to_s } # http://www.vergenet.net/~conrad/software/xsel/
      when /mswin|windows/i
        IO.popen('nclip -i', 'w') { |f| f << str.to_s } # http://www.stokebloke.com/software/index.php#nclip
      when /darwin|mac os/i
        IO.popen('pbcopy', 'w')   { |f| f << str.to_s } # Included with Mac OS
      end
    end
  end

  # @option :bufferfile,      :default => File.join(ENV['HOME'], '.screen-exchange'),
  #         :type => :string, :desc    => 'Bufferfile to use with GNU Screen'
  # Returns the text on the clipboard
  def clipboard_paste(options = {})
    if ENV.include? 'STY'                               # Running under GNU Screen

      system "screen -S #{ENV['STY']} -X writebuf #{options[:bufferfile]}"
      `cat #{options[:bufferfile]}`
    else
      case Config::CONFIG['host_os']                    # XXX Not tested yet
      when /linux|bsd|sunos|solaris/i
        `xsel`                                          # http://www.vergenet.net/~conrad/software/xsel/
      when /mswin|windows/i
        `nclip -o`                                      # http://www.stokebloke.com/software/index.php#nclip
      when /darwin|mac os/i
        `pbpaste`                                       # Included with Mac OS
      end
    end
  end

  # @option :bufferfile,      :default => File.join(ENV['HOME'], '.screen-exchange'),
  #         :type => :string, :desc    => 'Bufferfile to use with GNU Screen'
  # Taken from: https://github.com/ryanb/dotfiles/blob/master/irbrc
  def copy_history(options = {})
    history = Readline::HISTORY.entries
    index   = history.rindex("exit") || -1
    content = history[(index+1)..-2].join("\n")
    clipboard_copy(options.merge({:string => content}))
  end

  # @option :bufferfile,      :default => File.join(ENV['HOME'], '.screen-exchange'),
  #         :type => :string, :desc    => 'Bufferfile to use with GNU Screen'
  # @option :editor,          :default => ENV['EDITOR'],
  #         :type => :string, :desc    => 'Interactive editor in use'
  # For use with interactive_editor gem
  def copy_editor(options = {})
    if IRB.conf.has_key? :interactive_editors
      file = ([options[:editor]] + IRB.conf[:interactive_editors].keys).compact.map {|e|
        IRB.conf[:interactive_editors][e].instance_variable_get('@file')
      }.find {|f| !f.nil?}

      clipboard_copy(options.merge({:string => IO.read(file)})) unless file.nil?
    end
  end
end
