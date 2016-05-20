#!/bin/bash

PID=`echo $$`

ps -ax | grep "^$PID" | grep -q " /bin/bash "
NOT_RUNNING_FROM_BASH=$?
if [ $NOT_RUNNING_FROM_BASH -gt 0 ]; then
  ps -ax | grep "^$PID" | grep -q " sh setup.sh "
  NOT_RUNNING_FROM_BASH=$?
fi

if [ $NOT_RUNNING_FROM_BASH -eq 0 ]; then
    D_R=`cd \`dirname $0\` ; pwd -P`
    echo "sudo -i -u `whoami` /bin/bash $D_R/setup.sh"
    sudo -i -u `whoami` /bin/bash $D_R/setup.sh
    exit $?
fi

export PATH="~/.gem/ruby/2.0.0/bin:$PATH"

if [ ! -d /opt/chefdk ]; then
  curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -c current -P chefdk -v 0.14
fi

export PATH="/opt/chefdk/embedded/bin:~/.gem/ruby/2.0.0/bin:$PATH"

if [ ! -d ~/projects/kitchenplan ]; then
  git clone git@github.com:h13ronim/kitchenplan.git ~/projects/kitchenplan || exit $?
fi

if [ ! -f ~/.gem/ruby/2.0.0/bin/kitchenplan ]; then
  cd ~/projects/kitchenplan || exit $?
  gem build kitchenplan.gemspec || exit $?
  gem install kitchenplan-*.gem --no-ri --no-rdoc --user-install || exit $?
fi

if [ -d /opt/kitchenplan ]; then
  cd /opt/kitchenplan || exit $?
  git pull || exit $?
else
  ~/.gem/ruby/2.0.0/bin/kitchenplan setup \
    --config \
    --gitrepo=git@github.com:pr0d1r2/kitchenplan-config.git || exit $?
fi

~/.gem/ruby/2.0.0/bin/kitchenplan provision
