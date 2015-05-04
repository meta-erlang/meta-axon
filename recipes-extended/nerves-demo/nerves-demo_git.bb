SUMMARY = "Simple application for demonstrating release creation for embedded devices"
DESCRIPTION = "This application provides a web interface for controlling LEDs on the Beaglebone. In the process, it demonstrates using rebar and relx for building an Erlang release in a cross-compiled environment. It then constructs a firmware image that can be burned to an SDCard and run on the Beaglebone."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=4d27ce817c4e18e66ec69e8a7e05582c"

S = "${WORKDIR}/git"
SRCREV = "3d667d12ab5ef16d527493c3c88b6facd6605e72"
PV = "0.01-git${SRCPV}"
PR = "r0"

SRC_URI = "\
    git://github.com/nerves-project/nerves-demo;branch=master \
    file://relhelper_destdir.diff \
    "

inherit rebar

DEPENDS += "relx-native relsync-native"

RDEPENDS_${PN} += "libcrypto"

EXTRA_OEMAKE = "all"

do_install () {
	install -d ${D}${servicedir}/erlang

	relx --system_libs ${STAGING_LIBDIR}/erlang/lib -o ${D}${servicedir}/erlang

	rm -rf ${D}${servicedir}/erlang/nervesdemo/lib/*/priv/obj
}

FILES_${PN} += "${servicedir}/erlang"
FILES_${PN}-dbg += "${servicedir}/erlang/nervesdemo/lib/*/priv/lib/.debug"

