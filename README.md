GIT for CYGWIN
==============


INSTALLING
----------

Download latest release from `https://github.com/mlewissmith/CygGit/releases`

Run self-extracting tarball


UNINSTALLING
------------

**COPY** the uninstall script into `/tmp`.  Edit the header and remove the `exit 1` line.

    cp /etc/uninstall/git-X.X.X-uninstall.sh /tmp
    vi /tmp/git-X.X.X-uninstall.sh # edit header
    /tmp/git-X.X.X-uninstall.sh


BUILDING FROM SOURCE
--------------------
Clone this repository

    git clone https://github.com/mlewissmith/CygGit.git

Update submodule(s)

    cd CygGit
    git submodule update

Run buildscript
  
    ./build.sh

... creates self-extracting tarball.  Run it.
