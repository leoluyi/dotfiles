find /usr/local/Caskroom -name "*.qlgenerator" -print0 | xargs -0 xattr -d com.apple.quarantine 2>/dev/null
