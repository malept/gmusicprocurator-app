DISTDIR ?= dist
APP_NAME = $(shell python -c 'import json; print(json.load(open("package.json"))["productName"])')
APP_UNIX_NAME = $(shell python -c 'import json; print(json.load(open("package.json"))["name"])')
APP_LICENSE = $(shell python -c 'import json; print(json.load(open("package.json"))["license"])')
APP_AUTHOR = $(shell python -c 'import json; print(json.load(open("package.json"))["author"])')
APP_DESC = $(shell python -c 'import json; print(json.load(open("package.json"))["description"])')
APP_URL = $(shell python -c 'import json; print(json.load(open("package.json"))["homepage"])')
APP_VERSION = $(shell python -c 'import json; print(json.load(open("package.json"))["version"])')
BUILD_VERSION = $(APP_VERSION).$(shell date --date=@`git show --format='format:%at' -q` +%Y%m%d%H%M%S).$(shell git rev-parse HEAD | cut -c-8)
NMOD_BIN = $(shell npm bin)

ELECTRON_PACKAGER = $(NMOD_BIN)/electron-packager . \
	--ignore '\b(electron-builder\.json|Gemfile.*|Makefile|\.travis.yml|$(DISTDIR)|ci|pkg)(/|$$)' \
	--app-version=$(APP_VERSION) \
	--build-version=$(BUILD_VERSION) \
	--prune
ELECTRON_BUILDER = $(NMOD_BIN)/electron-builder --config=electron-builder.json
GENISOIMAGE ?= genisoimage
DMG ?= dmg
FPM = bundle exec fpm \
	-s dir \
	--name $(APP_UNIX_NAME) \
	--version $(APP_VERSION) \
	--description "$(APP_DESC)" \
	--license $(APP_LICENSE) \
	--url $(APP_URL) \
	--maintainer "$(APP_AUTHOR)" \
	--package $@ \
	-C $<
FPM_FILES = .=/opt/$(APP_UNIX_NAME) \
	../../../pkg/gmusicprocurator.desktop=/usr/share/applications/ \
	../../../$(APP_ICON_FILE)=/usr/share/icons/hicolor/48x48/apps/gmusicprocurator.png \
	../../../src/icon-16.png=/usr/share/icons/hicolor/16x16/apps/gmusicprocurator.png \
	../../../src/icon.svg=/usr/share/icons/hicolor/scalable/apps/gmusicprocurator.svg
FPM_DEB = $(FPM) -t deb \
	--depends libgpg-error0 \
	--depends libgtk2.0-0 \
	--depends libgconf2-4 \
	--depends libnss3 \
	--depends libnotify4 \
	--depends libdbus-1-3 \
	--depends libasound2 \
	--depends libcups2
FPM_RPM = $(FPM) -t rpm \
	--rpm-os linux
FPM_TAR = $(FPM) -t tar

