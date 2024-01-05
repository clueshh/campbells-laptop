install-dev:
	npm install -g prettier
	pip install -r requirements.txt
	ansible-galaxy install -r requirements.yml

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
