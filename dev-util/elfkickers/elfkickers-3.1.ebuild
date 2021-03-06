# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_PN=${PN/elf/ELF}-${PV}
S=${WORKDIR}/${MY_PN}

DESCRIPTION="collection of programs to manipulate ELF files: sstrip, rebind, elfls, elftoc"
HOMEPAGE="http://www.muppetlabs.com/~breadbox/software/elfkickers.html"
SRC_URI="http://www.muppetlabs.com/~breadbox/pub/software/${MY_PN}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~mips ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

DEPEND="app-misc/pax-utils"
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${P}-respect-CFLAGS-LDFLAGS.patch
	"${FILESDIR}"/${P}-create-destdir-path.patch
	"${FILESDIR}"/add-freebsd-elf-defs.patch
)

src_prepare() {
	default
	sed -i -e "s:^prefix = /usr/local:prefix = ${D}:" Makefile \
		|| die "sed failed"
}

src_compile() {
	emake CC=$(tc-getCC) all
}
