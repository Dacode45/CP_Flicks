#!/bin/bash
# To use this file type chmod +x ./cocoapods_setup.sh in terminal.
#then run ./cocoapods_setup.sh in terminal.
#setup will take a while.
#Afterwards type source ~/.bash_profile
#then rbenv local 2.0.0-p247

git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
mkdir ~/.rbenv/plugins
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 2.0.0-p247
rbenv local 2.0.0-p247
gem install cocoapods
rbenv local 2.0.0-p247