DISTDIR_LINUX = $(DISTDIR)/linux
DISTDIR_OSX = $(DISTDIR)/osx
DISTDIR_WIN = $(DISTDIR)/win
PKG_LINUX_IA32 = $(DISTDIR_LINUX)/$(APP_NAME)-linux-ia32
PKG_LINUX_X64 = $(DISTDIR_LINUX)/$(APP_NAME)-linux-x64
PKG_OSX = $(DISTDIR_OSX)/$(APP_NAME)-darwin-x64
PKG_WIN_IA32 = $(DISTDIR_WIN)/$(APP_NAME)-win32-ia32
PKG_WIN_X64 = $(DISTDIR_WIN)/$(APP_NAME)-win32-x64
LINUX_DEB_IA32 = $(DISTDIR_LINUX)/$(APP_UNIX_NAME)_$(APP_VERSION)_i386.deb
LINUX_DEB_X64 = $(DISTDIR_LINUX)/$(APP_UNIX_NAME)_$(APP_VERSION)_amd64.deb
LINUX_RPM_IA32 = $(DISTDIR_LINUX)/$(APP_UNIX_NAME)-$(APP_VERSION)-1.i686.rpm
LINUX_RPM_X64 = $(DISTDIR_LINUX)/$(APP_UNIX_NAME)-$(APP_VERSION)-1.x86_64.rpm
LINUX_TAR_IA32 = $(DISTDIR_LINUX)/$(APP_NAME)-$(APP_VERSION)-i686-bin.tar.xz
LINUX_TAR_X64 = $(DISTDIR_LINUX)/$(APP_NAME)-$(APP_VERSION)-amd64-bin.tar.xz
OSX_UNCOMPRESSED_DMG = $(DISTDIR_OSX)/$(APP_NAME)-$(APP_VERSION)-uncompressed.dmg
OSX_DMG = $(DISTDIR_OSX)/$(APP_NAME)-$(APP_VERSION).dmg
WIN_EXE_IA32 = $(DISTDIR_WIN)/ia32/$(APP_NAME)\ Setup.exe
WIN_EXE_X64 = $(DISTDIR_WIN)/x64/$(APP_NAME)\ Setup.exe
ICNS_FILE = src/icon.icns
ICO_FILE = src/icon.ico
INSTALLER_ICO_FILE = src/installer.ico
PNG_SIZES = 512 256 128 48 32
GENERATED_PNG_FILES = $(foreach size,$(PNG_SIZES),src/icon-$(size).png)
PNG_FILES = $(GENERATED_PNG_FILES) src/icon-16.png
INSTALLER_PNG_SIZES = 256 128 48 32 16
INSTALLER_PNG_FILES = $(foreach size,$(INSTALLER_PNG_SIZES),src/icon-$(size).png)
APP_ICON_FILE = src/icon-48.png
JS_FILES = $(patsubst %.coffee,%.js,$(shell ls src/*.coffee))

all: test installer

test:
	$(NMOD_BIN)/coffeelint src

clean: clean-installer clean-dist clean-coffee clean-icns clean-ico clean-png

clean-coffee:
	rm -f $(JS_FILES)

clean-dist:
	rm -rf $(DISTDIR)

clean-icns:
	rm -f $(ICNS_FILE)

clean-ico:
	rm -f $(ICO_FILE) $(INSTALLER_ICO_FILE)

clean-png:
	rm -f $(GENERATED_PNG_FILES)

clean-installer: clean-installer-linux clean-installer-osx clean-installer-windows

clean-installer-linux:
	rm -f $(LINUX_DEB_IA32) $(LINUX_DEB_X64) $(LINUX_RPM_IA32) $(LINUX_RPM_X64) $(LINUX_TAR_IA32) $(LINUX_TAR_X64)

clean-installer-osx:
	rm -f $(OSX_UNCOMPRESSED_DMG) $(OSX_DMG)

clean-installer-windows:
	rm -f $(WIN_EXE_IA32) $(WIN_EXE_X64)

run: test $(JS_FILES) $(APP_ICON_FILE) $(ICNS_FILE) $(ICO_FILE)
	$(NMOD_BIN)/electron .

dist: dist-linux-x64 dist-linux-ia32 dist-osx dist-windows-x64 dist-windows-ia32

installer: installer-linux-ia32 installer-linux-x64 installer-osx installer-windows-ia32 installer-windows-x64

dist-linux-ia32: $(PKG_LINUX_IA32)

$(PKG_LINUX_IA32): $(JS_FILES) $(APP_ICON_FILE)
	$(ELECTRON_PACKAGER) --out $(DISTDIR_LINUX) --platform linux --arch ia32

dist-linux-x64: $(PKG_LINUX_X64)

$(PKG_LINUX_X64): $(JS_FILES) $(APP_ICON_FILE)
	$(ELECTRON_PACKAGER) --out $(DISTDIR_LINUX) --platform linux --arch x64

dist-osx: $(PKG_OSX)

$(PKG_OSX): $(JS_FILES) $(ICNS_FILE)
	$(ELECTRON_PACKAGER) --out $(DISTDIR_OSX) --platform darwin --arch x64 --icon $(ICNS_FILE)

dist-windows-ia32: $(PKG_WIN_IA32)

$(PKG_WIN_IA32): $(JS_FILES) $(ICO_FILE)
	$(ELECTRON_PACKAGER) --out $(DISTDIR_WIN) --platform win32 --arch ia32 --icon $(ICO_FILE)

dist-windows-x64: $(PKG_WIN_X64)

$(PKG_WIN_X64): $(JS_FILES) $(ICO_FILE)
	$(ELECTRON_PACKAGER) --out $(DISTDIR_WIN) --platform win32 --arch x64 --icon $(ICO_FILE)

installer-linux-ia32: $(LINUX_DEB_IA32) $(LINUX_RPM_IA32) $(LINUX_TAR_IA32)

$(LINUX_DEB_IA32): $(PKG_LINUX_IA32)
	$(FPM_DEB) -a i386 $(FPM_FILES)

$(LINUX_RPM_IA32): $(PKG_LINUX_IA32)
	$(FPM_RPM) -a i686 $(FPM_FILES)

$(LINUX_TAR_IA32): $(PKG_LINUX_IA32)
	$(FPM_TAR) $(FPM_FILES)

installer-linux-x64: $(LINUX_DEB_X64) $(LINUX_RPM_X64) $(LINUX_TAR_X64)

$(LINUX_DEB_X64): $(PKG_LINUX_X64)
	$(FPM_DEB) -a amd64 $(FPM_FILES)

$(LINUX_RPM_X64): $(PKG_LINUX_X64)
	$(FPM_RPM) -a x86_64 $(FPM_FILES)

$(LINUX_TAR_X64): $(PKG_LINUX_X64)
	$(FPM_TAR) $(FPM_FILES)

installer-osx: $(OSX_DMG)

$(OSX_UNCOMPRESSED_DMG): $(PKG_OSX)
	$(GENISOIMAGE) -V "$(APP_NAME) $(APP_VERSION)" -D -no-pad -r -apple -o $@ $<

$(OSX_DMG): $(OSX_UNCOMPRESSED_DMG)
	$(DMG) dmg $< $@

installer-windows-ia32: $(WIN_EXE_IA32)
	
$(WIN_EXE_IA32): dist-windows-ia32 $(INSTALLER_ICO_FILE)
	$(ELECTRON_BUILDER) $(PKG_WIN_IA32) --platform=win --out=$(DISTDIR_WIN)/ia32

installer-windows-x64: $(WIN_EXE_X64)

$(WIN_EXE_X64): $(PKG_WIN_X64) $(INSTALLER_ICO_FILE)
	$(ELECTRON_BUILDER) $(PKG_WIN_X64) --platform=win --out=$(DISTDIR_WIN)/x64

%.js %.js.map: %.coffee
	$(NMOD_BIN)/coffee -c -m $<

src/icon-%.png: src/icon.svg
	rsvg-convert -a -w $(shell echo $@ | cut -d- -f2 | cut -d. -f1) -o $@ $<

$(ICO_FILE): $(PNG_FILES)
	icotool -c -o $@ $+

# Separate ICO file needed because NSIS doesn't like > 1MB icons
# See: https://github.com/kichik/nsis/blame/dedab20/Source/icon.cpp#L128-L133
$(INSTALLER_ICO_FILE): $(INSTALLER_PNG_FILES)
	icotool -c -o $@ $+

%.icns: $(PNG_FILES)
	if test "$(shell uname -s)" = "Darwin"; then \
		makeicns $(foreach size,$(PNG_SIZES),-$(size) src/icon-$(size).png ) -out $@; \
	else \
		png2icns $@ $+; \
	fi

.PHONY: clean clean-coffee clean-dist clean-icns clean-ico clean-png clean-installer clean-installer-linux clean-installer-osx clean-installer-windows run dist dist-linux-ia32 dist-linux-x64 dist-osx dist-windows-ia32 dist-windows-x64 installer installer-linux-ia32 installer-linux-x64 installer-osx installer-windows-ia32 installer-windows-x64 test
