#!/usr/bin/env zsh

set -eu

export MYDOTFILES=$HOME/dotfiles

reinstall=
unlink=
update=
relinkprezto=
relinkfzf=

# directories
FZFDIR="$HOME/.fzf"
ZPREZTODIR="${ZDOTDIR:-$HOME}/.zprezto"

# symlinks
ZSHRC="$HOME/.zshrc"
VIMRC="$HOME/.vimrc"
GVIMRC="$HOME/.gvimrc"
TMUXCONF="$HOME/.tmux.conf"
FLAKE8="$HOME/.config/flake8"

SYMLINKS=(
${VIMRC}
${GVIMRC}
${TMUXCONF}
${FLAKE8}
)

SYMTARGET=(
"${MYDOTFILES}/vim/vimrc.vim"
"${MYDOTFILES}/vim/gvimrc.vim"
"${MYDOTFILES}/tmux/tmux.conf"
"${MYDOTFILES}/flake8"
)

SYMRANGE=(1 2 3 4)

# actual files
TMUXLOCAL="$MYDOTFILES/tmux-local"
TRASH="$HOME/.trash"

help() {
	cat << EOF
	usage: $0 [OPTIONS]
	--help				Show this message
	--reinstall			Refetch zsh-plugins from repository and reinstall.
	--relink			Delete symbolic link and link again.
	--update			Update plugins
EOF
}


for opt in "$@"; do
	case $opt in
		--help)
			help
			exit 0
			;;
		--reinstall)
			reinstall=1
			unlink=1
			;;
		--relink) unlink=1 ;;
		--update) update=1 ;;
		*)
			echo "unknown option: $opt"
			help
			exit 1
			;;
	esac
done


cat << EOF
    ____  ____  __________________    ___________
   / __ \/ __ \/_  __/ ____/  _/ /   / ____/ ___/
  / / / / / / / / / / /_   / // /   / __/  \__ \ 
 / /_/ / /_/ / / / / __/ _/ // /___/ /___ ___/ / 
/_____/\____/ /_/ /_/   /___/_____/_____//____/  

Author: ishitaku5522

EOF

if [[ ! -z "$update" ]]; then
	pushd ${ZPREZTODIR}
	git pull && git submodule update --init --recursive
	popd
	pushd ${FZFDIR}
	git pull
	popd

	unlink=1
fi

if [[ ! -z "$unlink" ]]; then
	echo "\n==========Remove existing RC files==========\n"
	if [[ -e "$ZSHRC" ]]; then
		if [[ -e "~/.zshrc.bak" ]]; then
			echo "Remove exist backup of zshrc"
			rm ~/.zshrc.bak
		fi
		cp $ZSHRC ~/.zshrc.bak
		echo "Make backup of zshrc"
	fi

	setopt EXTENDED_GLOB
	for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
		if [[ -e "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]]; then
			echo "Remove .${rcfile:t}"
			\unlink "${ZDOTDIR:-$HOME}/.${rcfile:t}"
		fi
	done
	relinkprezto=1
	relinkfzf=1

	for item in ${SYMLINKS[@]}; do
		echo "Remove ${item}"
		\unlink ${item}
	done
	unset item
fi

if [[ ! -z "$reinstall" ]]; then
	echo "Remove fzf and zprezto directory"
	\rm -rf $FZFDIR $ZPREZTODIR 
fi

git config --global core.editor vim
git config --global alias.graph "log --graph --all --pretty=format:'%C(auto)%h%d%n  %s %C(magenta)(%cr)%n    %C(green)Committer:%cN <%cE>%n    %C(blue)Author   :%aN <%aE>%Creset' --abbrev-commit --date=relative"

# install fzf
if [[ ! -e ${FZFDIR} ]]; then
	echo "\n==========Download fzf==========\n"
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	relinkfzf=1
fi

# download zprezto
if [[ ! -e ${ZPREZTODIR} ]]; then
	echo "\n==========Download zprezto==========\n"
	git clone --recursive https://github.com/zsh-users/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
	#	git -C ${ZDOTDIR:-$HOME}/.zprezto submodule foreach git pull origin master
	relinkprezto=1
fi

# relink prezto files
if [[ ! -z "$relinkprezto" ]]; then
	echo "\n==========Install prezto==========\n"
	setopt EXTENDED_GLOB
	for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
		if [[ ! -e "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]]; then
			echo "Link .${rcfile:t}"
			ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
		fi
	done

	rm ${ZDOTDIR:-$HOME}/.zpreztorc
	ln -s ${MYDOTFILES}/zsh/zpreztorc ${ZDOTDIR:-$HOME}/.zpreztorc

	if [[ -e "$HOME/.zshrc.bak" ]]; then
		echo "Restore backup of zshrc"
		cat ~/.zshrc.bak > ~/.zshrc
		rm ~/.zshrc.bak
	else
		touch ~/.zshrc
		echo "Add a line for source dotfiles to zshrc"
		echo "source $MYDOTFILES/zsh/zshrc" >> ~/.zshrc
	fi
fi

if [[ ! -z "$relinkfzf" ]]; then
	echo "\n==========Install fzf==========\n"
	~/.fzf/install --completion --key-bindings --update-rc
fi

# make symlinks
echo "\n==========Install RC files==========\n"
for i in ${SYMRANGE}; do
	if [[ ! -e ${SYMLINKS[${i}]} ]]; then
		touch ${SYMTARGET[${i}]}
		ln -s ${SYMTARGET[${i}]} ${SYMLINKS[${i}]}
		echo "Link" ${SYMLINKS[${i}]:t}
	fi
done

# Not symlink
if [[ ! -e ${TMUXLOCAL} ]]; then
	touch $MYDOTFILES/tmux-local
	echo "tmuxlocal is made"
fi

if [[ ! -e ${TRASH} ]]; then
	mkdir ${TRASH}
fi
