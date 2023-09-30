# Mass Password Changer

Provides a script (show_users.yml) for listing all accounts on hosts. For all hosts, you can set a new password (reset_password.yml) for all non-system users. This functionality provides you a nuclear option for fast containment and recovery when dealing with an incident.

NOTE: This assumes you're not using LDAP; using this against LDAP-bound servers may result in unintended consequences.

## Usage
```bash
# Get all accounts in the host list
ansible-playbook -i inventory.ini -u root show_users.yml

# Set all non-system user passwords to a hard-coded string
ansible-playbook -i inventory.ini -u root reset_passwords.yml

# Pass in a password
ansible-playbook -i inventory.ini -u root -e "change_password=password1" reset_passwords.yml
```

## Testing Process
The tests directory contains a number of scripts for building a number of docker containers and testing the ansible scripts on them.

Start the testing environment:
```bash
cd tests
./run_tests.sh
# Hit enter when you want to stop the testing environment
# Note: it will close all docker containers
```

Test user passwords in the container(s):
```bash
ssh user1@localhost -p 2222
```

When you get locked out and need to troubleshoot:
```bash
docker ps # gets you a list of container ids
docker exec -it --tty <container id> /bin/bash # Gives you a root shell into the container
```
