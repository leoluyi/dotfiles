# R settings

## Locale

R.app automatically detects user's settings in the International section of the
System Preferences and uses that information to offer translated messages
and GUI if available.

```bash
$ defaults write org.R-project.R force.LANG en_US.UTF-8
```

Please note that you must always use `.UTF-8` version of the locale,
otherwise `R.app` will not work properly.

## rJava

1. Install open JDK

```bash
$ brew tap AdoptOpenJDK/openjdk
$ brew cask install adoptopenjdk
```

Or Java

```bash
$ brew cask install java
$ brew cask info java
```

2. Install rJava from CRAN

```bash
$ sudo R CMD javareconf
```

Result:

```
Java interpreter : /usr/bin/java
Java version     : 12
Java home path   : /Library/Java/JavaVirtualMachines/openjdk-12.jdk/Contents/Home
Java compiler    : /usr/bin/javac
Java headers gen.: /usr/bin/javah
Java archive tool: /usr/bin/jar

trying to compile and link a JNI program
detected JNI cpp flags    : -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/darwin
detected JNI linker flags : -L$(JAVA_HOME)/lib/server -ljvm
clang -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG -I/Library/Java/JavaVirtualMachines/openjdk-12.jdk/Contents/Home/include -I/Library/Java/JavaVirtualMachines/openjdk-12.jdk/Contents/Home/include/darwin  -I/usr/local/include   -fPIC  -Wall -g -O2  -c conftest.c -o conftest.o
clang -dynamiclib -Wl,-headerpad_max_install_names -undefined dynamic_lookup -single_module -multiply_defined suppress -L/Library/Frameworks/R.framework/Resources/lib -L/usr/local/lib -o conftest.so conftest.o -L/Library/Java/JavaVirtualMachines/openjdk-12.jdk/Contents/Home/lib/server -ljvm -F/Library/Frameworks/R.framework/.. -framework R -Wl,-framework -Wl,CoreFoundation


JAVA_HOME        : /Library/Java/JavaVirtualMachines/openjdk-12.jdk/Contents/Home
Java library path: $(JAVA_HOME)/lib/server
JNI cpp flags    : -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/darwin
JNI linker flags : -L$(JAVA_HOME)/lib/server -ljvm
Updating Java configuration in /Library/Frameworks/R.framework/Resources
Done.
```

Install `rJava` in R:

```r
> install.packages("rJava", repos="https://cloud.r-project.org/")
```
