VERSION := $(shell cat VERSION)
ARCHIVE := sysz-$(VERSION).tar.gz
.PHONY: install clean release archive deb test lint

sysz: VERSION
	sed -i -e "s/^SYSZ_VERSION=.*/SYSZ_VERSION=$(VERSION)/" sysz

$(ARCHIVE): sysz CHANGELOG.md README.md
	git archive --format=tar.gz -o $(ARCHIVE) --prefix sysz-$(VERSION)/ HEAD

clean:
	/bin/rm -f README.md $(ARCHIVE)
	/bin/rm -rf dist/

README.md: README.sh sysz VERSION
	./README.sh

archive: $(ARCHIVE)

PKGBUILD: VERSION $(ARCHIVE)
	sed -i -e "s/^pkgver=.*/pkgver=$(VERSION)/" PKGBUILD
	sed -i -e "s/^sha256sums=.*/sha256sums=('`sha256sum $(ARCHIVE) | cut -d' ' -f1`')/" PKGBUILD
	makepkg -f

aur-release: PKGBUILD
	git commit -am 'Update PKGBUILD'
	git push origin master
	cp PKGBUILD ~/src/aur/sysz/PKGBUILD
	cd ~/src/aur/sysz/
	makepkg -ci
	git commit -am "Release $(VERSION)"
	git push origin master

github-release: VERSION sysz CHANGELOG.md README.md
	git commit -am 'Release $(VERSION)'
	git tag $(VERSION)
	git push origin $(VERSION)

release: clean sysz README.md github-release

install:
	install -m755 sysz /usr/local/bin/

# Build a Debian package (Depends: bash, fzf)
deb:
	./packaging/build-deb.sh dist

lint:
	shellcheck -x sysz packaging/build-deb.sh

test: lint deb
	./sysz --version | grep -F "$(VERSION)"
	./sysz --help >/dev/null
	# fzf dependency is declared in the control template and built package
	grep -E 'Depends:.*fzf' debian/control packaging/build-deb.sh
	dpkg-deb -f dist/sysz_$(VERSION)_all.deb Depends | grep -E 'fzf'
