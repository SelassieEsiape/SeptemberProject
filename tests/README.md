# Tests


## Prerequisites

- Docker
- Public key

## Usage

Currently, you will need to pass your public key as an argument in build.sh or hard-code it into the Dockerfile, then run the following:
```bash
./run_test.sh
```
This builds and sets up 4 docker containers as standalone linux hosts. Ansible scripts can be run against them to show that they're working
```
[+] Building . . .
[SNIP]
 => => naming to docker.io/library/passwd-tst
Starting container on port 2222...
bed58f33189a3fae0e589753562c324d85c1f223b0f2d63926a2b5cb73c28fcc
Starting container on port 2223...
e898e5dda700debd2ae5d2b995c3e59a8e02949e2ce64109789d81e98af1636c
Starting container on port 2224...
8f932aa8697b2f767fd616ff9d82ad6b6e05b1b2b714fac3cf76faa43bcdf56c
Starting container on port 2225...
cc89bc9f177ef2eec46d96165d675bf48322001c1ca03b008dcac9fd010129ad
All containers started!
Test is running!
Press Enter to kill ALL Docker containers
```

You can then use the test_hosts.ini as an inventory list and show_users.yml to list all users using ansible or you can change all non-system user passwords to a predefined value.

When you're done, you can press enter to kill all running docker containers
```
Stopping running containers...
cc89bc9f177e
8f932aa8697b
e898e5dda700
bed58f33189a
```