
# elixir
PREFERRED_VERSION_elixir = "1.17%"
PREFERRED_VERSION_elixir-native = "1.17%"
PREFERRED_VERSION_nativesdk-elixir = "1.17%"

# erlang
PREFERRED_VERSION_erlang = "27%"
PREFERRED_VERSION_erlang-native = "27%"
PREFERRED_VERSION_nativesdk-erlang = "27%"

NERVES_HUB_LINK = "\
    erlang \
    erlang-modules-dev \
    elixir \
    elixir-modules-dev \
    libubootenv-bin \
    u-boot-env \
    boardid \
    nerves-hub-link \
    "

IMAGE_CLASSES += "image_types_fwup"
IMAGE_FSTYPES = "fwup"

IMAGE_INSTALL:append:pn-core-image-minimal = " ${NERVES_HUB_LINK}"
IMAGE_INSTALL:append:pn-core-image-full-cmdline = " ${NERVES_HUB_LINK}"

#IMAGE_ROOTFS_EXTRA_SPACE:pn-core-image-minimal = "131072"

TMPDIR = "${TOPDIR}/tmp-${MACHINE}-${TCLIBC}-nerves-hub-link"
