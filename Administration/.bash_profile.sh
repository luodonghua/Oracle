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

alias tailorcl='adrci exec="set home orcl/orcl;show alert -tail -f"'
alias tailorcl2='adrci exec="set home orcl2/orcl2;show alert -tail -f"'
alias tailasm='adrci exec="set home +asm/+ASM;show alert -tail -f"'