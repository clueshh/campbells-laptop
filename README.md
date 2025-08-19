# Campbell's Laptop

An ansible playbook to setup my laptop (KDE).

## Getting Started

```bash
# add the public key to github
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

git clone git@github.com:clueshh/campbells-laptop.git
cd campbells-laptop

sudo make install-system-deps
python3 -m venv venv
source venv/bin/activate

make install
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

# backup using konsave
make konsave-save
make konsave-export
```
