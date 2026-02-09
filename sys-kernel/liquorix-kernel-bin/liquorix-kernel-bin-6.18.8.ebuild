# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

K_VER="6.18-9.1"
K_REL="1"

MY_PV="${PV}-${K_REL}-liquorix-amd64"
DESCRIPTION="Liquorix is an enthusiast Linux kernel designed for uncompromised responsiveness in interactive systems, enabling low latency compute in A/V production, and reduced frame time deviations in games."
HOMEPAGE="
	https://liquorix.net/
"
LICENSE="GPL-2"
KEYWORDS="-* ~amd64"
SLOT="0"

IUSE="+dracut"

SRC_URI="https://liquorix.net/debian/pool/main/l/linux-liquorix/linux-image-${MY_PV}_${K_VER}~trixie_amd64.deb"

RESTRICT="mirror strip"

RDEPEND="
	!sys-kernel/liquorix-kernel:${SLOT}
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
		einfo "Generating modules.dep for kernel"
		if depmod -a "${MY_PV}"; then
			einfo "modules.dep successfully generated! on ${D}/lib/modules/${MY_PV}"
		else
			die "Failed to generate modules.dep for kernel: ${MY_PV}"
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
