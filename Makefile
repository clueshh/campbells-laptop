install-dev:
	npm install -g prettier
	pip install -r requirements.txt
	ansible-galaxy collection install -r requirements.yml
	ansible-galaxy role install -r requirements.yml

ansible-playbook:
	ansible-playbook main.yaml -K

ansible-playbook-%:
	ansible-playbook main.yaml -K --tags $*

lint:
	prettier \
		--ignore-path '.prettierignore' \
		--config '.prettierrc.yaml' \
		--check \
		--ignore-unknown \
		'*.y*ml' \
		'**/*.y*ml'

format:
	prettier \
		--ignore-path '.prettierignore' \
		--config '.prettierrc.yaml' \
		--list-different \
		--ignore-unknown \
		--write '*.y*ml' \
		'**/*.y*ml'
