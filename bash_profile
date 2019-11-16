# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

export PS1=$'[(${ORACLE_SID:-"no sid"})\u@\h \W]$ '

export ORACLE_SID=orcl
ORAENV_ASK=NO
. /usr/local/bin/oraenv
