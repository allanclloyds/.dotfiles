# 5l's .dotfiles

These are some of my dotfiles, hopefully they will come in handy for someone.

## ksh/bash/zsh

I mainly use zsh but I have things set up relatively sanely for all three.
There's a chart in `~/.profile` showing the startup script loading order for
each of the three shells. Short story: login stuff in `~/.profile` for all
three, interactive stuff in `~/.kshrc`, `~/.bashrc`, `~/.zshrc`, non
interactive stuff in `~/.kshrc`, `~/.bash_env`, `~/.zshenv`, and logout
stuff in `~/.bash_logout` and `~/.zlogout`.

## Vim

Most Vim plugins are installed via git [submodules/pathogen](http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/).

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

`vim: set et ff=unix ft=markdown fdm=marker ts=2 sw=2 sts=2 tw=74:`
