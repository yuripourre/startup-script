# Install Java Stuff
sudo dnf -y install maven ant

# Install Java OpenJDK 21
sudo dnf -y install java-21-openjdk-devel

# Download and install IntelliJ
cd ~/
wget -O idea-IC.tar.gz https://download.jetbrains.com/idea/ideaIC-2025.1.tar.gz
tar -xvzf idea-IC.tar.gz
rm idea-IC.tar.gz
mv idea-IC* idea-IC
cd -

# Google Style
#wget https://raw.githubusercontent.com/google/styleguide/gh-pages/intellij-java-google-style.xml
#https://gerrit-review.googlesource.com/Documentation/dev-intellij.html
