require recipes-core/images/core-image-minimal.bb

DESCRIPTION = "A small image just capable of allowing a device to boot and \
run Erlang/Elixir with ssh access."

IMAGE_INSTALL += "\
    axon \
    erlang \
    erlang-tools \
    elixir \
    "

IMAGE_FEATURES += "ssh-server-dropbear"
