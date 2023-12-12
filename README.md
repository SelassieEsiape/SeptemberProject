# Mass Password Changer

Provides a script (show_users.yml) for listing all accounts on hosts. For all hosts:
- Each non-system user will receive a random temporary password
- Each non-system user will be required to change their password on next sign-in
- Any ~/.ssh/authorized_keys files will be backed up to authorized_keys.old and replaced with the admin's public SSH key
- The resulting randomized passwords are shown in the output for each host and user

This functionality provides you a nuclear option for fast containment and recovery when dealing with an incident.

WARNING: This assumes you're not using LDAP; using this against LDAP-bound servers may result in unintended consequences.

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


### Set all non-system user passwords to a randomized string and disable authorized_keys
Shows the resulting new password in the ansible output for reference
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

TASK [Generate a unique random password for each user and store it] ***************************
ok: [test1] => (item=user1)
ok: [test2] => (item=user1)
[SNIP]
ok: [test2] => (item=user3)
ok: [test4] => (item=user3)


TASK [Set the unique random password for each non-system user] ********************************
changed: [test4] => (item={'user': 'user1', 'password': 'cdpZhm9jSJDO'})
changed: [test3] => (item={'user': 'user1', 'password': 'n0PiIv5kJQvZ'})
[SNIP]
changed: [test1] => (item={'user': 'user3', 'password': 'XCRp9qzn60N6'})
changed: [test3] => (item={'user': 'user3', 'password': 'baYo6BFjDGBq'})

TASK [Backup existing authorized_keys file to authorized_keys.old] ****************************
skipping: [test2] => (item={'changed': False, 'stat': {'exists': False}, 'invocation': {'module_args': {'path': '/home/user1/.ssh/authorized_keys', 'follow': False, 'get_md5': False, 'get_checksum': True, 'get_mime': True, 'get_attributes': True, 'checksum_algorithm': 'sha1'}}, 'failed': False, 'item': 'user1', 'ansible_loop_var': 'item'}) 
[SNIP]
changed: [test1] => (item={'changed': False, 'stat': {'exists': True, 'path': '/home/user1/.ssh/authorized_keys', 'mode': '0644', 'isdir': False, 'ischr': False, 'isblk': False, 'isreg': True, 'isfifo': False, 'islnk': False, 'issock': False, 'uid': 1000, 'gid': 1000, 'size': 0, 'inode': 12997597, 'dev': 52, 'nlink': 1, 'atime': 1701409596.6590085, 'mtime': 1701409596.6590085, 'ctime': 1701409604.7069907, 'wusr': True, 'rusr': True, 'xusr': False, 'wgrp': False, 'rgrp': True, 'xgrp': False, 'woth': False, 'roth': True, 'xoth': False, 'isuid': False, 'isgid': False, 'blocks': 0, 'block_size': 4096, 'device_type': 0, 'readable': True, 'writeable': True, 'executable': False, 'pw_name': 'user1', 'gr_name': 'user1', 'checksum': 'da39a3ee5e6b4b0d3255bfef95601890afd80709', 'mimetype': 'unknown', 'charset': 'unknown', 'version': None, 'attributes': [], 'attr_flags': ''}, 'invocation': {'module_args': {'path': '/home/user1/.ssh/authorized_keys', 'follow': False, 'get_md5': False, 'get_checksum': True, 'get_mime': True, 'get_attributes': True, 'checksum_algorithm': 'sha1'}}, 'failed': False, 'item': 'user1', 'ansible_loop_var': 'item'})
[SNIP]

TASK [Replace content of authorized_keys file with a new SSH key] *****************************
[SNIP]
skipping: [test3] => (item={'changed': False, 'stat': {'exists': False}, 'invocation': {'module_args': {'path': '/home/user2/.ssh/authorized_keys', 'follow': False, 'get_md5': False, 'get_checksum': True, 'get_mime': True, 'get_attributes': True, 'checksum_algorithm': 'sha1'}}, 'failed': False, 'item': 'user2', 'ansible_loop_var': 'item'}) 
skipping: [test3] => (item={'changed': False, 'stat': {'exists': False}, 'invocation': {'module_args': {'path': '/home/user3/.ssh/authorized_keys', 'follow': False, 'get_md5': False, 'get_checksum': True, 'get_mime': True, 'get_attributes': True, 'checksum_algorithm': 'sha1'}}, 'failed': False, 'item': 'user3', 'ansible_loop_var': 'item'}) 
skipping: [test3]
changed: [test1] => (item={'changed': False, 'stat': {'exists': True, 'path': '/home/user1/.ssh/authorized_keys', 'mode': '0644', 'isdir': False, 'ischr': False, 'isblk': False, 'isreg': True, 'isfifo': False, 'islnk': False, 'issock': False, 'uid': 1000, 'gid': 1000, 'size': 0, 'inode': 12997597, 'dev': 52, 'nlink': 1, 'atime': 1701409596.6590085, 'mtime': 1701409596.6590085, 'ctime': 1701409604.7069907, 'wusr': True, 'rusr': True, 'xusr': False, 'wgrp': False, 'rgrp': True, 'xgrp': False, 'woth': False, 'roth': True, 'xoth': False, 'isuid': False, 'isgid': False, 'blocks': 0, 'block_size': 4096, 'device_type': 0, 'readable': True, 'writeable': True, 'executable': False, 'pw_name': 'user1', 'gr_name': 'user1', 'checksum': 'da39a3ee5e6b4b0d3255bfef95601890afd80709', 'mimetype': 'unknown', 'charset': 'unknown', 'version': None, 'attributes': [], 'attr_flags': ''}, 'invocation': {'module_args': {'path': '/home/user1/.ssh/authorized_keys', 'follow': False, 'get_md5': False, 'get_checksum': True, 'get_mime': True, 'get_attributes': True, 'checksum_algorithm': 'sha1'}}, 'failed': False, 'item': 'user1', 'ansible_loop_var': 'item'})
[SNIP]

PLAY RECAP ************************************************************************************
test1                      : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
test2                      : ok=5    changed=2    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
test3                      : ok=5    changed=2    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
test4                      : ok=5    changed=2    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
```
After which, you can test that the change had the intended effect:
```bash
# using ssh
ssh user1@localhost -p 2222
    # enter new password to test
# OR while already on the container
su user1
Password: # Enter new password to test

You are required to change your password immediately (administrator enforced).
You are required to change your password immediately (administrator enforced).
[SNIP]
Last login: Fri Dec  1 05:19:32 2023 from 172.17.0.1
WARNING: Your password has expired.
You must change your password now and login again!
Changing password for user1.
Current password: 
New password: 
Retype new password: 
passwd: password updated successfully
Connection to localhost closed.
```
If they had an authorized key file:
```bash
ssh user1@localhost
$ whoami
user1
$ cd .ssh
$ ls
authorized_keys  authorized_keys.old
$ cat authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBznwIb7wGsPVKqUqehpBK7wpUBHaiqU1HQEwfc48LzP$ 
# ^ The above is the admin's public key as enforced by the script
$ cat authorized_keys.old
OldContentBadSSHKeyForBaddieToReturn
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
