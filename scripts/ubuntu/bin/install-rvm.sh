#!/bin/bash

function load_rvm {
	cat <<-EOF >> ~/.profile
[[ -s ~/.rvm/scripts/rvm ]] && . ~/.rvm/scripts/rvm
EOF
	. ~/.profile
}

function install_rvm {
  log "installing rvm"
  bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
  echo 'export rvm_project_rvmrc=1' >> $HOME/.rvmrc
  load_rvm
}

function check_rvm {
  load_rvm
  hash rvm || install_rvm
  log "rvm installed"
}

function fix_rvm_readline_for_macos_tiger {
  if [[ `uname` == 'Darwin' ]] && [[ `uname -r` == 11* ]]; then
    (cd "$HOME/.rvm/src/readline-6.0" && \
      sed -i "" -e"s/darwin\[89\]\*\|darwin10\*/darwin\[89\]\*\|darwin1\[01\]\*/g" support/shobj-conf && \
      ./configure --prefix="$HOME/.rvm/usr/" && \
      make clean && \
      make && \
      make install)
  fi
}

function install_xslt {
  [[ -d "$HOME/.rvm/usr/include/libxslt" ]] || \
    ( cd /tmp && \
    rm -rf libxslt-1.1.26 && \
    wget -c ftp://xmlsoft.org/libxml2/libxslt-1.1.26.tar.gz && \
    tar -zxvf libxslt-1.1.26.tar.gz && \
    cd libxslt-1.1.26 && \
    ./configure --prefix="$HOME/.rvm/usr" --with-libxml-prefix="$HOME/.rvm/usr" && \
    make && \
    make install )
}

function install_ruby {
  log "installing ruby"
  rvm pkg install libxml2 && \
  rvm pkg install openssl && \
  rvm pkg install ncurses && \
  rvm pkg install readline && \
  fix_rvm_readline_for_macos_tiger && \
  install_xslt && \
  rvm install ruby-1.8.7-p352 -C "--with-readline-dir=$HOME/.rvm/usr --with-xml-dir=$HOME/.rvm/usr --with-openssl-dir=$HOME/.rvm/usr" && \
  rvm use 1.8.7-p352 &&
}

function check_ruby {
  rvm list | grep 1.8.7-p352 > /dev/null || install_ruby
  log "ruby installed"
}

function install_bundler {
  log "installing bundler"
  gem sources | grep "http://rubygems.org/" || gem sources -a http://rubygems.org/ && \
  gem sources | grep "http://gems.rubyforge.org/" || gem sources -a http://gems.rubyforge.org/ && \
  gem install bundler --no-ri --no-rdoc
}

function check_bundler {
  which bundle | grep 1.8.7-p352 > /dev/null || install_bundler
  log "bundler installed"
}

function ruby_environment {
  check_rvm && \
  check_ruby && \
  check_bundler
}

ruby_environment
