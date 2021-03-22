# OSX Serial Generator

![Running mac osx in a docker container](/running-mac-inside-docker-qemu.png?raw=true "OSX KVM DOCKER")

Generate macOS valid serials, uuids, and board serials for good-faith security research.

This project provides two tools for generating serial numbers for Hackintosh, [OpenCore](https://github.com/acidanthera/OpenCorePkg), [Docker-OSX](https://github.com/sickcodes/Docker-OSX) and [OSX-KVM](https://github.com/kholia/OSX-KVM).

Author: Sick.Codes https://sick.codes/ & https://twitter.com/sickcodes

### Follow @sickcodes on Twitter for updates! [https://twitter.com/sickcodes](https://twitter.com/sickcodes)

Terms & Conditions: Serial numbers are an important part of conducting iMessage security research and finding vulnerabilities in software prior to Bad Actors, therefore, you must agree to [Apple's Security Bounty program](https://developer.apple.com/security-bounty/requirements/).

### Upstream Thanks

This project is a wrapper for the OpenCore bootloader's fantastic tool [macserial](https://github.com/acidanthera/OpenCorePkg/tree/master/Utilities/macserial).

Many thanks to the OpenCore Project for providing `macserial`.

See the project which drives Hackintosh: [https://github.com/acidanthera/OpenCorePkg](https://github.com/acidanthera/OpenCorePkg)


### PR & Contributor Credits

https://github.com/sickcodes/osx-serial-generator/blob/master/CREDITS.md

## Related

- [Docker-OSX](https://github.com/sickcodes/Docker-OSX)
- [OSX-KVM](https://github.com/kholia/OSX-KVM)
- [OpenCore](https://github.com/acidanthera/OpenCorePkg)
- [Hackintosh](https://www.reddit.com/r/hackintosh/)

# Purpose

These script were written by [@sickcodes](https://github.com/sickcodes) [https://twitter.com/sickcodes](https://twitter.com/sickcodes) for automating generating unique values at runtime in [Docker-OSX](https://github.com/sickcodes/Docker-OSX).

This is for generating sets of serial numbers that simply work.

If this is your first time, just run the first command below, without any options, and you will be given 1 complete set.

With your new serial numbers, you can:
- put them in your existing `config.plist` and reboot
- tell the script to make a new `OpenCore.qcow2`
- output as TSV and CSV, and more!

Used at runtime in [Docker-OSX](https://github.com/sickcodes/Docker-OSX).

- [https://github.com/kholia/OSX-KVM](https://github.com/kholia/OSX-KVM): "Run macOS on QEMU/KVM. With OpenCore + Big Sur support now! Only commercial (paid) support is available."

- [https://github.com/sickcodes/Docker-OSX](https://github.com/sickcodes/Docker-OSX): "Run Mac in a Docker! Run near native OSX-KVM in Docker! X11 Forwarding! CI/CD for OS X!"

# Requirements

```bash
# Ubuntu, Debian, Pop
sudo apt update -y
sudo apt install libguestfs-tools build-essential wget git linux-generic sudo -y

# Fedora, RHEL, CentOS
sudo yum install libguestfs libguestfs-tools wget git kernel-devel sudo -y
sudo yum groupinstall 'Development Tools' -y

# Arch, Manjaro
sudo pacman -Sy libguestfs wget git base-devel linux sudo

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
    <key>Resolution</key>
    <string>{{WIDTH}}x{{HEIGHT}}@32</string>
    <key>SanitiseClearScreen</key>
```
```
    {{DEVICE_MODEL}}, {{SERIAL}}, {{BOARD_SERIAL}},
    {{UUID}}, {{ROM}}, {{WIDTH}}, {{HEIGHT}}
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
    {{UUID}}, {{ROM}}, {{WIDTH}}, {{HEIGHT}}

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
    --master-plist-url <url>        Specify an alternative master plist, via URL
    --custom-plist <filename>       
       || --master-plist <filename> Optionally change the input plist.
    --output-bootdisk <filename>    Optionally change the bootdisk filename
    --output-plist <filename>       Optionally change the output plist filename
    --help, -h, help                Display this help and exit

Placeholders:   {{DEVICE_MODEL}}, {{SERIAL}}, {{BOARD_SERIAL}}, {{UUID}},
                {{ROM}}, {{WIDTH}}, {{HEIGHT}}
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
    --height 1080
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
        --output-bootdisk "${BOOTDISK:=/home/arch/OSX-KVM/OpenCore-Catalina/OpenCore.qcow2}" \
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
        --output-bootdisk "${BOOTDISK:=/home/arch/OSX-KVM/OpenCore-Catalina/OpenCore.qcow2}"
```
