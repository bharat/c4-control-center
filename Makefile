
all: lint pack

lint:
	xmllint --noout --quiet driver.xml
	luacheck --formatter=plain driver.lua

update-version:
	perl -pi -e 's|^  <version>\K([^<]*)|$$1+1|e' driver.xml
	perl -pi -e 's|^  <modified>\K([^<]*)|chomp($$v = `date "+%D %r"`); $$v|e' driver.xml

pack:
	rm ~/Documents/Control4/Drivers/control-center.c4z
	zip -r \
		--exclude=.git/\* \
		--exclude=.gitignore \
		--exclude=.luacheckrc \
		--exclude=*~ \
		--exclude=Makefile \
		--exclude=.DS_Store \
		--exclude=\*\*/.DS_Store \
		~/Documents/Control4/Drivers/control-center.c4z .

images:
	inkscape -w 180 -h 180 assets/Alert.svg -o www/Alert_180.png
	inkscape -w 180 -h 180 assets/Check.svg -o www/Check_180.png
	inkscape -w 180 -h 180 assets/Refresh.svg -o www/Refresh_180.png
