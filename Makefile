install-dev:
	npm install -g prettier
	pip install -r requirements.txt

run:
	ansible-playbook main.yaml -K

lint:
	yamllint -c '.yamllint.yaml' .

format:
	prettier \
		--ignore-path '.prettierignore' \
		--config '.prettierrc.yaml' \
		--list-different \
		--ignore-unknown \
		--parser=yaml \
		--write '*.y*ml' \
		'**/*.y*ml'
