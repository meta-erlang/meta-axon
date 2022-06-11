require recipes-core/images/core-image-minimal.bb

DESCRIPTION = "A small image just capable of allowing a device to boot and \
run Erlang/Elixir."

IMAGE_INSTALL += "\
    erlang \
    erlang-tools \
    elixir \
    "
