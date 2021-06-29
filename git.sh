# Install git
sudo dnf -y install git

# Create git directory
mkdir ~/git

# Show git branch in folder (Custom ~/.bash_profile)
echo 'parse_git_branch() {' >>~/.bashrc
echo "    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'" >>~/.bashrc
echo '}' >>~/.bashrc
echo 'export PS1="[\u@\h \W\[\033[33m\]\$(parse_git_branch)\[\033[00m\]]$ "' >>~/.bashrc
source ~/.bashrc

# Github Credentials
git config --global user.email "yuripourre@gmail.com"
git config --global user.name "Yuri Pourre"

# Github Tools
git config --global core.editor "vi"
git config --global merge.tool meld

