SUMMARY = "Simple application for demonstrating release creation for embedded devices"
DESCRIPTION = "This application provides a web interface for controlling LEDs on the Beaglebone. In the process, it demonstrates using rebar and relx for building an Erlang release in a cross-compiled environment. It then constructs a firmware image that can be burned to an SDCard and run on the Beaglebone."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=64dcdcb7810c9caa926e75c6dfc82385"

S = "${WORKDIR}/git"
SRCREV = "3baebb418f6024aeb221b79fd65f820f8968dd8e"
PV = "0.1.0-git${SRCPV}"
PR = "r0"

SRC_URI = "\
    git://github.com/joaohf/axon;branch=master;protocol=https \
    "

inherit rebar3

REBAR3_PROFILE = "prod"
