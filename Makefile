DISTDIR ?= dist
ELECTRON_VERSION = $(shell npm list --parseable --long electron-prebuilt | cut -d: -f 2 | cut -d@ -f2 | cut -d- -f1)
ELECTRON_PACKAGER = $(NMOD_BIN)/electron-packager . GMusicProcurator --version $(ELECTRON_VERSION) --ignore '\.git'
ICNS_FILE = src/icon.icns
PNG_SIZES = 1024 512 256 128 48 32
GENERATED_PNG_FILES = $(foreach size,$(PNG_SIZES),src/icon-$(size).png)
PNG_FILES = $(GENERATED_PNG_FILES) src/icon-16.png
APP_ICON_FILE = src/icon-48.png
JS_FILES = $(patsubst %.coffee,%.js,$(shell ls src/*.coffee))
NMOD_BIN = node_modules/.bin

all: test dist

test:
	$(NMOD_BIN)/coffeelint src

# Because Travis can't install icnsutils/icoutils in container mode yet
travis: test dist-linux-x64 dist-linux-ia32

clean: clean-dist clean-coffee clean-icns clean-png

clean-coffee:
	rm -f $(JS_FILES)

clean-dist:
	rm -rf $(DISTDIR)

clean-icns:
	rm -f $(ICNS_FILE)

clean-png:
	rm -f $(GENERATED_PNG_FILES)

dist: dist-linux-x64 dist-linux-ia32 dist-osx dist-windows-x64 dist-windows-ia32

dist-linux-ia32: $(JS_FILES) $(APP_ICON_FILE)
	$(ELECTRON_PACKAGER) --out $(DISTDIR)/linux/ia32 --platform linux --arch ia32

dist-linux-x64: $(JS_FILES) $(APP_ICON_FILE)
	$(ELECTRON_PACKAGER) --out $(DISTDIR)/linux/x64 --platform linux --arch x64

dist-osx: $(JS_FILES) $(ICNS_FILE)
	$(ELECTRON_PACKAGER) --out $(DISTDIR)/osx --platform darwin --arch x64 --icon $(ICNS_FILE)

dist-windows-ia32: $(JS_FILES) $(APP_ICON_FILE)
	$(ELECTRON_PACKAGER) --out $(DISTDIR)/win/ia32 --platform win32 --arch ia32 --icon $(APP_ICON_FILE)

dist-windows-x64: $(JS_FILES) $(APP_ICON_FILE)
	$(ELECTRON_PACKAGER) --out $(DISTDIR)/win/x64 --platform win32 --arch x64 --icon $(APP_ICON_FILE)

%.js %.js.map: %.coffee
	$(NMOD_BIN)/coffee -c -m $<

src/icon-%.png: src/icon.svg
	rsvg-convert -a -w $(shell echo $@ | cut -d- -f2 | cut -d. -f1) -o $@ $<

%.icns: $(PNG_FILES)
	if test "$(shell uname -s)" = "Darwin"; then \
		makeicns $(foreach size,$(PNG_SIZES),-$(size) src/icon-$(size).png ) -out $@; \
	else \
		png2icns $@ $+; \
	fi

.PHONY: clean clean-coffee clean-dist clean-icns clean-png dist dist-linux-ia32 dist-linux-x64 dist-osx dist-windows-ia32 dist-windows-x64
