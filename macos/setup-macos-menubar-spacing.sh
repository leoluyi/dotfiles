#!/usr/bin/env bash

# [Can the spacing of menu bar apps be modified in macOS Big Sur and later?](https://apple.stackexchange.com/a/465674/318584)
# [macOS - Reddit](https://www.reddit.com/r/MacOS/)

defaults -currentHost write -globalDomain NSStatusItemSpacing -int 5
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 5

# In Terminal/commandline, run:
#
# ```shell
# defaults -currentHost write -globalDomain NSStatusItemSpacing -int x
# defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int y
# ```
#
# Logout/relogin to apply changes.
#
# A value of 6 (x) for spacing and 12 (y) for padding looks ideal to me, but your
# mileage may vary. It seems that results are optimal when the padding value is twice
# the spacing value.
#
# Values can be decreased down to 0 for extra-compact appearance. Keep in mind
# that below a certain value, the small Location Services symbol periodically
# appearing in the Control Center menu bar item might be cut off.
#
# Revert back to default settings (Terminal/commandline):
#
# ```shell
# defaults -currentHost delete -globalDomain NSStatusItemSelectionPadding
# defaults -currentHost delete -globalDomain NSStatusItemSpacing
# ```
