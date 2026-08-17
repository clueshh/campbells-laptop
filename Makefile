KONSAVE_PROFILE_NAME ?= default

install-system-deps:
	apt install --yes python3-pip python3-venv

install:
	pip install -r requirements.txt
	ansible-galaxy install -r requirements.yml

install-dev: install
	npm install -g prettier

install-test: install
	pip install -r requirements-test.txt

# The vagrant driver ships its `vagrant` module in the molecule-plugins package;
# recent molecule no longer adds it to ANSIBLE_LIBRARY automatically, so wire it
# up for the test targets.
VAGRANT_MODULES_DIR = $(shell python -c 'import molecule_plugins.vagrant as m, os; print(os.path.join(os.path.dirname(m.__file__), "modules"))' 2>/dev/null)
test test-converge test-verify test-login test-destroy: export ANSIBLE_LIBRARY = $(VAGRANT_MODULES_DIR)

# Full e2e: clean Ubuntu 24.04 VM, converge, then assert idempotence and verify.
test:
	molecule test

test-converge:
	molecule converge

test-verify:
	molecule verify

test-login:
	molecule login

test-destroy:
	molecule destroy


ansible-playbook:
	ansible-playbook playbooks/main.yaml -K

ansible-playbook-%:
	ansible-playbook playbooks/main.yaml -K --tags $*

lint-prettier:
	prettier \
		--ignore-path '.prettierignore' \
		--config '.prettierrc.yaml' \
		--check \
		--ignore-unknown \
		'*.y*ml' \
		'**/*.y*ml'

lint-ansible:
	ansible-lint -c .ansible-lint.yaml

lint: lint-prettier lint-ansible

format:
	prettier \
		--ignore-path '.prettierignore' \
		--config '.prettierrc.yaml' \
		--list-different \
		--ignore-unknown \
		--write '*.y*ml' \
		'**/*.y*ml'

konsave-save:
	konsave --save $(KONSAVE_PROFILE_NAME)

konsave-export:
	konsave \
		--export-profile $(KONSAVE_PROFILE_NAME) \
		--export-name $(KONSAVE_PROFILE_NAME) \
		--export-directory ./konsave

konsave-import:
	konsave --import-profile ./konsave/$(KONSAVE_PROFILE_NAME).knsv

GNOME_SUBTREES = desktop shell mutter settings-daemon

gnome-save:
	@for sub in $(GNOME_SUBTREES); do \
		dconf dump /org/gnome/$$sub/ > playbooks/files/gnome/$$sub.ini; \
		echo "saved $$sub"; \
	done

gnome-load:
	@for sub in $(GNOME_SUBTREES); do \
		dconf load /org/gnome/$$sub/ < playbooks/files/gnome/$$sub.ini; \
		echo "loaded $$sub"; \
	done
