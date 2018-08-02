BUILD_DIR="/home/cornelius/build"

phony:
	@echo "Use this to build and publish packages"

get-privacyidea:
	rm -fr privacyidea
	git clone https://github.com/privacyidea/privacyidea
	(cd privacyidea; git submodule init)
	(cd privacyidea; git submodule update --recursive --remote)

get-appliance:
	rm -fr privacyidea-appliance
	git clone https://github.com/privacyidea/privacyidea-appliance
	(cd privacyidea-appliance; git submodule init)
	(cd privacyidea-appliance; git submodule update --recursive --remote)

build-privacyidea:
	(cd privacyidea; git checkout $(VERSION))
	rm -f changelog.tmp
	sed -e s/'Cornelius Kölbel <cornelius@privacyidea.org>'/'NetKnights GmbH <release@netknights.it>'/g privacyidea/deploy/debian-ubuntu/changelog > changelog.tmp
	mv changelog.tmp privacyidea/deploy/debian-ubuntu/changelog
	sed -e s/'Cornelius Kölbel <cornelius.koelbel@netknights.it>'/'NetKnights GmbH <release@netknights.it>'/g privacyidea/deploy/debian-ubuntu/changelog > changelog.tmp
	mv changelog.tmp privacyidea/deploy/debian-ubuntu/changelog
	(cd privacyidea; make builddeb)

build-contrib:
	(cd privacyidea/contrib; make ubuntu)       

build-appliance:
	(cd privacyidea-appliance; git checkout $(VERSION))
	rm -f changelog.tmp
	sed -e s/'Cornelius Kölbel <cornelius.koelbel@netknights.it>'/'NetKnights GmbH <release@netknights.it>'/g privacyidea-appliance/debian/changelog > changelog.tmp
	mv changelog.tmp privacyidea-appliance/debian/changelog
	(cd privacyidea-appliance; make builddeb)

init-repo:
	reprepro -b $(BUILD_DIR)/repository/stable createsymlinks
	reprepro -b $(BUILD_DIR)/repository/devel createsymlinks

add-repo-devel:
	reprepro -b $(BUILD_DIR)/repository/devel -V include xenial privacyidea/DEBUILD/*.changes || true
	reprepro -b $(BUILD_DIR)/repository/devel -V include xenial privacyidea-appliance/DEBUILD/*.changes || true
	reprepro -b $(BUILD_DIR)/repository/devel -V include xenial privacyidea/contrib/python-flask-sqlalchemy/deb_dist/*amd64.changes || true

repo-stable:
	@echo "Just copyiing the devel to stable"
	(cd repository;	cp -rP devel/* stable/)

push-lancelot:	
	rsync -r repository/* root@lancelot:/srv/www/apt/

ifndef VERSION
        $(error VERSION not set. Set VERSION to build like VERSION=v2.19.1)
endif


