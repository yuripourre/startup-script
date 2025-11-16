# Git configuration variables
# Accept command-line arguments
GIT_USER_EMAIL="$1"
GIT_USER_NAME="$2"

# Install git
sudo dnf -y install git

# Create git directory
mkdir ~/git

echo '# Color list' >>~/.bashrc
echo 'COLOR_RESET=$'"'"'\033[0m'"'"'' >>~/.bashrc
echo 'COLOR_BLACK=$'"'"'\033[0;30m'"'"'' >>~/.bashrc
echo 'COLOR_DARK_GRAY=$'"'"'\033[1;30m'"'"'' >>~/.bashrc
echo 'COLOR_RED=$'"'"'\033[0;31m'"'"'' >>~/.bashrc
echo 'COLOR_LIGHT_RED=$'"'"'\033[1;31m'"'"'' >>~/.bashrc
echo 'COLOR_GREEN=$'"'"'\033[0;32m'"'"'' >>~/.bashrc
echo 'COLOR_LIGHT_GREEN=$'"'"'\033[1;32m'"'"'' >>~/.bashrc
echo 'COLOR_ORANGE=$'"'"'\033[0;33m'"'"'' >>~/.bashrc
echo 'COLOR_YELLOW=$'"'"'\033[1;33m'"'"'' >>~/.bashrc
echo 'COLOR_BLUE=$'"'"'\033[0;34m'"'"'' >>~/.bashrc
echo 'COLOR_LIGHT_BLUE=$'"'"'\033[1;34m'"'"'' >>~/.bashrc
echo 'COLOR_PURPLE=$'"'"'\033[0;35m'"'"'' >>~/.bashrc
echo 'COLOR_LIGHT_PURPLE=$'"'"'\033[1;35m'"'"'' >>~/.bashrc
echo 'COLOR_CYAN=$'"'"'\033[0;36m'"'"'' >>~/.bashrc
echo 'COLOR_LIGHT_CYAN=$'"'"'\033[1;36m'"'"'' >>~/.bashrc
echo 'COLOR_GRAY=$'"'"'\033[0;37m'"'"'' >>~/.bashrc
echo 'COLOR_WHITE=$'"'"'\033[1;37m'"'"'' >>~/.bashrc
echo 'COLOR_OCHRE=$'"'"'\033[38;5;95m'"'"'' >>~/.bashrc
echo '' >>~/.bashrc
echo 'git_color() {' >>~/.bashrc
echo '  git rev-parse --is-inside-work-tree &>/dev/null || return' >>~/.bashrc
echo '  local status' >>~/.bashrc
echo '  status=$(git status --porcelain 2>/dev/null)' >>~/.bashrc
echo '  ' >>~/.bashrc
echo '  if echo "$status" | grep -q "^A "; then' >>~/.bashrc
echo '    # New files added/staged for commit' >>~/.bashrc
echo '    echo -n "$COLOR_GREEN"' >>~/.bashrc
echo '  elif echo "$status" | grep -q "^[MDRCT]"; then' >>~/.bashrc
echo '    # Other files staged for commit (modified, deleted, renamed, copied, or type-changed)' >>~/.bashrc
echo '    echo -n "$COLOR_LIGHT_GREEN"' >>~/.bashrc
echo '  elif echo "$status" | grep -q "^ M"; then' >>~/.bashrc
echo '    # Modified files not staged for commit (working directory has changes)' >>~/.bashrc
echo '    echo -n "$COLOR_CYAN"' >>~/.bashrc
echo '  elif echo "$status" | grep -q "^??"; then' >>~/.bashrc
echo '    # Untracked files (new files not added to git)' >>~/.bashrc
echo '    echo -n "$COLOR_PURPLE"' >>~/.bashrc
echo '  elif [ -z "$status" ]; then' >>~/.bashrc
echo '    # Clean working directory (no changes, ready to commit)' >>~/.bashrc
echo '    echo -n "$COLOR_ORANGE"' >>~/.bashrc
echo '  else' >>~/.bashrc
echo '    # Any other git status (conflicts, deleted files, etc.)' >>~/.bashrc
echo '    echo -n "$COLOR_RED"' >>~/.bashrc
echo '  fi' >>~/.bashrc
echo '}' >>~/.bashrc
echo '' >>~/.bashrc
echo 'get_git_branch() {' >>~/.bashrc
echo '  local branch' >>~/.bashrc
echo '  if git rev-parse --is-inside-work-tree &>/dev/null; then' >>~/.bashrc
echo '    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)' >>~/.bashrc
echo '    echo "($branch)"' >>~/.bashrc
echo '  fi' >>~/.bashrc
echo '}' >>~/.bashrc
echo '' >>~/.bashrc
echo 'PS1='"'"'[\u@\h \W\[$(git_color)\]$(get_git_branch)\[$(echo -n "$COLOR_RESET")\]]\$ '"'"'' >>~/.bashrc
echo 'export PS1' >>~/.bashrc

source ~/.bashrc

# Github Credentials
git config --global user.email "$GIT_USER_EMAIL"
git config --global user.name "$GIT_USER_NAME"

# Github Tools
git config --global core.editor "vi"
git config --global merge.tool meld

