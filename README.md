# Campbell's Laptop

An ansible playbook to setup my laptop (KDE).

## Getting Started

```bash
make install-dev
```

## Usage

```bash
# to run everything in main.yaml
make ansible-playbook

# to run a specific tag
make ansible-playbook-software-install

# or to run it manually
ansible-playbook -K main.yaml
ansible-playbook -K main.yaml --tags software-install
```
