# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2


EAPI=8

inherit desktop wrapper

MY_PV="${PN}-${PV}"
DESCRIPTION="Visual Studio Code (VS Code) is a free, open-source, cross-platform source code editor by Microsoft."

HOMEPAGE="https://code.visualstudio.com"
LICENSE="MS-vscode"
SRC_URI="https://update.code.visualstudio.com/${PV}/linux-x64/stable -> ${PF}.tar.gz"
IUSE="+nss cups"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror"

DEPEND="
	media-libs/libpng
	x11-libs/gtk+:3
	x11-libs/cairo
	x11-libs/libXtst
	!app-editors/vscode
"

RDEPEND="
	${DEPEND}
	cups? ( net-print/cups )
	x11-libs/libnotify
	x11-libs/libXScrnSaver
	nss? ( dev-libs/nss )
	app-crypt/libsecret[crypt]
"
S="${WORKDIR}/VSCode-linux-x64"

QA_PRESTRIPPED="opt/${PN}/code"
QA_PREBUILT="opt/${PN}/code"
QA_FLAGS_IGNORED="CFLAGS LDFLAGS"

src_configure(){ :; }
src_compile(){ :; }

src_install()
{
	local dir="/opt/${PN}"

	insinto "${dir}"
	doins -r *

	find "${S}" -type f -executable | while read -r f; do
        local rel="${f#${S}/}"
        fperms 755 "${dir}/${rel}"
    done

	fperms 755 "${dir}/bin/code"
	fperms 755 "${dir}/code"
	fperms 755 "${dir}/chrome-sandbox"
	fperms 755 "${dir}/chrome_crashpad_handler"

	make_wrapper "${PN}" "${dir}/bin/code"
	newicon "resources/app/resources/linux/code.png" "${PN}.png"
	make_desktop_entry "${PN}" "Visual Studio Code" "${PN}" "Development;IDE"
}


pkg_postinst(){
	elog "You may install some additional utils, so check them in:"
	elog "https://code.visualstudio.com/Docs/setup#_additional-tools"
}
