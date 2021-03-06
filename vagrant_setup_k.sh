#!/usr/bin/env bash

# Setup vagrant environment.

# make_link source destination.
function make_link {
    local source=$1
    local destination=$2

    if [[ -L $destination ]]; then
        rm $destination
        echo "removed symbolic link $destination"
    fi

    if [[ -e $destination ]]; then
        rm -rf $destination
        echo "removed file $destination"
    fi

    ln -s $source $destination
    chown -h vagrant:vagrant $destination

    if [[ -L $destination ]]; then
        echo "created symbolic link $destination to $source"
    else
        echo "error: could not create symbolic link $destination to $source"
        exit 1
    fi
}

# This should be run only as root from the vagrant provisioning
# process.
if [[ "$(whoami)" != "root" ]]; then
    echo "error: must run with root from vagrant provisioning"
    exit 1
fi

# Can only run in linux.
if [[ "$(uname)" == "Darwin" ]]; then
    echo "error: can not run script in Mac OS X"
    exit 1
fi

# Check that git exists.
if [[ ! -e /usr/bin/git ]]; then
    echo "error: git not present"
    exit 1
fi

# Check that /home/vagrant/host exists.
if [[ ! -e /home/vagrant/host ]]; then
    echo "error: /home/vagrant/host not present"
    exit 1
fi

# Make ~/tmp.
if [[ ! -d /home/vagrant/tmp ]]; then
    mkdir /home/vagrant/tmp
    chown vagrant:vagrant /home/vagrant/tmp
    echo "created /home/vagrant/tmp directory"
fi

# Save the original .bashrc
mv /home/vagrant/.bashrc /home/vagrant/.bashrc.original
chown vagrant:vagrant /home/vagrant/.bashrc.original

# Make the ~/.config hiearchy.
mkdir -p /home/vagrant/.config
chown -R vagrant:vagrant /home/vagrant/.config

# Make ~/.ipython hiearchy.
mkdir -p /home/vagrant/.ipython/profile_default
chown -R vagrant:vagrant /home/vagrant/.ipython

# Link all of the directories and dot files.
make_link /home/vagrant/dot-files/.spacetrack.ini              /home/vagrant/.spacetrack.ini
make_link /home/vagrant/dot-files/ubuntu-vagrant/.gitconfig    /home/vagrant/.gitconfig
make_link /home/vagrant/dot-files/ubuntu-vagrant/.bash_profile /home/vagrant/.bash_profile
make_link /home/vagrant/dot-files/ubuntu-vagrant/.bashrc       /home/vagrant/.bashrc
make_link /home/vagrant/dot-files/ipython_config.py            /home/vagrant/.ipython/profile_default/ipython_config.py
make_link /home/vagrant/dot-files/ipython_kernel_config.py     /home/vagrant/.ipython/profile_default/ipython_kernel_config.py
make_link /home/vagrant/dot-files/flake8                       /home/vagrant/.config/flake8

# Set up emacs
( cd /home/vagrant ;          su vagrant -c "git clone https://github.com/glennehrlich/emacs.d .emacs.d" )
( cd /home/vagrant ;          su vagrant -c "mkdir .emacs.d.elpa" )
( cd /home/vagrant/.emacs.d ; su vagrant -c "EMACS=/usr/local/bin/emacs make create_persistent_dirs" )
( cd /home/vagrant/.emacs.d ; su vagrant -c "EMACS=/usr/local/bin/emacs make update_elpa" )
( cd /home/vagrant/.emacs.d ; su vagrant -c "EMACS=/usr/local/bin/emacs make clean all" )
rm -rf /home/vagrant/.emacs.d.persistent.old

# Get adobe source code pro fonts.
git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git /home/vagrant/.fonts/adobe-fonts/source-code-pro
fc-cache -f -v /home/vagrant/.fonts/adobe-fonts/source-code-pro
chown -R vagrant:vagrant /home/vagrant/.fonts
echo "added adobe source code pro font"

# Remove useless files.
rm -f /home/vagrant/.bash_logout /home/vagrant/.profile
echo "removed useless files"

# Remove useless folders.
rm -rf Documents Music Pictures Public Templates Videos
echo "removed useless folders"

# Visual studio code setup.
if [[ -e /snap/bin/code ]]; then
    su -l vagrant -c "code --install-extension tuttieee.emacs-mcx"
    su -l vagrant -c "code --install-extension VisualStudioExptTeam.vscodeintellicode"
    echo "set up visual studio code"
fi

# Visual studio code insiders setup.
if [[ -e /snap/bin/code-insiders ]]; then
    su -l vagrant -c "code-insiders --install-extension tuttieee.emacs-mcx"
    su -l vagrant -c "code-insiders --install-extension VisualStudioExptTeam.vscodeintellicode"
    echo "set up visual studio code insiders"
fi

exit 0
