# [Mac] brew multiple Java versions for macOS

The cleanest way to manage multiple java versions on Mac is to use Homebrew.

And within Homebrew, use:

- `homebrew-cask` to install the versions of java
- `jenv` to manage the installed versions of java

As seen on http://hanxue-it.blogspot.ch/2014/05/installing-java-8-managing-multiple.html , these are the steps to follow.

1. Install `homebrew`
2. Install homebrew `jenv`
3. Install `homebrew-cask`
4. Install a specific java version using cask (see "homebrew-cask versions" paragraph below)
5. Add this version for jenv to manage it
6. Check the version is correctly managed by `jenv`
7. Repeat steps 4 to 6 for each version of java you need

---

## Use jenv

https://developer.bring.com/blog/configuring-jenv-the-right-way/

```sh
# Ensure that JAVA_HOME is correct
jenv enable-plugin export
# Make Maven aware of the Java version in use (and switch when your project does)
jenv enable-plugin maven
```

## References

- https://stackoverflow.com/a/29195815
- https://medium.com/@chamikakasun/how-to-manage-multiple-java-version-in-macos-e5421345f6d0
- https://medium.com/@brunofrascino/working-with-multiple-java-versions-in-macos-9a9c4f15615a

---

## Install OpenJDK 8 on Mac using brew (AdoptopenJDK)

https://installvirtual.com/install-openjdk-8-on-mac-using-brew-adoptopenjdk/

```sh
brew tap adoptopenjdk/openjdk
brew install --cask adoptopenjdk/openjdk/adoptopenjdk8
```

---

## homebrew-cask versions (DEPRECATED)

Homebrew will install the OpenJDK version of Java.

```sh
brew tap homebrew/cask-versions
```

Then you can look at all the versions available:

```sh
brew search java
```

Then you can install the version(s) you like:

```sh
brew install java
brew install java11
```

You can check the paths of the versions installed using

```sh
/usr/libexec/java_home -V
```

And add them to be managed by jenv as usual.

```sh
jenv add <javaVersionPathHere>
```

The java casks are used internally by Homebrew and point to the default versions that can fufill the Java requirement, `java` for `9+` and `java8` for `1.8`.
