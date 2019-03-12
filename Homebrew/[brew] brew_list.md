# Homebrew Package List

### Install packages

```
$ brew install \
asciinema     `# record terminal sessions` \
atomicparsley `# setting metadata into MPEG-4` \
bash \
bash-completion \
bash-git-prompt \
bfg \
cmatrix \
coreutils \
czmq \
ffmpeg \
gcc \
gdal \
git \
gnupg \
grep \
grip \
highlight \
htop-osx \
john-jumbo `# password crack` \
libpng \
libsvg \
libxml2 \
libzip \
npm \
openssl \
pdfcrack   `# pdf password crack` \
peco \     `# Simplistic interactive filtering tool` \
pip-completion \
pipenv \
plowshare  `# 免空神器` \
proj \
pyenv \
pyenv-virtualenv \
rename \
shellcheck \
terminal-notifier \
thefuck \
tldr \
tmux \
tree \
vim \
wget \
ydiff \
youtube-dl \

$ brew tap eddieantonio/eddieantonio && brew install imgcat
```

### Using homebrew

Update

```
$ brew update && brew upgrade
```

List Installed Packages

```
$ brew list
```

---------------------------------------------

## brew cask

Install homebrew-cask

```
$ brew tap caskroom/cask
$ brew tap homebrew/cask-fonts
```

### Cask list

```
$ brew cask install \
dash \
deckset \
font-meslo-for-powerline \
iina \
iterm2 \
java \
jupyter-notebook-viewer \
keycastr \
macdown \
obs \
r-app \
rstudio \
sourcetree \
spectacle \
tabula \
transmission \
xquartz \
qlcolorcode qlstephen qlmarkdown quicklook-json webpquicklook suspicious-package quicklookase qlvideo
```

[qlImageSize](https://github.com/L1cardo/qlImageSize) manually install

1. Download the file from [here](https://github.com/L1cardo/qlImageSize/releases)
2. Unzip the file you have just downloaded and you will get a file named `qlImageSize.qlgenerator`
3. Copy the `qlImageSize.qlgenerator` to the `/Users/⁨<your-user-name>⁨/Library/QuickLook⁩/` (You may need a password permission)
4. Launch `Terminal.app` and run `qlmanage -r`

### Using casks

Searching for Casks

```
$ brew search <PGMNAME>
```

List installed cask

```
$ brew cask list
```

Update

```
$ brew cask update
```

Uninstall

```
$ brew cask uninstall <PGMNAME>
```

### References

- https://brew.sh/
- http://caskroom.io/
- [Yenlung - [Keynote] 程式碼高亮化](http://yenlung-blog.logdown.com/posts/773053-keynote-code-highlighting)
- [Mac - quick-look-plugins](https://github.com/sindresorhus/quick-look-plugins)
- [QuickLook Video](https://github.com/Marginal/QLVideo)
- [Grip -- GitHub Readme Instant Preview](https://github.com/joeyespo/grip)
