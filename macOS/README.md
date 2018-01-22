# Upgrade to bash 4 in Mac OS X

http://clubmate.fi/upgrade-to-bash-4-in-mac-os-x/

### Install bash

Bash version can be queried with the --version flag:

```
$ bash --version
3.2.53(1)-release
```

Update homebrew packet database and install bash:

```
$ brew update && brew install bash
```

`$ bash --version` might show 4.x, but bash might be using 3.x still, it’s straightforward to test, the global variable `$BASH_VERSION` returns bash version.

### Configure terminal to use it 

```
# Add the new shell to the list of allowed shells
sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
# Change to the new shell
chsh -s /usr/local/bin/bash
```


