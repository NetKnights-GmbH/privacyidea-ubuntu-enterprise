Erstmal in die virtual env wechseln:

    source venv/bin/activate

Aktuelle Sourcen holen:


    VERSION=v2.20.1 make get-appliance
    VERSION=v2.20.1 make get-privacyidea


Dann bauen der getaggten Version!

    VERSION=v2.0 make build-appliance
    VERSION=v2.19.1 make build-privacyidea


Dann die gebauten Pakete ins lokale Devel Repo schieben:

    make add-repo-devel

Wenn getestet ins stable repo kopieren

    make repo-stable

Das ganze Repo nach lancelot pushen

    make push-lancelot

# Use repository:

    deb https://user:pass@lancelot.netknights.it/apt/stable xenial main
    deb https://user:pass@lancelot.netknights.it/apt/devel xenial main
