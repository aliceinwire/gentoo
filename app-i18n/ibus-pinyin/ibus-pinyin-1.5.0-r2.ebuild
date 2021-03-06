# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit autotools python-single-r1

DESCRIPTION="Chinese Pinyin and Bopomofo engines for IBus"
HOMEPAGE="https://github.com/ibus/ibus/wiki"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/ibus/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="boost lua nls"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	app-i18n/ibus[python(+),${PYTHON_USEDEP}]
	app-i18n/pyzy
	dev-db/sqlite:3
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	boost? ( dev-libs/boost )
	lua? ( =dev-lang/lua-5.1*:= )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/autoconf-archive
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-boost.patch
	"${FILESDIR}"/${P}-content-type-method.patch
)

src_prepare() {
	sed -i "s/python/${EPYTHON}/" setup/${PN/-/-setup-}.in

	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable boost) \
		$(use_enable lua lua-extension) \
		$(use_enable nls)
}
