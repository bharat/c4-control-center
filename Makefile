
all: lint pack

lint:
	xmllint --noout --quiet driver.xml
	luacheck --formatter=plain driver.lua

pack:
	zip -r \
		--exclude=.git/\* \
		--exclude=.luacheckrc \
		--exclude=*~ \
		--exclude=Makefile \
		--exclude=.DS_Store \
		--exclude=\*\*/.DS_Store \
		~/Documents/Control4/Drivers/control-center.c4z .

