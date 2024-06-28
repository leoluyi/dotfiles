
## Disabling System Integrity Protection

1. Turn off your device
2. Apple Silicon (apple docs):

Press and hold the power button on your Mac until “Loading startup options” appears.
Click Options, then click Continue.

3. In the menu bar, choose Utilities, then Terminal

```
#
# APPLE SILICON
#

# If you're on Apple Silicon macOS 13.x.x, or 12.x.x
# Requires Filesystem Protections, Debugging Restrictions and NVRAM Protection to be disabled
# (printed warning can be safely ignored)
csrutil disable --with kext --with dtrace --with basesystem

#
# INTEL
#

# If you're on Intel macOS 13.x.x, 12.x.x, or 11.x.x
# Requires Filesystem Protections and Debugging Restrictions to be disabled (workaround because --without debug does not work)
# (printed warning can be safely ignored)
csrutil disable --with kext --with dtrace --with nvram --with basesystem
```

4. Reboot
5. For Apple Silicon; enable non-Apple-signed arm64e binaries

```
# Open a terminal and run the below command, then reboot
sudo nvram boot-args=-arm64e_preview_abi
```

7. You can verify that System Integrity Protection is turned off by running `csrutil status`, which returns `System Integrity Protection status: disabled.` if it is turned off (it may show `unknown` for newer versions of macOS when disabling SIP partially).
