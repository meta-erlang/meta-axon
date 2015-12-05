require recipes-core/images/core-image-minimal.bb

DESCRIPTION = "A small image just capable of allowing a device to boot and \
run Axon."

IMAGE_INSTALL += "\
    axon \
    "
