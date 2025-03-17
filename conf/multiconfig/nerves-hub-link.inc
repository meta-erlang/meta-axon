
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
    nerves-hub-link \
    fwup-fw-env \
    \
    connman \
    connman-client \
    "

IMAGE_CLASSES += "image_types_fwup"
IMAGE_FSTYPES = "fwup fwup.bmap"

IMAGE_INSTALL:append = " ${NERVES_HUB_LINK} util-linux"

IMAGE_FEATURES:append = " ssh-server-openssh"

#IMAGE_ROOTFS_EXTRA_SPACE:pn-core-image-minimal = "131072"

TMPDIR = "${TOPDIR}/tmp-${MACHINE}-${TCLIBC}-nerves-hub-link"