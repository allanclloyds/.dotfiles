# 5l's .dotfiles

These are my dotfiles, finally crafted to my satisfaction. You see, over the
years they had become like a set of arcane spellbooks which I didn't dare to
touch. I'd forgotten what half of those settings did or why I added them. I
wouldn't code like that I mused, and yet here I was with cargo culted
configuration for my tools.

`cd ~/.vim` was like entering a den of thieves, with plugins and cryptic scripts
glaring at me from their hiding holes. This is our land they said, and you are
not welcome here. "But why is my Ruby indentation all screwed up?" I asked.
"None of your goddamn business" they replied.

Well I decided I'd had quite enough of that; with hard lessons learned from the
ominously prescient Battlestar Galactica and some time on my hands, I tidied
everything up, put it all in git and fixed the annoyances I had with
zsh/screen/vim/irb/etc to get them playing better together. Unlike 'user
friendly' GUI tools, these programs require love and affection. If you take a
little time out of your daily workflow to show them some, they will repay that
effort a thousandfold.

Otherwise, well, you are doomed to spend your working life cursing your tools,
and we all know what they say about workmen who do that. Or even worse, much
worse... \*leans closer\* *you might even switch to a mac for the sake of
convenience*. And thus, heartache turns to tragedy.

### Symlinks & Control Characters in Github

Github doesn't display symlinks very well; they look like ordinary files
containing only the path to the target. In particular note that `~/.vimrc` and
`~/.gvimrc` are symlinks to `~/.vim/.vimrc` and `~/.vim/.gvimrc` respectively.

I also noticed that when browsing via Github, you won't see control characters
like `^[` or `^G`. I've added a note in most places where this applies, but
keep it in mind when looking at prompts and messages etc.

## Management

