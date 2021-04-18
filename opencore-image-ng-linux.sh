#!/bin/bash
# Edits:        sickcodes
# License:      GPLv3+
# Repo:         https://github.com/sickcodes/osx-serial-generator

# Previous authors:
# https://github.com/kraxel/imagefish
# https://github.com/kholia/OSX-KVM

# ######################################################################
# # create work dir

ROOT_DIR=./.fish
mkdir -p "${ROOT_DIR}"
cd "${ROOT_DIR}" || exit 1
# export full path
export ROOT_DIR="${PWD}"

echo_bold() {
    local txt="$1"
    local bold="\x1b[1m"
    local normal="\x1b[0m"
    echo -e "${bold}### ${txt}${normal}"
}

function do_cleanup() {
    echo_bold "cleaning up ..."
    if test "$GUESTFISH_PID" != ""; then
        guestfish --remote -- exit >/dev/null 2>&1 || true
    fi
    sudo rm -rf "$WORK"
}

WORK="${ROOT_DIR}"
trap 'do_cleanup' EXIT

BASE="${PWD}"

######################################################################
# parse args

function print_help() {
    cat <<EOF
usage: $0 [ options ]
options:
    --img, --image <disk-image>
    --cfg, --config, -c <config.plist>
EOF
}

# gather arguments
while (( "$#" )); do
    case "${1}"  in

    --help | -h | h | help ) 
                print_help && exit 0
            ;;

    --img=* | --image=* )
                export IMAGE="${1#*=}"
                shift
            ;;

    --img* | --image*) 
                export IMAGE="${2}"
                shift
                shift
            ;;

    --cfg=* | --config=* | -c=* )
                export CONFIG="${1#*=}"
                shift
            ;;

    --cfg* | --config* | -c* )
                export CONFIG="${2}"
                shift
                shift
            ;;
    *)
            echo "Invalid option: ${1}"
            exit 1
            ;;
    esac
done


######################################################################
# guestfish script helpers

fish() {
    echo "#" "$@"
    guestfish --remote -- "$@" || exit 1
}

fish_init() {
    # local format

    case "$(file --brief "${IMAGE}")" in
        QEMU\ QCOW2\ Image* )   export FORMAT=qcow2
            ;;
        DOS\/MBR* )             export FORMAT=raw
            ;;
        * )                     export FORMAT=
                                echo "IMAGE file: ${IMAGE} is neither qcow2 nor raw."
            ;;
    esac

    echo_bold "Creating and adding disk image..."
    fish disk-create "${IMAGE}" "${FORMAT}" 384M
    fish add "${IMAGE}"
    fish run
}


# disabled by @sickcodes to allow unattended image overwrites
######################################################################
# sanity checks

# if test ! -f "${CONFIG}"; then
#     echo "ERROR: cfg not found: ${CONFIG}""
#     exit 1
# fi
# if test -f "${IMAGE}"; then
#     if test "$allow_override" = "yes"; then
#         rm -f "${IMAGE}"
#     else
#         echo "ERROR: image exists: ${IMAGE}
#         exit 1
#     fi
# fi

######################################################################
# go!

echo "Copying files from local folder..."
# BASE="$(dirname $0)"
cp -a "${BASE}/EFI" "${WORK}"
# find "${WORK}"

#echo_bold "[debug] list drivers in EFI/OC"
#(cd $WORK/EFI/OC; find driver* -print)


export LIBGUESTFS_BACKEND=direct
unset GUESTFISH_PID
source <(guestfish --listen || exit 1)

if [[ -z "${GUESTFISH_PID}" ]]; then
    echo "ERROR: starting guestfish failed. Install libguestfs-tools"
    exit 1
fi

fish_init

echo_bold "Partitioning disk image"
fish part-init          /dev/sda gpt
fish part-add           /dev/sda p 2048 300000
fish part-add           /dev/sda p 302048 -2048
# fish part-set-gpt-type  /dev/sda 1 C12A7328-F81F-11D2-BA4B-00A0C93EC93B
fish part-set-gpt-type  /dev/sda 1 "$(uuidgen)"
fish part-set-bootable  /dev/sda 1 true
fish mkfs vfat          /dev/sda1 label:EFI
fish mkfs vfat          /dev/sda2 label:OpenCore
fish mount              /dev/sda2 /
fish mkdir              /ESP
fish mount              /dev/sda1 /ESP

echo_bold "copy files to disk image"
cp -v "${CONFIG}" "${WORK}/config.plist"
fish mkdir /ESP/EFI
fish mkdir /ESP/EFI/OC
fish mkdir /ESP/EFI/OC/Kexts
fish mkdir /ESP/EFI/OC/ACPI
fish mkdir /ESP/EFI/OC/Resources
fish mkdir /ESP/EFI/OC/Tools
fish copy-in "${WORK}/EFI/BOOT"                 /ESP/EFI
fish copy-in "${WORK}/EFI/OC/OpenCore.efi"      /ESP/EFI/OC
fish copy-in "${WORK}/EFI/OC/Drivers"           /ESP/EFI/OC/
fish copy-in "${WORK}/EFI/OC/Kexts"             /ESP/EFI/OC/
fish copy-in "${WORK}/EFI/OC/ACPI"              /ESP/EFI/OC/
fish copy-in "${WORK}/EFI/OC/Resources"         /ESP/EFI/OC/
fish copy-in "${WORK}/EFI/OC/Tools"             /ESP/EFI/OC/

# Note
fish copy-in startup.nsh /

BASE="$(dirname "$0")"
fish copy-in "${WORK}/config.plist"               /ESP/EFI/OC/

fish find /ESP

fish umount-all
