# Bash script to install Ansible, clone other required repositories and execute Ansible WSL playbook.

### Ensure vars.yml is populated manually before running this script (excluded from git)

# Vars
repourl="https://github.com/epichouse/ansible-roles"
repo=$(basename "$repourl" .git)

git pull

# Check for required vars file
if [ ! -f ansible/vars.yml ]; then
    printf "\033[0;31mvars.yml not found. Please duplicate vars_template.yml and populate vars before running\n"
    exit
fi

### Ansible installation
if ! which ansible > /dev/null; then
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt update
    sudo apt install ansible -y
fi

# Ansible roles clone/pull step.
cd ..
if [ -d "$repo" ]; then
    cd $repo && git pull && cd ../client-config
else
    git clone $repourl && cd ../client-config
fi

# Execute Ansible Playbook
cd ansible
ansible-playbook setup.yml --ask-become-pass
cd ../
