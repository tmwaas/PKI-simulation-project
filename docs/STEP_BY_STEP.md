# Step-by-step lab guide

## Step 1: Prepare VMs
See `docs/VM_SETUP.md` for VM specs and network.

## Step 2: Initialize CA on Root VM
Copy `ca/README_CA_SETUP.md` to the Root VM and run the commands.
Keep the `private/` keys safe and readable only by root.

## Step 3: Prepare Ansible Control Node
- Install Ansible and required collections:
  ```
  sudo dnf install -y python3 python3-pip
  pip3 install ansible
  ansible-galaxy collection install community.crypto
  ```
- Place the `ca/` contents in a folder accessible to the control node and update `playbooks/files/ca.cert.pem` with your actual CA cert.

## Step 4: Run the playbook
From the control node:
```
ansible-playbook -i inventory.yml playbooks/pki-automation.yml
```

## Step 5: Sign CSRs (manual or scripted)
- If you fetched client CSRs to the control node, sign them on the CA:
  ```
  openssl x509 -req -in fetched_csrs/linux_client.csr.pem -CA ~/ca/intermediate/certs/intermediate.cert.pem -CAkey ~/ca/intermediate/private/intermediate.key.pem -CAcreateserial -out signed/linux_client.cert.pem -days 365 -sha256
  ```
- Distribute signed certs back to clients and install them (Linux: /etc/pki/client.crt.pem, Windows: import to LocalMachine\My)

## Step 6: Configure Nagios
- Install Nagios Core on VM4 and configure hosts for linux_client and windows_client.
- Add NRPE/NSClient++ checks and the included `check_ssl_cert.sh`.

## Step 7: CI/CD
- Add the `.gitlab-ci.yml` in GitLab repository and configure the runner with access to the Ansible control node.

## Step 8: Simulate incidents
- Let a certificate approach expiration and renew it via the playbook.
- Stop a Windows service (IIS) and let Nagios alert; then run an Ansible task to restart and document the incident.

