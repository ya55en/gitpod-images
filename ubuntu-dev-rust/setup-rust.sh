#! /bin/sh
# Setup ubuntu-dev:rust image for 'docker build'

# References:
# [1] https://askubuntu.com/questions/1173337/how-to-prevent-system-from-being-minimized


GITPOD_HOME=/home/gitpod

## Setup rust

export CARGO_HOME=$GITPOD_HOME/.cargo
export RUSTUP_HOME=$GITPOD_HOME/.rustup

# Install Rustup
INSTALL_RUSTUP_ARGS='-t stable -y -q --no-modify-path'
curl -sSf https://sh.rustup.rs | sh -s -- $INSTALL_RUSTUP_ARGS

# Setup environment to find rust binaries
cat > $GITPOD_HOME/.bashrc.d/rust-env.sh <<EOS
export CARGO_HOME=$CARGO_HOME
export RUSTUP_HOME=$RUSTUP_HOME
export PATH="\$PATH:\$CARGO_HOME/bin"
EOS

$CARGO_HOME/bin/cargo --version
$CARGO_HOME/bin/rustc --version

# Fix permissions and cleanup
chown -Rh gitpod:gitpod $GITPOD_HOME
