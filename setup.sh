#!/bin/bash

if [ ! -f ~/.gem/ruby/2.0.0/bin/kitchenplan ]; then
  gem install --no-ri --no-rdoc --user-install kitchenplan || return $?
fi

if [ ! -d /opt/kitchenplan ]; then
  ~/.gem/ruby/2.0.0/bin/kitchenplan setup \
    --config \
    --gitrepo=git@github.com:pr0d1r2/kitchenplan-config.git \
    return $?
fi

~/.gem/ruby/2.0.0/bin/kitchenplan provision
