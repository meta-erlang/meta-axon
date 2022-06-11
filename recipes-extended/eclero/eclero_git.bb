SUMMARY = "Simple erlang application to answer cluster health checks"
DESCRIPTION = ""
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=62612d1c0b9e46d8296dd0097c07db91"

S = "${WORKDIR}/git"
SRCREV = "0512ba7f71d09a88db5cb38f0ff726dfbf4f20ab"
PV = "0.1.0-git${SRCPV}"
PR = "r0"

SRC_URI = "\
    git://github.com/joaohf/eclero;branch=master;protocol=https \
    "

inherit rebar3

REBAR3_PROFILE = "prod"
