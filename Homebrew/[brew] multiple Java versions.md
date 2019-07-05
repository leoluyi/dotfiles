# [Mac] brew multiple Java versions

https://stackoverflow.com/a/29195815

```
brew tap caskroom/versions
```

Then you can look at all the versions available:

```
brew cask search java
```

Then you can install the version(s) you like:

```
brew cask install java8
brew cask install java9
```

The java casks are used internally by Homebrew and point to the default versions that can fufill the Java requirement, `java` for `9+` and `java8` for `1.8`.
