
######################################################################
# Trinity X
# Copyright (c) 2016  ClusterVision B.V.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License (included with the sources) for more
# details.
######################################################################


display_var POST_FILEDIR FWD_HTTPS_PUBLIC

if flag_is_set FWD_HTTPS_PUBLIC ; then
    echo_info 'Enabling HTTPS in the public zone'
    
    # firewalld isn't running as we are inside a chroot, so we can't use
    # firewall-cmd to modify the configuration. So copy a basic zone definition.
    
    mkdir -p /etc/firewalld/zones
    cp "${POST_FILEDIR}"/public.xml /etc/firewalld/zones
fi


echo_info 'Enabling firewalld'

systemctl enable firewalld

echo_warn 'Remember to configure the zones of your interfaces via the provisioning tool!'

