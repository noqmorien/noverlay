# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XANMOD_REL_V2="x64v2-xanmod1"
XANMOD_REL_V3="x64v3-xanmod1"

XANMOD_RELD="20260102"
XANMOD_RELF="g6e0b8d1"

MY_PV="${PV}-"
DESCRIPTION="XanMod is a general-purpose Linux kernel distribution with custom settings and new features. Built to provide a stable, smooth and solid system experience."
HOMEPAGE="
	https://xanmod.org/
	https://sourceforge.net/projects/xanmod/
"
LICENSE="GPL-2"
KEYWORDS="-* ~amd64"
SLOT="0"

IUSE="+dracut +x64v3 x64v2"

SRC_URI_X64V2="https://downloads.sourceforge.net/xanmod/releases/main/${PV}-xanmod1/${PV}-${XANMOD_REL_V2}/linux-image-${PV}-${XANMOD_REL_V2}_${PV}-${XANMOD_REL_V2}-0~${XANMOD_RELD}.${XANMOD_RELF}_amd64.deb"
SRC_URI_X64V3="https://downloads.sourceforge.net/xanmod/releases/main/${PV}-xanmod1/${PV}-${XANMOD_REL_V3}/linux-image-${PV}-${XANMOD_REL_V3}_${PV}-${XANMOD_REL_V3}-0~${XANMOD_RELD}.${XANMOD_RELF}_amd64.deb"

SRC_URI="
	x64v2? ( ${SRC_URI_X64V2} )
	x64v3? ( ${SRC_URI_X64V3} )
"

RESTRICT="mirror strip"

RDEPEND="
	!sys-kernel/xanmod-kernel:${SLOT}
	dracut? ( sys-kernel/dracut )
"

S="${WORKDIR}"

src_configure(){ :; }
src_compile(){ :; }


src_install()
{
	unpack ${WORKDIR}/data.tar.xz
	mv "boot" "${D}"
	dodir "lib"
	mv "lib/modules" "${D}/lib/modules"
}

pkg_postinst() {
	if use dracut ; then
		if use x64v2; then
			MY_PV="${MY_PV}${XANMOD_REL_V2}"
		elif use x64v3; then
			MY_PV="${MY_PV}${XANMOD_REL_V3}"
		else
			ewarn "neither x64v2 or x64v3 use flags is not enabled!"
			die
		fi

		einfo "Generating initramfs for kernel: ${MY_PV}"

		if dracut -f --kver "${MY_PV}" ; then
			einfo "Initramfs successfully generated!"
		else
			ewarn "Failed to generate initramfs for kernel: ${MY_PV}"
			die "Failed to generate initramfs for kernel: ${MY_PV}"
		fi
	else
		elog "\nTo make use of this kernel, you need to generate an initramfs."
		elog "It's recommended to use dracut. An example command is:"
		elog "\tdracut --kver ${MY_PV}\n"
	fi

	einfo "If using grub, you will need to make sure you have a"
	einfo "\troot=<device>"
	einfo "listing in your grub configuration. Users of boot-update will need to"
	einfo "configure this correctly in their /etc/boot.conf."
}
