SUMMARY = "A small image just capable of allowing a device to boot with Axon demo Erlang."

IMAGE_INSTALL = "\
    packagegroup-erlang-embedded-initscripts \
    axon \
    "

IMAGE_LINGUAS = " "
USE_NLS="no"

LICENSE = "MIT"

inherit core-image

IMAGE_ROOTFS_SIZE ?= "8192"

