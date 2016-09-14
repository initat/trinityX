#!/bin/bash

# trinityX
# Standard node post-installation script
# This should include all the most common tasks that have to be performed after
# a completely standard CentOS minimal installation.


if flag_is_set STDCFG_SSHROOT ; then
    echo_info "Allowing SSH login as root"
    sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
else
    echo_info "SSH login as root disabled"
fi


#---------------------------------------

echo_info "Copying the root's SSH public key, if it exists"

if [[ -r "${TRIX_ROOT}/root/.ssh/id_ed25519.pub" ]] ; then
    mkdir -p /root/.ssh
    chmod 700 /root/.ssh
    append_line /root/.ssh/authorized_keys "$(cat "${TRIX_ROOT}/root/.ssh/id_ed25519.pub")"
    chmod 600 /root/.ssh/authorized_keys
fi


#---------------------------------------

echo_info 'Creating the SSH host key pairs'

[[ -e /etc/ssh/ssh_host_rsa_key ]] || \
    ssh-keygen -t rsa -b 4096 -N "" -f /etc/ssh/ssh_host_rsa_key
[[ -e /etc/ssh/ssh_host_ed25519_key ]] || \
    ssh-keygen -t ed25519 -N "" -f /etc/ssh/ssh_host_ed25519_key


#---------------------------------------

echo_info "Disabling SELinux"

sed -i 's/\(^SELINUX=\).*/\1disabled/g' /etc/sysconfig/selinux /etc/selinux/config
setenforce 0
echo_warn "Please remember to reboot the node after completing the configuration!"


#---------------------------------------

echo_info "Disabling firewalld"

systemctl disable firewalld.service


#---------------------------------------

echo_info "Using the controller as DNS server"

cat > /etc/resolv.conf << EOF
# This file is automatically generated by the trinity installer

search cluster ipmi
nameserver $TRIX_CTRL_IP

EOF

