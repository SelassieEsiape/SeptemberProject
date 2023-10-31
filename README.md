# Mass Password Changer

Provides a script (show_users.yml) for listing all accounts on hosts. For all hosts, you can set a new password and SSH public key (reset_password.yml) for all non-system users (all users will need to reset their password after first login). This functionality provides you a nuclear option for fast containment and recovery when dealing with an incident.

NOTE: This assumes you're not using LDAP; using this against LDAP-bound servers may result in unintended consequences.

## Usage Examples

### Get All Accounts on Hosts
#### Example Command
```bash
ansible-playbook -i inventory.ini -u root show_users.yml
```

#### Result
```bash
TASK [Get a list of all users] *****************************************************************************************************************************************************************
changed: [test4]
changed: [test1]
changed: [test3]
changed: [test2]

TASK [Show all users] **************************************************************************************************************************************************************************
ok: [test3]
ok: [test1]
ok: [test2]
ok: [test4]

TASK [debug] ***********************************************************************************************************************************************************************************
ok: [test1] => {
    "system_users": [
        "root:x:0:0:root:/root:/bin/bash",
        "daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin",
        "bin:x:2:2:bin:/bin:/usr/sbin/nologin",
        [SNIP]
ok: [test2] => {
        [SNIP]
ok: [test3] => { 
        [SNIP]
ok: [test4] => {
        [SNIP]

PLAY RECAP *************************************************************************************************************************************************************************************
test1                      : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
test2                      : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
test3                      : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
test4                      : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


### Set all non-system user passwords to a hard-coded string
#### Example Command
```bash
ansible-playbook -i inventory.ini -u root reset_passwords.yml
```

#### Result
```bash
TASK [Fetch non-system users] ******************************************************************************************************************************************************************
ok: [test3]
ok: [test4]
ok: [test2]
ok: [test1]

TASK [Set the same password for all non-system users] ******************************************************************************************************************************************
changed: [test4] => (item=user1)
changed: [test3] => (item=user1)
[SNIP]
changed: [test2] => (item=user3)

PLAY RECAP *************************************************************************************************************************************************************************************
test1                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
test2                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
test3                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
test4                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```
After which, you can test that the change had the intended effect:
```bash
# using ssh
ssh user1@localhost -p 2222
    # enter new password to test
# OR while already on the container
su user1
Password: # Enter new password to test
```

### Pass in a password
#### Example Command
```bash
ansible-playbook -i inventory.ini -u root -e "change_password=password1!" reset_passwords.yml
```
#### Result
All hosts and user accounts are changed to the new password passed in as the environment
```bash
TASK [Fetch non-system users] ******************************************************************************************************************************************************************
ok: [test3]
ok: [test4]
ok: [test2]
ok: [test1]

TASK [Set the same password for all non-system users] ******************************************************************************************************************************************
changed: [test4] => (item=user1)
changed: [test3] => (item=user1)
[SNIP]
changed: [test3] => (item=user3)
changed: [test2] => (item=user3)

PLAY RECAP *************************************************************************************************************************************************************************************
test1                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
test2                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
test3                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
test4                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
After which, you can test that the change had the intended effect:
```bash
# using ssh
ssh user1@localhost -p 2222
    # enter new password to test
# OR while already on the container
su user1
Password: # Enter new password to test
```

## Testing Process
The tests directory contains a number of scripts for building a number of docker containers and testing the ansible scripts on them.

Start the testing environment:
```bash
cd tests
./run_tests.sh
# Hit enter when you want to stop the testing environment
# Note: be careful, it closes stops docker containers on your machine
```

Test user passwords in the container(s):
```bash
ssh user1@localhost -p 2222
```

When you get locked out and need to troubleshoot:
```bash
docker ps # gets you a list of container ids
docker exec -it --tty <container id> /bin/bash # Gives you a root shell into the specified container
```
