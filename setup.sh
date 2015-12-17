#!/bin/bash

PID=`echo $$`
case `ps -ax | grep "^$PID" | grep " /bin/bash "` in
  "")
    D_R=`cd \`dirname $0\` ; pwd -P`
    echo "sudo -i -u `whoami` /bin/bash $D_R/setup.sh"
    sudo -i -u `whoami` /bin/bash $D_R/setup.sh
    exit $?
    ;;
esac

export PATH="~/.gem/ruby/2.0.0/bin:$PATH"

if [ ! -f ~/.gem/ruby/2.0.0/bin/kitchenplan ]; then
  gem install --no-ri --no-rdoc --user-install kitchenplan || return $?
fi

if [ ! -f ~/.gem/ruby/2.0.0/bin/bundle ]; then
  gem install --no-ri --no-rdoc --user-install bundler || return $?
fi

if [ -d /opt/kitchenplan ]; then
  cd /opt/kitchenplan || return $?
  git pull || return $?
else
  ~/.gem/ruby/2.0.0/bin/kitchenplan setup \
    --config \
    --gitrepo=git@github.com:pr0d1r2/kitchenplan-config.git \
    return $?
fi

~/.gem/ruby/2.0.0/bin/kitchenplan provision
