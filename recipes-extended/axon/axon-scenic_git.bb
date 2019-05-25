SUMMARY = "Simple example using scenic"
DESCRIPTION = "Simple elixir project created using scenic_new."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=ca0978e805a8fe57d17049c427422188"

S = "${WORKDIR}/git"
SRCREV = "3baebb418f6024aeb221b79fd65f820f8968dd8e"
PV = "0.1.0-git${SRCPV}"
PR = "r0"

DEPENDS = "glfw glew"
RDEPENDS_${PN} += " glfw glew"

CFLAGS_append = " -fPIC "

SRC_URI = "\
    git://github.com/joaohf/axon-scenic;branch=master \
    "

inherit mix
