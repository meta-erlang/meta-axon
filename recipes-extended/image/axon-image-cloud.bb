require recipes-core/images/core-image-minimal.bb

DESCRIPTION = "A small image cloud aware capable to boot and \
run Erlang/Elixir."

IMAGE_BUILDINFO_VARS = " \
    BBMULTICONFIG DISTRO DISTRO_VERSION DISTRO_FEATURES IMAGE_FEATURES \
    IMAGE_NAME MACHINE MACHINE_FEATURES DEFAULTTUNE COMBINED_FEATURES "

inherit image-buildinfo extrausers

IMAGE_FEATURES += "ssh-server-openssh"

IMAGE_INSTALL += "\
    cloud-init \
    cloud-init-systemd \
    e2fsprogs \
    e2fsprogs-resize2fs \
    e2fsprogs-tune2fs \
    e2fsprogs-e2fsck \
    e2fsprogs-mke2fs \
    parted \
    sudo \
    sudo-sudo \
    openssh-sftp-server \
    python3-netifaces \
    python3-charset-normalizer \
    canutils \
    erlang \
    erlang-modules \
    elixir \
    "

IMAGE_FSTYPES += " wic wic.vhdx"

# Add user: with admin access
# 'AXON_ADMIN_ACCOUNT'
EXTRA_USERS_PARAMS:prepend = " useradd -p '' ${AXON_ADMIN_ACCOUNT}; \
                               groupadd ${AXON_ADMIN_GROUP}; \
                               usermod -aG ${AXON_ADMIN_GROUP} ${AXON_ADMIN_ACCOUNT}; \
                             "
