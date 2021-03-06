# Specify defaults for testing
PREFIX := $(shell pwd)/prefix
PYTHON = dls-python
MODULEVER=0.0

# Override with any release info
-include Makefile.private

# This is run when we type make
dist: setup.py $(wildcard pmacparser/*.py)
	MODULEVER=$(MODULEVER) $(PYTHON) setup.py bdist_egg
	touch dist

# Clean the module
clean:
	$(PYTHON) setup.py clean
	rm -rf build dist *egg-info installed.files prefix docs/html
	find -name '*.pyc' -delete -or -name '*~' -delete

# Install the built egg and keep track of what was installed
install: dist
	$(PYTHON) setup.py easy_install -m \
		--record=installed.files \
		--prefix=$(PREFIX) dist/*.egg

# Upload to pypi test. N.b. this needs to be run from a environment with twine installed. Push to travis to publish.
testpublish:
	$(PYTHON) setup.py sdist
	twine upload --repository pypitest dist/*

