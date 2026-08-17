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

## Testing

Full e2e test using Molecule with the vagrant/libvirt driver. It boots a clean
Ubuntu 24.04 VM, converges the playbook against it, and verifies a sample of the
installed tooling. This keeps the test reproducible and off your real machine.

Requires libvirt/KVM and vagrant with the `vagrant-libvirt` plugin.

```bash
source venv/bin/activate
make install-test

# destroy -> create -> converge -> verify -> destroy
make test

# iterate without tearing down the VM
make test-converge
make test-verify
make test-login
make test-destroy
```

Notes:

- The `general-config` tag is skipped in the e2e run. It clones a private SSH
  repo and applies desktop dconf settings, neither of which work in a clean
  headless VM.
- A few tasks pull `HEAD`/`lts`/`stable` upstreams (pyenv, nvm, rustup, uv), so
  the run is reproducible in structure but not fully version-pinned.
- The Molecule `idempotence` step is intentionally omitted. Three tasks in
  galaxy-installed roles report `changed` on every run and cannot be fixed
  without patching those upstream roles:
  - `manala.roles.ohmyzsh` forces `~/.oh-my-zsh` to `root:root`, which the
    "Own oh-my-zsh as the current user" task then chowns back, so both flap.
  - `staticdev.pyenv` runs `pyenv update` with a hardcoded `changed_when`, so it
    always reports changed.


