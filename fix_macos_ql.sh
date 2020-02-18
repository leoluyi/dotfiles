#!/usr/bin/env bash
# https://github.com/anthonygelibert/QLColorCode/issues/51
# https://github.com/whomwah/qlstephen/issues/81#issuecomment-582207278

# find /usr/local/Caskroom -name "*.qlgenerator" -print0 | xargs -0 xattr -d com.apple.quarantine 2>/dev/null
find /usr/local/Caskroom -name "*.qlgenerator" -print0 | xargs -I_ -0 xattr -cr _ 2>/dev/null
# xattr -cr ~/Library/QuickLook/QLStephen.qlgenerator

qlmanage -r
