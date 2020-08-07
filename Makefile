PREFIX = /usr/local

.PHONY: install
install: wheelfreeze.sh
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	install $< $(DESTDIR)$(PREFIX)/bin/wheelfreeze

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/wheelfreeze
