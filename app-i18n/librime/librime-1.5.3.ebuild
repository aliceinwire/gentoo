# Copyright 2012-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/rime/librime"
	EGIT_SUBMODULES=()
fi

DESCRIPTION="RIME (Rime Input Method Engine) core library"
HOMEPAGE="https://rime.im/ https://github.com/rime/librime"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/rime/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

BDEPEND=""
RDEPEND="app-i18n/opencc:0=
	dev-cpp/glog:0=
	dev-cpp/yaml-cpp:0=
	dev-libs/boost:0=[threads]
	dev-libs/leveldb:0=
	dev-libs/marisa:0="
DEPEND="${RDEPEND}
	dev-libs/darts
	dev-libs/utfcpp
	x11-base/xorg-proto
	test? ( dev-cpp/gtest )"

DOCS=(CHANGELOG.md README.md)

src_prepare() {
	# Use headers of dev-libs/darts, dev-libs/utfcpp and x11-base/xorg-proto.
	sed -e "/\${PROJECT_SOURCE_DIR}\/thirdparty/d" -i CMakeLists.txt || die
	rm -r thirdparty || die

	cmake-utils_src_prepare
}

src_configure() {
	local -x CXXFLAGS="${CXXFLAGS} -I/usr/include/utf8cpp"

	local mycmakeargs=(
		-DBOOST_USE_CXX11=ON
		-DBUILD_TEST=$(usex test ON OFF)
		-DCMAKE_DISABLE_FIND_PACKAGE_Gflags=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Iconv=ON
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
	)

	cmake-utils_src_configure
}
