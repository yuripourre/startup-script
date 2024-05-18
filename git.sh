# Install git
sudo dnf -y install git meld

# Create git directory
mkdir ~/git

COLOR_RESET="\[\033[00m\]"

# Show branch in terminal
echo '# Color list' >>~/.bashrc
echo 'COLOR_RESET="\[\033[00m\]"' >>~/.bashrc
echo 'COLOR_BLACK="\[\033[0;30m\]"' >>~/.bashrc
echo 'COLOR_DARK_GRAY="\[\033[1;30m\]"' >>~/.bashrc
echo 'COLOR_RED="\[\033[0;31m\]"' >>~/.bashrc
echo 'COLOR_LIGHT_RED="\[\033[1;31m\]"' >>~/.bashrc
echo 'COLOR_GREEN="\[\033[0;32m\]"' >>~/.bashrc
echo 'COLOR_LIGHT_GREEN="\[\033[1;32m\]"' >>~/.bashrc
echo 'COLOR_ORANGE="\[\033[0;33m\]"' >>~/.bashrc
echo 'COLOR_YELLOW="\[\033[1;33m\]"' >>~/.bashrc
echo 'COLOR_BLUE="\[\033[0;34m\]"' >>~/.bashrc
echo 'COLOR_LIGHT_BLUE="\[\033[1;34m\]"' >>~/.bashrc
echo 'COLOR_PURPLE="\[\033[0;35m\]"' >>~/.bashrc
echo 'COLOR_LIGHT_PURPLE="\[\033[1;35m\]"' >>~/.bashrc
echo 'COLOR_CYAN="\[\033[0;36m\]"' >>~/.bashrc
echo 'COLOR_LIGHT_CYAN="\[\033[1;36m\]"' >>~/.bashrc
echo 'COLOR_GRAY="\[\033[0;37m\]"' >>~/.bashrc
echo 'COLOR_WHITE="\[\033[1;37m\]"' >>~/.bashrc
echo '## Custom colors' >>~/.bashrc
echo 'COLOR_OCHRE="\[\033[38;5;95m\]"' >>~/.bashrc
echo '' >>~/.bashrc
echo 'function git_color {' >>~/.bashrc
echo '  local git_status="$(git status 2> /dev/null)"' >>~/.bashrc
echo '  if [[ $git_status =~ "Changes not staged for commit" ]]; then' >>~/.bashrc
echo '    echo -e $COLOR_CYAN' >>~/.bashrc
echo '  elif [[ $git_status =~ "Untracked files" ]]; then' >>~/.bashrc
echo '    echo -e $COLOR_OCHRE' >>~/.bashrc
echo '  elif [[ $git_status =~ "Changes to be committed" ]]; then' >>~/.bashrc
echo '    echo -e $COLOR_PURPLE' >>~/.bashrc
echo '  elif [[ $git_status =~ "nothing to commit" ]]; then' >>~/.bashrc
echo '    echo -e $COLOR_ORANGE' >>~/.bashrc
echo '  else' >>~/.bashrc
echo '    echo -e $COLOR_RED' >>~/.bashrc
echo '  fi' >>~/.bashrc
echo '}' >>~/.bashrc
echo '' >>~/.bashrc
echo 'function git_branch {' >>~/.bashrc
echo '  local git_status="$(git status 2> /dev/null)"' >>~/.bashrc
echo '  local on_branch="On branch ([^${IFS}]*)"' >>~/.bashrc
echo '  local on_commit="HEAD detached at ([^${IFS}]*)"' >>~/.bashrc
echo '  if [[ $git_status =~ $on_branch ]]; then' >>~/.bashrc
echo '    local branch=${BASH_REMATCH[1]}' >>~/.bashrc
echo '    echo "($branch)"' >>~/.bashrc
echo '  elif [[ $git_status =~ $on_commit ]]; then' >>~/.bashrc
echo '    local commit=${BASH_REMATCH[1]}' >>~/.bashrc
echo '    echo "($commit)"' >>~/.bashrc
echo '  fi' >>~/.bashrc
echo '}' >>~/.bashrc
echo '' >>~/.bashrc
echo 'PS1="[\u@\h \W"             # basename of pwd' >>~/.bashrc
echo 'PS1+="$(git_color)"    # colors git status' >>~/.bashrc
echo 'PS1+="\$(git_branch)"       # prints current branch' >>~/.bashrc
echo 'PS1+="$COLOR_RESET]$ "' >>~/.bashrc
echo 'export PS1' >>~/.bashrc
source ~/.bashrc

# Github Credentials
git config --global user.email "yuripourre@gmail.com"
git config --global user.name "Yuri Pourre"

# Github Tools
git config --global core.editor "vi"
git config --global merge.tool meld