I have a [Boson](http://tagaholic.me/boson/) script for generating some of the
dotfiles from templates (the ones with private information like `~/.gitconfig`),
and symlinking the dotfiles to my home directory. It is based on [Ryan
Bates](http://railscasts.com/)' dotfiles
[Rakefile](https://github.com/ryanb/dotfiles/blob/master/Rakefile). Assuming you
don't already have a ~/.boson directory, you can do this to install the
dotfiles:

    gem install boson
    cd ~
    git clone https://github.com/5l/.dotfiles.git
    ln -s .dotfiles/.boson .boson
    cd .dotfiles
    cp templates/config.example.yml templates/config.yml
    boson install_dotfiles

Edit the `config.yml` with your own details. `install_dotfiles` will
clobber existing files in `~/.dotfiles` with dotfiles generated from
templates in `~/.dotfiles/templates` but it will prompt before clobbering
anything in your home directory with symlinks (make sure you backup first
though, just in case!).

`~/.boson/commands/dotfiles.rb` also gives you the commands `symlink`,
`symlink_all`, `regenerate` and `regenerate_all`. Take a look at the
source for more info.

In all likelihood though, you wont want the whole lot; you can use git sparse
checkouts to take just the Vim stuff (detailed below) or just pick through and
take what you find useful. *I've tried to provide attributions on everything
that's not mine; if you see something not properly attributed, please let me
know.*

## GNU Screen

I do all my work from the terminal inside screen. The screen
caption/hardstatus is organised to look nice with the zsh prompt and Vim
statusline, and displays the current Ruby version (as managed by
[RVM](http://rvm.beginrescueend.com/), and the git branch. Take a look at
`~/.screenrc`, `~/.zshrc` and `~/.zsh/commands/parse_git_branch` to see
how it fits together.

### Copy/paste

The `~/.boson/commands/clipboard.rb` Boson script gives you `copy`, `paste`,
`copy_history` and `copy_editor` commands to access the pastebuffer from IRB.
From Vim, the [fakeclip](http://www.vim.org/scripts/script.php?script_id=2098)
plugin provides virtual clipboard registers, one of which also allows access to
the pastebuffer.

Thus:

    irb> class Foo
    irb>   def bar; true; end
    irb> end
    irb> copy_history

And then in Vim (perhaps after typing `vim` to jump straight into the
editor from IRB using the
[interactive_editor](https://github.com/jberkel/interactive_editor) gem),
 `"&p` will paste:

    class Foo
      def bar; true; end
    end

Additionally, while using the
[interactive_editor](https://github.com/jberkel/interactive_editor) gem,
`copy_editor` will copy whatever is in the editor you are using inside IRB into
the pastebuffer (and `eval paste` will then run it without you needing to open
and close the editor again, although this functionality would be better added
to the gem itself).

Note that these commands can also work with your system clipboard when not
inside screen. This should work as is with Mac OSX; an additional program may be
required in \*nix or Windows. Take a look at `~/.boson/commands/clipboard.rb`
for suggestions.

## Ruby/IRB

There are a bunch of other IRB enhancements in `~/.irbrc`; of particular note
are the amazing [Boson](http://tagaholic.me/boson/),
[Hirb](http://tagaholic.me/hirb/) and [Bond](http://tagaholic.me/bond/)
libraries by [Gabriel Horner](http://tagaholic.me) which add a command
framework, a view framework and better tab completion respectively; the
[interactive_editor](https://github.com/jberkel/interactive_editor) gem
mentioned in the section above which allows you to use Vim or another editor
from inside IRB, and the
[awesome_print](https://github.com/michaeldv/awesome_print) gem which gives you
really pretty printing of Ruby objects.

## ksh/bash/zsh

I mainly use zsh but I have things set up relatively sanely for all three.
There's a chart in `~/.profile` showing the startup script loading order for
each of the three shells. Short story: login stuff in `~/.profile` for all
three, interactive stuff in `~/.kshrc`, `~/.bashrc`, `~/.zshrc`, non
interactive stuff in `~/.kshrc`, `~/.bash_env`, `~/.zshenv`, and logout
stuff in `~/.bash_logout` and `~/.zlogout`. Shared aliases go in
`~/.aliases`.

## Vim

Most Vim plugins are installed via git
[submodules/pathogen](http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/).
If you're not already using [Tim Pope](http://tpo.pe/)'s
[Pathogen](http://www.vim.org/scripts/script.php?script_id=2332) to manage
your Vim plugins, you _need_ to take a look.

Plugins not under version control with git, ie. most anything found on
vim.org, I just copy directly to `~/.vim` for simplicity, provided that they
only consist of a plugin file and a helpfile.

Anything more complicated I'll install via Vimball or create its own
directory under `~/.vim/bundle`

[Vimballs](http://www.vim.org/scripts/script.php?script_id=1502)
 are _somewhat_ justifiably hated, but they do in fact have an
uninstall mechanism:

    :RmVimball <vimballname>

My `~/.vim/.VimballRecord` is under version control, so anything here
installed via a vimball can be removed with :RmVimball from Vim, otherwise
it should be no more complicated than removing the specific file in
~/.vim/plugin or the directory/submodule under `~/.vim/bundle`

There are some projects to assist with installing/uninstalling plugins
that you might want to check out:

- [vim-addon-manager](http://www.vim.org/scripts/script.php?script_id=2905)
- [update bundles](http://tammersaleh.com/posts/the-modern-vim-config-with-pathogen)

If you only want to checkout the `~/.vim` directory you can use git sparse
checkouts like so:

    git clone https://github.com/5l/.dotfiles.git
    cd .dotfiles
    git config core.sparsecheckout true
    echo .vim/ > .git/info/sparse-checkout
    git read-tree -m -u HEAD

Use the same technique to ensure that the snipmate.vim plugin submodule
doesn't include its own directory of snippets.

There are lots of interesting plugins in `~/.vim`, but the most useful I
find on a daily basis are (as it bears repeating)
[Pathogen](http://www.vim.org/scripts/script.php?script_id=2332)
to manage Vim plugins,
[Command-T](http://www.vim.org/scripts/script.php?script_id=3025)
for opening files,
[Syntastic](http://www.vim.org/scripts/script.php?script_id=2736)
for syntax checking,
[snipMate.vim](http://www.vim.org/scripts/script.php?script_id=2540)
which implements TextMate's code snippets in Vim,
[Gist.vim](http://www.vim.org/scripts/script.php?script_id=2423)
to copy code to Github's Gist
[surround.vim](http://www.vim.org/scripts/script.php?script_id=1697)
for fast quoting/parenthesizing, and
[fakeclip](http://www.vim.org/scripts/script.php?script_id=2098)
for virtual clipboard registers (see the copy/paste section above)

`vim: set et ff=unix ft=markdown fdm=marker ts=2 sw=2 sts=2 tw=74:`
