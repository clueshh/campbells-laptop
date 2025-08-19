KONSAVE_PROFILE_NAME ?= default

install-system-deps:
	apt install --yes python3-pip python3-venv

install:
	pip install -r requirements.txt
	ansible-galaxy install -r requirements.yml

install-dev: install
	npm install -g prettier

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
