prefix := /usr
sysconfdir := /etc
sbindir := $(prefix)/sbin
datadir := $(prefix)/share
mandir := $(datadir)/man
version := 1.0.3
relversion := 1
tmpdir := /tmp
builddir := simplesnap-$(version)
topdir := $(shell pwd)/pkg

_default:
	@echo "No default. Try 'make install'"

install:
	install -d $(DESTDIR)$(mandir)/man8
	install doc/simplesnap.8 $(DESTDIR)$(mandir)/man8/simplesnap.8
	install -d $(DESTDIR)$(sbindir)
	install simplesnap $(DESTDIR)$(sbindir)/simplesnap
	install simplesnapwrap $(DESTDIR)$(sbindir)/simplesnapwrap

clean:
	rm -rf dist/
	rm -rf pkg/
	rm -rf $(tmpdir)/$(builddir)

build:
	mkdir -p $(tmpdir)/$(builddir)
	cp -r doc $(tmpdir)/$(builddir)/
	cp -r examples $(tmpdir)/$(builddir)/
	cp COPYING INSTALL.txt Makefile README.txt simplesnap simplesnapwrap TODO $(tmpdir)/$(builddir)/
	mkdir -p dist
	tar -czf dist/simplesnap-$(version).tar.gz -C $(tmpdir) simplesnap-$(version)

rpm: build
	mkdir -p $(topdir)
	cp dist/simplesnap-$(version).tar.gz $(topdir)/
	rpmbuild --define "_topdir $(topdir)" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}" \
	--define "_specdir %{_topdir}" \
 	--define "_sourcedir  %{_topdir}" \
	--define "version $(version)" \
	--define "relversion $(relversion)" \
	-ba redhat/simplesnap.spec
