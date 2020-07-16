# [Mac] brew multiple Java versions for macOS

- https://stackoverflow.com/a/29195815
- https://medium.com/@chamikakasun/how-to-manage-multiple-java-version-in-macos-e5421345f6d0
- https://medium.com/@brunofrascino/working-with-multiple-java-versions-in-macos-9a9c4f15615a

The cleanest way to manage multiple java versions on Mac is to use Homebrew.

And within Homebrew, use:

- `homebrew-cask` to install the versions of java
- `jenv` to manage the installed versions of java

As seen on http://hanxue-it.blogspot.ch/2014/05/installing-java-8-managing-multiple.html , these are the steps to follow.

1. install `homebrew`
2. install homebrew `jenv`
3. install `homebrew-cask`
4. install a specific java version using cask (see "homebrew-cask versions" paragraph below)
5. add this version for jenv to manage it
6. check the version is correctly managed by jenv
7. repeat steps 4 to 6 for each version of java you need


---

## jenv

https://developer.bring.com/blog/configuring-jenv-the-right-way/

```
# ensure that JAVA_HOME is correct
jenv enable-plugin export
# make Maven aware of the Java version in use (and switch when your project does)
jenv enable-plugin maven
```

---

## homebrew-cask versions

Homebrew will install the Open JDK version of Java.

```
brew tap homebrew/cask-versions
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

You can check the paths of the versions installed using

```
/usr/libexec/java_home -V
```

And add them to be managed by jenv as usual.

```
jenv add <javaVersionPathHere>
```

The java casks are used internally by Homebrew and point to the default versions that can fufill the Java requirement, `java` for `9+` and `java8` for `1.8`.

---

## Install OpenJDK 8 on Mac using brew (AdoptopenJDK)

https://installvirtual.com/install-openjdk-8-on-mac-using-brew-adoptopenjdk/

```
brew tap adoptopenjdk/openjdk
brew cask install adoptopenjdk/openjdk/adoptopenjdk8
```
