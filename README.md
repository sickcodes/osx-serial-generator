# OSX Serial Generator

![Running mac osx in a docker container](/running-mac-inside-docker-qemu.png?raw=true "OSX KVM DOCKER")

Generate macOS valid serials, uuids, and board serials for good-faith Security Research & Apple Bug Bounty Research.

This project provides two tools for generating serial numbers for Hackintosh, [OpenCore](https://github.com/acidanthera/OpenCorePkg), [Docker-OSX](https://github.com/sickcodes/Docker-OSX) and [OSX-KVM](https://github.com/kholia/OSX-KVM).

Author: Sick.Codes https://github.com/sickcodes | https://sick.codes | https://twitter.com/sickcodes

### Follow @sickcodes on Twitter for updates! [https://twitter.com/sickcodes](https://twitter.com/sickcodes)

Terms & Conditions: Manipulation of serial numbers are an important aspect of conducting Cyber Security Research into the iMessage & Facetime frameworks. Finding and reporting vulnerabilities in Apple software before Threat Actors do is important. To use this project to find & discover vulnerabilities in said protocols, you should agree to [Apple's Security Bounty program](https://developer.apple.com/security-bounty/requirements/).

### Upstream Thanks

This project was created for use with [Docker-OSX](https://github.com/sickcodes/Docker-OSX) and uses `config.plist` files from [@Kholia](https://github.com/kholia)'s project https://github.com/kholia/OSX-KVM.

The `config.plist` files are also curated and maintained upstream by [@thenickdude](https://github.com/thenickdude) and we thank both of them for their excellent work. Upstream KVM changes are made at: [https://github.com/thenickdude/KVM-Opencore](https://github.com/thenickdude/KVM-Opencore)

This project is a wrapper for the [OpenCore project](https://dortania.github.io/getting-started/) bootloader's fantastic tool called [macserial](https://github.com/acidanthera/OpenCorePkg/tree/master/Utilities/macserial).

Many thanks to the [OpenCore Project](https://dortania.github.io/getting-started/) for providing `macserial`.

See the project which drives Hackintosh: [https://github.com/acidanthera/OpenCorePkg](https://github.com/acidanthera/OpenCorePkg)

As seen on Vice: [Open-Source App Lets Anyone Create a Virtual Army of Hackintoshes](https://www.vice.com/en/article/akdmb8/open-source-app-lets-anyone-create-a-virtual-army-of-hackintoshes)

### PR & Contributor Credits

https://github.com/sickcodes/osx-serial-generator/blob/master/CREDITS.md

## Related

- [Docker-OSX](https://github.com/sickcodes/Docker-OSX)
- [OSX-KVM](https://github.com/kholia/OSX-KVM)
- [KVM-Opencore](https://github.com/thenickdude/KVM-Opencore)
- [OpenCore](https://github.com/acidanthera/OpenCorePkg)
- [Hackintosh](https://www.reddit.com/r/hackintosh/)

# Purpose

These shell scripts were written by [@sickcodes](https://github.com/sickcodes) [https://twitter.com/sickcodes](https://twitter.com/sickcodes) and were created for automating the generation of unique & valid values at runtime in [Docker-OSX](https://github.com/sickcodes/Docker-OSX).

This is for generating sets of serial numbers that simply work.

If this is your first time, just `bash ./generate-unique-machine-values.sh` and you will be given 1 complete serial number set.

With your new serial numbers, you can:
- put them in your existing `config.plist` and reboot
- tell the script to make a new `OpenCore.qcow2`
- output as TSV and CSV, and more!
- use `--help` to see all available goodies

Used at runtime in [Docker-OSX](https://github.com/sickcodes/Docker-OSX).

- [https://github.com/kholia/OSX-KVM](https://github.com/kholia/OSX-KVM): "Run macOS on QEMU/KVM. With OpenCore + Big Sur support now! Only commercial (paid) support is available."

- [https://github.com/sickcodes/Docker-OSX](https://github.com/sickcodes/Docker-OSX): "Run Mac in a Docker! Run near native OSX-KVM in Docker! X11 Forwarding! CI/CD for OS X!"

- [https://github.com/thenickdude/KVM-Opencore](https://github.com/thenickdude/KVM-Opencore): "OpenCore disk image for Proxmox/QEMU"

# Requirements

```bash
# Ubuntu, Debian, Pop
sudo apt update -y
sudo apt install libguestfs-tools build-essential wget git linux-generic gcc uuid-runtime sudo -y

# Fedora, RHEL, CentOS
sudo yum install libguestfs libguestfs-tools wget git kernel-devel gcc sudo -y
sudo yum groupinstall 'Development Tools' -y

# Arch, Manjaro
sudo pacman -Sy libguestfs wget git base-devel linux gcc sudo

```

# Generating New Unique Serial Numbers

Example 

```bash
# make 1 full serial set 
./generate-unique-machine-values.sh \
    -c 1 \
    --model="iMacPro1,1"
```

Done!

CSV file and TSV file should be saved in your current working directory.

Slip those values into your config.plist and reboot!

## Extended options  - Automation?

### Need more serials?

```bash
git clone https://github.com/sickcodes/osx-serial-generator
cd osx-serial-generator

# make 100 serial sets
./generate-unique-machine-values.sh \
    -c 100 \
    --model="iMacPro1,1"
```

### Want to make 50 OpenCore bootdisks AND 50 output plists?

```bash
# make 5 serial sets
# but also make config.plist for each set
# and OpenCore-nopicker.qcow2 for each serial set.
./generate-unique-machine-values.sh \
    -c 50 \
    --create-plists \
    --create-bootdisks
```

## Already have your own `config.plist`?

If you want to automate creating the qcow bootdisk each time, you can use placeholders and let this script build the image each time you change anything.

If you want to use placeholders, you can supply that to either of the scripts in this repo and use:

`--custom-plist=./my_config.plist`

```bash
# make 5 serial sets
# but also use my config.plist for each set
# AND make qcow2 image for each set!
./generate-unique-machine-values.sh \
    -c 5 \
    --custom-plist=./my_config.plist \
    --create-bootdisks
```

You can also use an URL for the input plist using:

`--master-plist-url`.

Or you can manually enter the values generated above:

```xml
    <key>MLB</key>
    <string>{{BOARD_SERIAL}}</string>
    <key>ROM</key>
    <data>{{ROM}}</data>
    <key>SpoofVendor</key>
    <true/>
    <key>SystemProductName</key>
    <string>{{DEVICE_MODEL}}</string>
    <key>SystemSerialNumber</key>
    <string>{{SERIAL}}</string>
    <key>SystemUUID</key>
    <string>{{UUID}}</string>
    ...
    ...
    ...
    <string>{{WIDTH}}x{{HEIGHT}}@32</string>
    ...
    ...
    ...
    <key>boot-args</key>
    <string>-v keepsyms=1 tlbto_us=0 vti=9 {{KERNEL_ARGS}}</string>

```
```
    {{DEVICE_MODEL}}, {{SERIAL}}, {{BOARD_SERIAL}},
    {{UUID}}, {{ROM}}, {{WIDTH}}, {{HEIGHT}}, {{KERNEL_ARGS}}
```

```bash
General options:
    --count, -n, -c <count>         Number of serials to generate
    --model, -m <model>             Device model, e.g. 'iMacPro1,1'
    --csv <filename>                Optionally change the CSV output filename
    --tsv <filename>                Optionally change the TSV output filename
    --output-dir <directory>        Optionally change the script output location
    --width <string>                Resolution x axis length in px, default 1920
    --height <string>               Resolution y axis length in px, default 1080
    --kernel-args <string>          Additional boot-args
    --master-plist-url <url>        Specify an alternative master plist, via URL
    --master-plist <filename>       Optionally change the input plist
    --custom-plist <filename>       Same as --master-plist
    --output-bootdisk <filename>    Optionally change the bootdisk filename
    --envs                          Create all corresponding sourcable envs
    --plists                        Create all corresponding config.plists
    --bootdisks                     Create all corresponding bootdisks [SLOW]
    --help, -h, help                Display this help and exit

Additional options only if you are creating ONE serial set:
    --output-bootdisk <filename>    Optionally change the bootdisk filename
    --output-env <filename>         Optionally change the serials env filename

Custom plist placeholders:
    {{DEVICE_MODEL}}, {{SERIAL}}, {{BOARD_SERIAL}},
    {{UUID}}, {{ROM}}, {{WIDTH}}, {{HEIGHT}}, {{KERNEL_ARGS}}

Example:
    ./generate-unique-machine-values.sh --count 1 --plists --bootdisks --envs

Defaults:
    - One serial, for 'iMacPro1,1', in the current working directory
    - CSV and TSV output
    - plists in ./plists/ & bootdisks in ./bootdisks/ & envs in ./envs
    - if you set --bootdisk name, --bootdisks is assumed
    - if you set --custom-plist, --plists is assumed
    - if you set --output-env, --envs is assumed

```

# Generating A Bootdisk Using Specific Serial Numbers

If you already know the serial numbers, or you've generated them above in the past, then you can use this script:

```bash

Required options:
    --model <string>                Device model, e.g. 'iMacPro1,1'
    --serial <string>               Device Serial number
    --board-serial <string>         Main Logic Board Serial number (MLB)
    --uuid <string>                 SMBIOS UUID (SmUUID)
    --mac-address <string>          Used for both the MAC address and to set ROM
                                    ROM is lowercased sans any colons
Optional options:
    --width <integer>               Resolution x axis length in px, default 1920
    --height <integer>              Resolution y axis length in px, default 1080
    --kernel-args <string>          Additional boot-args
    --master-plist-url <url>        Specify an alternative master plist, via URL
    --custom-plist <filename>       
       || --master-plist <filename> Optionally change the input plist.
    --output-bootdisk <filename>    Optionally change the bootdisk filename
    --output-plist <filename>       Optionally change the output plist filename
    --help, -h, help                Display this help and exit

Placeholders:   {{DEVICE_MODEL}}, {{SERIAL}}, {{BOARD_SERIAL}}, {{UUID}},
                {{ROM}}, {{WIDTH}}, {{HEIGHT}}, {{KERNEL_ARGS}}
```

Example using your serials generated earlier:

```bash
CUSTOM_PLIST=https://raw.githubusercontent.com/sickcodes/osx-serial-generator/master/config-nopicker-custom.plist

./generate-specific-bootdisk.sh \
    --input-plist-url="${CUSTOM_PLIST}" \
    --model iMacPro1,1 \
    --serial C02TW0WAHX87 \
    --board-serial C027251024NJG36UE \
    --uuid 5CCB366D-9118-4C61-A00A-E5BAF3BED451 \
    --mac-address A8:5C:2C:9A:46:2F \
    --output-bootdisk ./OpenCore-nopicker.qcow2 \
    --width 1920 \
    --height 1080 \
    --kernel-args "-pmap_trace"
```


# Examples from Docker-OSX

In the case example of why these scripts were written is:

`GENERATE_UNIQUE` is used as a Docker argument to randomly generate 1 set at runtime, for every new container.

`GENERATE_SPECIFIC` is used to specify an already known model, serial, board-serial, uuid and MAC address.

```bash
[[ "${GENERATE_UNIQUE}" == true ]] && { \
    ./Docker-OSX/custom/generate-unique-machine-values.sh \
        --master-plist-url="${MASTER_PLIST_URL}" \
        --count 1 \
        --tsv ./serial.tsv \
        --bootdisks \
        --width "${WIDTH:-1920}" \
        --height "${HEIGHT:-1080}" \
        --output-bootdisk "${BOOTDISK:=/home/arch/OSX-KVM/OpenCore/OpenCore.qcow2}" \
        --output-env "${ENV:=/env}" \
; } \
; [[ "${GENERATE_SPECIFIC}" == true ]] && { \
        source "${ENV:=/env}" 2>/dev/null \
        ; ./Docker-OSX/custom/generate-specific-bootdisk.sh \
        --master-plist-url="${MASTER_PLIST_URL}" \
        --model "${DEVICE_MODEL}" \
        --serial "${SERIAL}" \
        --board-serial "${BOARD_SERIAL}" \
        --uuid "${UUID}" \
        --mac-address "${MAC_ADDRESS}" \
        --width "${WIDTH:-1920}" \
        --height "${HEIGHT:-1080}" \
        --output-bootdisk "${BOOTDISK:=/home/arch/OSX-KVM/OpenCore/OpenCore.qcow2}"
```


# Special Update Notes

2021-10-28 - `OpenCore-Catalina/OpenCore.qcow2` was moved to `OpenCore/OpenCore.qcow2` in [https://github.com/kholia/OSX-KVM/commit/1cc6430f96b452cb78b9a079c34bb9933144ce18](https://github.com/kholia/OSX-KVM/commit/1cc6430f96b452cb78b9a079c34bb9933144ce18)


2021-06-15 - On June 15th 2021 we updated the config.plist from v12 to v13 via [@thenickdude](https://github.com/thenickdude)'s upstream `config.plist` files from [KVM-Opencore](https://github.com/thenickdude/KVM-Opencore).


```bash
wget https://github.com/thenickdude/KVM-Opencore/compare/v12...v13.patch

patch -F 10 -p1 --verbose config-nopicker-custom.plist v12...v13.patch

patch -F 10 -p1 --verbose config-custom.plist v12...v13.patch

```

Rejected patch lines:
```patch
--- EFI/OC/config.plist
+++ EFI/OC/config.plist
@@ -644,43 +644,6 @@
        </array>
        <key>Patch</key>
        <array>
-           <dict>
-               <key>Arch</key>
-               <string>Any</string>
-               <key>Base</key>
-               <string>_cpu_topology_sort</string>
-               <key>Comment</key>
-               <string>algrey - cpu_topology_sort -disable _x86_validate_topology</string>
-               <key>Count</key>
-               <integer>1</integer>
-               <key>Enabled</key>
-               <true/>
-               <key>Find</key>
-               <data>
-               6AAA//8=
-               </data>
-               <key>Identifier</key>
-               <string>kernel</string>
-               <key>Limit</key>
-               <integer>0</integer>
-               <key>Mask</key>
-               <data>
-               /wAA//8=
-               </data>
-               <key>MaxKernel</key>
-               <string>20.99.99</string>
-               <key>MinKernel</key>
-               <string>17.0.0</string>
-               <key>Replace</key>
-               <data>
-               Dx9EAAA=
-               </data>
-               <key>ReplaceMask</key>
-               <data>
-               </data>
-               <key>Skip</key>
-               <integer>0</integer>
-           </dict>
            <dict>
                <key>Arch</key>
                <string>Any</string>
@@ -922,17 +891,19 @@
                <key>Arguments</key>
                <string></string>
                <key>Auxiliary</key>
-               <false/>
+               <true/>
                <key>Comment</key>
                <string>Memory testing utility</string>
                <key>Enabled</key>
                <false/>
+               <key>Flavour</key>
+               <string>MemTest</string>
                <key>Name</key>
-               <string>memcheck</string>
+               <string>memtest86</string>
                <key>Path</key>
-               <string>memcheck/memcheck.efi</string>
+               <string>memtest86/BOOTX64.efi</string>
                <key>RealPath</key>
-               <false/>
+               <true/>
                <key>TextMode</key>
                <false/>
            </dict>
@@ -981,11 +954,13 @@
                <key>boot-args</key>
                <string>keepsyms=1</string>
                <key>csr-active-config</key>
-               <data>AAAAAA==</data>
+               <data>Jg8=</data>
                <key>prev-lang:kbd</key>
                <data>ZW4tVVM6MA==</data>
                <key>run-efi-updater</key>
                <string>No</string>
+               <key>ForceDisplayRotationInEFI</key>
+               <integer>0</integer>
            </dict>
        </dict>
        <key>Delete</key>
--- Makefile
+++ Makefile
@@ -63,7 +63,7 @@ OpenCore-$(RELEASE_VERSION).iso : OpenCore-$(RELEASE_VERSION).dmg
 
 OpenCoreEFIFolder-$(RELEASE_VERSION).zip : Makefile $(EFI_FILES)
    rm -f $@
-   zip -r $@ EFI
+   zip -X -r $@ EFI
 
 %.gz : %
    gzip -f --keep $<
--- src/AppleALC
+++ src/AppleALC
@@ -1 +1 @@
-Subproject commit 3c2f6315e6aed0cc3c45a9f01f84ef42fb497044
+Subproject commit 93be275a4495a1bdb7ff2c3238053f66b9c5195d
--- src/Lilu
+++ src/Lilu
@@ -1 +1 @@
-Subproject commit 5aeba9f98106a5a8a3057712b74e1608faf5e276
+Subproject commit 614712caa9d84b6e90305839bd74f3872a44a522
--- src/MacKernelSDK
+++ src/MacKernelSDK
@@ -1 +1 @@
-Subproject commit 2b584e8e2081ed22fc619151518921c8636d4639
+Subproject commit e73a6fcd42c94b6a908ad9fe197034c8f4bf442a
--- src/OcBinaryData
+++ src/OcBinaryData
@@ -1 +1 @@
-Subproject commit ccf3d0c36784100293ccfb2865e10cd37f7a78ee
+Subproject commit 6dd2d92383edee522052ebbe2c634c92894b37e6
--- src/OpenCorePkg
+++ src/OpenCorePkg
@@ -1 +1 @@
-Subproject commit 5668fb62b50e8141d93ae6fce3e3fe238822f6ef
+Subproject commit ae515dd0b1efe79940ce94bfd235399ba873a3f0
--- src/VirtualSMC
+++ src/VirtualSMC
@@ -1 +1 @@
-Subproject commit 2a7455daf65c356c867a1d65b8f2520ae575ee3e
+Subproject commit 30a3fa2bd920a15e41ef1439585bcc19885b89e3
--- src/WhateverGreen
+++ src/WhateverGreen
@@ -1 +1 @@
-Subproject commit 1daa2563b5e6e40f195aba5dc006e14c1d55dfd6
+Subproject commit 79efd986ac5f4f17e09b880f25ea45be64863b2f
```

Delete lines 641 - 675 in both `config-custom.plist` and `config-nopicker-custom.plist` which is `_cpu_topology_sort`.

Add 

```diff
+               <key>ForceDisplayRotationInEFI</key>
+               <integer>0</integer>
```


-----------------

2021-05-04 - On May 4th 2021 we updated from v11 to v12 via [@thenickdude](https://github.com/thenickdude)'s upstream `config.plist` files from [KVM-Opencore](https://github.com/thenickdude/KVM-Opencore).

As seen in a PR to OSX-KVM upstream: [https://github.com/kholia/OSX-KVM/pull/173](https://github.com/kholia/OSX-KVM/pull/173)

```bash
wget https://github.com/thenickdude/KVM-Opencore/compare/v11...v12.patch

patch -F 10 -p1 --verbose config-nopicker-custom.plist v11...v12.patch

patch -F 10 -p1 --verbose config-custom.plist v11...v12.patch
```

Rejected patch lines:
```patch
--- EFI/OC/config.plist
+++ EFI/OC/config.plist
@@ -224,17 +344,17 @@
            </dict>
            <dict>
                <key>Base</key>
-               <string></string>
+               <string>\_SB.PCI0.LPCB.HPET</string>
                <key>BaseSkip</key>
                <integer>0</integer>
                <key>Comment</key>
-               <string>_Q12 to XQ12</string>
+               <string>HPET _CRS to XCRS</string>
                <key>Count</key>
                <integer>1</integer>
                <key>Enabled</key>
                <false/>
                <key>Find</key>
-               <data>X1ExMg==</data>
+               <data>X0NSUw==</data>
                <key>Limit</key>
                <integer>0</integer>
                <key>Mask</key>
@@ -1056,9 +1302,9 @@
            <key>AppleEvent</key>
            <string>Builtin</string>
            <key>CustomDelays</key>
-           <string>Auto</string>
+           <false/>
            <key>KeyInitialDelay</key>
-           <integer>0</integer>
+           <integer>50</integer>
            <key>KeySubsequentDelay</key>
            <integer>5</integer>
            <key>PointerSpeedDiv</key>
--- src/OpenCorePkg
+++ src/OpenCorePkg
@@ -1 +1 @@
-Subproject commit 5cd223f03dd555c2ad0c6f45181808a5105bb605
+Subproject commit 5668fb62b50e8141d93ae6fce3e3fe238822f6ef
```



Replaced
```xml
                <key>Comment</key>
                <string>_Q12 to XQ12</string>

```
with
```xml
                <key>Base</key>
                <string>\_SB.PCI0.LPCB.HPET</string>
                <key>BaseSkip</key>
                <integer>0</integer>
                <key>Comment</key>
                <string>HPET _CRS to XCRS</string>
```

and
```diff
-               <data>X1ExMg==</data>
+               <data>X0NSUw==</data>
```


Ignored:
```diff
@@ -1056,9 +1302,9 @@
            <key>AppleEvent</key>
            <string>Builtin</string>
            <key>CustomDelays</key>
-           <string>Auto</string>
+           <false/>
            <key>KeyInitialDelay</key>
-           <integer>0</integer>
+           <integer>50</integer>
            <key>KeySubsequentDelay</key>
            <integer>5</integer>
            <key>PointerSpeedDiv</key>
```

-----------------
