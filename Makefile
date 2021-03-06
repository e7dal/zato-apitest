
.PHONY: test

ENV_NAME=apitest-env
BIN_DIR=$(CURDIR)/$(ENV_NAME)/bin

default: demo

install:
	virtualenv $(CURDIR)/$(ENV_NAME)
	$(BIN_DIR)/pip install --no-cache-dir -r $(CURDIR)/requirements.txt
	$(BIN_DIR)/python $(CURDIR)/setup.py develop
	$(BIN_DIR)/pip install -e $(CURDIR)/.

clean:
	rm -rf $(CURDIR)/$(ENV_NAME)
	rm -rf $(CURDIR)/build
	rm -rf $(CURDIR)/dist
	rm -rf $(CURDIR)/src/zato_apitest.egg-info
	find $(CURDIR) -name '*.pyc' -exec rm {} \;

demo:
	$(MAKE) install
	$(BIN_DIR)/apitest demo

test:
	$(MAKE) install
	$(BIN_DIR)/nosetests $(CURDIR)/test/zato --with-coverage --cover-package=zato --nocapture
	$(BIN_DIR)/flake8 $(CURDIR)/src/zato --count
	$(BIN_DIR)/flake8 $(CURDIR)/test/zato --count

pypi:
	$(MAKE) clean
	$(MAKE) default
	$(BIN_DIR)/python $(CURDIR)/setup.py sdist bdist_wheel
	$(BIN_DIR)/twine upload $(CURDIR)/dist/zato*

