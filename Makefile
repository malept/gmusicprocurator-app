DISTDIR ?= dist
ELECTRON_VERSION = $(shell npm list --parseable --long electron-prebuilt | cut -d: -f 2 | cut -d@ -f2 | cut -d- -f1)
ELECTRON_PACKAGER = $(NMOD_BIN)/electron-packager . GMusicProcurator --version $(ELECTRON_VERSION) --ignore '\.git'
ICNS_FILE = src/icon.icns
JS_FILES = $(patsubst %.coffee,%.js,$(shell ls src/*.coffee))
NMOD_BIN = node_modules/.bin

all: dist

clean: clean-dist clean-coffee clean-icns

clean-coffee:
	rm -f $(JS_FILES)

clean-dist:
	rm -rf $(DISTDIR)

clean-icns:
	rm -f $(ICNS_FILE)

dist: dist-linux-x64 dist-linux-ia32 dist-osx dist-windows-x64 dist-windows-ia32

dist-linux-ia32: $(JS_FILES)
	$(ELECTRON_PACKAGER) --out $(DISTDIR)/linux/ia32 --platform linux --arch ia32

dist-linux-x64: $(JS_FILES)
	$(ELECTRON_PACKAGER) --out $(DISTDIR)/linux/x64 --platform linux --arch x64

dist-osx: $(JS_FILES) $(ICNS_FILE)
	$(ELECTRON_PACKAGER) --out $(DISTDIR)/osx --platform darwin --arch x64 --icon $(ICNS_FILE)

dist-windows-ia32: $(JS_FILES)
	$(ELECTRON_PACKAGER) --out $(DISTDIR)/win/ia32 --platform win32 --arch ia32

dist-windows-x64: $(JS_FILES)
	$(ELECTRON_PACKAGER) --out $(DISTDIR)/win/x64 --platform win32 --arch x64

%.js %.js.map: %.coffee
	$(NMOD_BIN)/coffee -c -m $<

%.icns: %.png
	png2icns $@ $<

.PHONY: clean clean-coffee clean-dist clean-icns dist dist-linux-ia32 dist-linux-x64 dist-osx dist-windows-ia32 dist-windows-x64
