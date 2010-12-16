# Copyright (c) 2010 Allan C. Lloyds <acl@acl.im>
#
# Based on Ryan Bates' dotfiles Rakefile
# https://github.com/ryanb/dotfiles/blob/master/Rakefile

module Dotfiles
  def self.included(mod)
    require 'yaml'
    require 'erb'
  end

  # @option :dotfiles,  :default => File.join(ENV['HOME'], '.dotfiles'),
  #         :type => :string, :desc => 'Output location'
  # @option :templates, :default => File.join(ENV['HOME'], '.dotfiles/templates'),
  #         :type => :string, :desc => 'Location of templates'
  # Install dotfiles to home directory
  def install_dotfiles(options = {})
    regenerate_all(options)
    symlink_all(:dotfiles => options[:dotfiles])
  end

  # @option :replace_all, :type => :boolean, :default => false
  # @option :dotfiles,  :default => File.join(ENV['HOME'], '.dotfiles'),
  #         :type => :string, :desc => 'Location of dotfiles'
  # Symlink all dotfiles
  def symlink_all(options = {})
    Dir["#{options[:dotfiles]}/.*"].each do |file|
      file            = File.basename(file)
      symlink_options = {:file => file, :dotfiles => options[:dotfiles]}

      next if %w[. .. .git .gitignore .gitmodules].include? file

      if File.exist?(File.join(ENV['HOME'], file))
        if File.identical?(file, File.join(ENV['HOME'], file))
          puts_message 'Identical', file
        elsif options[:replace_all]
          symlink(symlink_options.merge({:force => true}))
        else
          puts_message 'Replace', file, '[ynaq]'
          case $stdin.gets.chomp
          when 'a'
            options[:replace_all] = true
            symlink(symlink_options.merge({:force => true}))
          when 'y'
            symlink(symlink_options.merge({:force => true}))
          when 'q'
            return
          else
            puts_message 'Skipping', file
          end
        end
      else
        symlink(symlink_options)
      end
    end
    return
  end

  # @option :file, :type => :string, :desc => 'File to symlink'
  # @option :force, :type => :boolean, :default => false, :desc => 'Overwrite existing file'
  # @option :dotfiles,  :default => File.join(ENV['HOME'], '.dotfiles'),
  #         :type => :string, :desc => 'Output location'
  # Symlink a single dotfile
  def symlink(options = {})
    options[:file] = ".#{File.basename(options[:file]).sub(/^\./, '')}"
    if options[:force]
      puts_message 'Replacing', options[:file]; f = 'f'
    else
      puts_message 'Linking',   options[:file]
    end
    cwd = Dir.pwd; Dir.chdir(ENV['HOME'])
    # Use a relative symlink if .dotfiles is under home directory
    options[:dotfiles].sub!(/^#{ENV['HOME']}\/*/, '')
    system %Q{ln -#{f}s "#{File.join(options[:dotfiles], options[:file])}" "#{File.join(ENV['HOME'], options[:file])}"}
    Dir.chdir(cwd)
  end

  # @option :templates, :default => File.join(ENV['HOME'], '.dotfiles/templates'),
  #         :type => :string, :desc => 'Location of templates'
  # @option :dotfiles,  :default => File.join(ENV['HOME'], '.dotfiles'),
  #         :type => :string, :desc => 'Output location'
  # Regenerate all dotfile templates
  def regenerate_all(options = {})
    Dir["#{options[:templates]}/*.erb"].each do |file|
      regenerate(options.merge({:file => file}))
    end
  end

  # @option :file, :type => :string, :desc => 'Template to regenerate'
  # @option :templates, :default => File.join(ENV['HOME'], '.dotfiles/templates'),
  #         :type => :string, :desc => 'Location of templates'
  # @option :dotfiles,  :default => File.join(ENV['HOME'], '.dotfiles'),
  #         :type => :string, :desc => 'Output location'
  # @option :config,    :default => File.join(ENV['HOME'], '.dotfiles/templates/config.yml'),
  #         :type => :string, :desc => 'Location of yaml configuration file',
  # Regenerate a single dotfile from a template.
  def regenerate(options = {})
    options[:file] = File.basename(options[:file], '.erb')
    options[:file].sub!(/^\./, '')
    return if options[:file].empty?

    config = YAML.load_file(options[:config])

    # Colons in the template name will be converted to slashes for the target.
    # Thus irssi:config will be installed to [dotfiles]/.irssi/config
    # (the destination directory must already exist).

    File.open(File.join(options[:dotfiles], ".#{options[:file].gsub(':', '/')}"), 'w') do |new_file|
      puts "Regenerating: .#{options[:file].gsub(':', '/')}"
      new_file.write ERB.new(File.read(File.join(options[:templates], "#{options[:file]}.erb"))).result(binding)
    end
  end

  private

  def puts_message(msg, file, prompt = false)
    f = "%12s: ~/%s"
    prompt ? (print "#{sprintf(f, msg, file)}? #{prompt} ") : (puts sprintf(f, msg, file))
  end
end
