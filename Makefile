DISTDIR ?= out
ICNS_FILE = src/icon.icns
ICO_FILE = src/icon.ico
PNG_SIZES = 512 256 128 48 32
GENERATED_PNG_FILES = $(foreach size,$(PNG_SIZES),src/icon-$(size).png)
PNG_FILES = $(GENERATED_PNG_FILES) src/icon-16.png
APP_ICON_FILE = src/icon-48.png
JS_FILES = $(patsubst %.coffee,%.js,$(shell ls src/*.coffee))

all: installer

clean: clean-dist clean-coffee clean-icns clean-ico clean-png

clean-coffee:
	rm -f $(JS_FILES)

clean-dist:
	rm -rf $(DISTDIR)

clean-icns:
	rm -f $(ICNS_FILE)

clean-ico:
	rm -f $(ICO_FILE)

clean-png:
	rm -f $(GENERATED_PNG_FILES)

run: $(APP_ICON_FILE)
	npm start

installer: $(APP_ICON_FILE) $(ICNS_FILE) $(ICO_FILE)
	npm run package

src/icon-%.png: src/icon.svg
	rsvg-convert -a -w $(shell echo $@ | cut -d- -f2 | cut -d. -f1) -o $@ $<

$(ICO_FILE): $(PNG_FILES)
	icotool -c -o $@ $+

%.icns: $(PNG_FILES)
	if test "$(shell uname -s)" = "Darwin"; then \
		makeicns $(foreach size,$(PNG_SIZES),-$(size) src/icon-$(size).png ) -out $@; \
	else \
		png2icns $@ $+; \
	fi

.PHONY: clean clean-coffee clean-dist clean-icns clean-ico clean-png installer run
