DISTDIR ?= dist
APP_NAME = GMusicProcurator
APP_VERSION = $(shell python -c 'import json; print(json.load(open("package.json"))["version"])')
BUILD_VERSION = $(APP_VERSION).$(shell date --date=@`git show --format='format:%at' -q` +%Y%m%d%H%M%S).$(shell git rev-parse HEAD | cut -c-8)
ELECTRON_PACKAGER = $(NMOD_BIN)/electron-packager . --ignore '$(DISTDIR)/' --app-version=$(APP_VERSION) --build-version=$(BUILD_VERSION) --prune
ELECTRON_BUILDER = $(NMOD_BIN)/electron-builder --config=electron-builder.json
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
NMOD_BIN = node_modules/.bin

all: test dist installer

test:
	$(NMOD_BIN)/coffeelint src

clean: clean-dist clean-coffee clean-icns clean-ico clean-png

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

run: test $(JS_FILES) $(APP_ICON_FILE) $(ICNS_FILE) $(ICO_FILE)
	$(NMOD_BIN)/electron .

dist: dist-linux-x64 dist-linux-ia32 dist-osx dist-windows-x64 dist-windows-ia32

installer: installer-windows-ia32 installer-windows-x64

dist-linux-ia32: $(JS_FILES) $(APP_ICON_FILE)
	$(ELECTRON_PACKAGER) --out $(DISTDIR)/linux/ia32 --platform linux --arch ia32

dist-linux-x64: $(JS_FILES) $(APP_ICON_FILE)
	$(ELECTRON_PACKAGER) --out $(DISTDIR)/linux/x64 --platform linux --arch x64

dist-osx: $(JS_FILES) $(ICNS_FILE)
	$(ELECTRON_PACKAGER) --out $(DISTDIR)/osx --platform darwin --arch x64 --icon $(ICNS_FILE)

dist-windows-ia32: $(JS_FILES) $(ICO_FILE)
	$(ELECTRON_PACKAGER) --out $(DISTDIR)/win/ia32 --platform win32 --arch ia32 --icon $(ICO_FILE)

dist-windows-x64: $(JS_FILES) $(ICO_FILE)
	$(ELECTRON_PACKAGER) --out $(DISTDIR)/win/x64 --platform win32 --arch x64 --icon $(ICO_FILE)

installer-windows-ia32: dist-windows-ia32 $(INSTALLER_ICO_FILE)
	$(ELECTRON_BUILDER) $(DISTDIR)/win/ia32/$(APP_NAME)-win32-ia32 --platform=win --out=$(DISTDIR)/win/ia32

installer-windows-x64: dist-windows-x64 $(INSTALLER_ICO_FILE)
	$(ELECTRON_BUILDER) $(DISTDIR)/win/x64/$(APP_NAME)-win32-x64 --platform=win --out=$(DISTDIR)/win/x64

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

.PHONY: clean clean-coffee clean-dist clean-icns clean-ico clean-png run dist dist-linux-ia32 dist-linux-x64 dist-osx dist-windows-ia32 dist-windows-x64 installer installer-windows-ia32 installer-windows-x64 test
