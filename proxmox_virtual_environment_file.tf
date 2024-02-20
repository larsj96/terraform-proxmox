

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "hp1"

  source_raw {
    data = <<EOF
#cloud-config
users:
  - default
  - name: ubuntu
    groups:
      - sudo
    shell: /bin/bash
    ssh_authorized_keys:
      - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDogMdWfrqX1XAc231blwxM9x3STfWdTZ84n+vu3/WM+p+6GS1Ob3FMWZB5ob1hatbrGt1ciBwbuGSiNgNWfInuOFWeF6AnBKszbuqA0q/0qTg94etDBXfG7onuAQOCH+YeosuSj2GsgdQEpGV8z2UasDICnpWjzkZ9E3Bl2pEiPCtC+lT4AB2IqL+z+Npvi1PnZ1B9JThEFioT5Ja3AOLhMxkIOgLHos7ksjlc6u9QMU3pgFHvAjYWS8plusYwrtPVHQ+8YQQvpklMaTdJOSaGCbHEwvjmItI5AxHl6IvcnpFTAhLbnmE6YaiEfGudwI9RmDeWu5/jBdmjpB4c26ZrBYnJYhB8Gr62uGydKTLFJzUXDokpFtUjEDFLRAKnWfu1wddMej3UuT1IC0L6u+hjwk78oPdsPfFgTMLL8RCHaFsgmSNCCVLLy+CWbleze3+ihs+Bs+SiGDvcT9m3zxusa7IFg6cTz4mcAqVZ/ZYvQ9Vj2BCoKr2ppmvNiJcZGmc= lanil@AZTEK-PC27RF42"
    sudo: ALL=(ALL) NOPASSWD:ALL
runcmd:
    - apt update
    - apt install -y qemu-guest-agent net-tools
    - timedatectl set-timezone Europe/Oslo
    - systemctl enable qemu-guest-agent
    - systemctl start qemu-guest-agent
    - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "cloud-config.yaml"
  }
}





# resource "proxmox_virtual_environment_file" "cloud_config" {
#   content_type = "snippets"
#   datastore_id = "local"
#   node_name    = "pve01"
#   source_raw {
#     data = <<EOF
# #cloud-config
# #fjasjasdas
# chpasswd:
#   expire: False
# users:
#   - default
#   - name: devops
#     groups: sudo
#     shell: /bin/bash
#     ssh-authorized-keys:
#       - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCYcEX+zLVBq4R+WhCCHqAAnhzyYMzTgfiGAb0bMz0WeYXR1As2+RzdZ3zkC9TGjFJj3jvGhKgcF7xyZxpakOkQXigkox2kQFBlpq4vmek+/Zf9TFiNBTHgp+IpI4oL9xmdbfyfZqo/JMHOX8fYjpR+y6enzKa3pxHk59Nbjb0DXODpwAHqjf52cTR1abCdr6mMSOvLtAqBbRJEF1vwJ2evXjzabpG/mOH23YgZwiKx1t+kSyNaxFLp9zCsiXmGPGXjCiPXjiFO64ANZ2m+lrDhAsjSAQjptxJFLU3ZzP2fyASXugGpCV55kBn0v+s+hukD96LE/L6nFex6idO6MSL1hQx+w/8tU4Gc6VJ9UNMpcaDqMbJo3hQYF5CDw9u6R9S5hnLpX3KGn71bkUsSLG+aULJG8McQpFDvBaFCcbUx6k+DA2Y97I2OO+PRet8TtHM8cigRb8+Y1F/cm39FwCWptYKny9f6T+Tj5UMDVotd2cSqEy+ol8zIk3pZphF4mrM= lindelien@linbast.hoeg.li
#     sudo: ALL=(ALL) NOPASSWD:ALL
# EOF

#     file_name = "cloud-config.yaml"
#   }



#   source_raw {
#     data = <<EOF
# #cloud-config
# packages:
#   - qemu-guest-agent
# runcmd:
#   - systemctl enable --now qemu-guest-agent
# EOF

#     file_name = "cloud-config.yaml"
#   }
# }

# cloud_init_modules:
#   - migrator
#   - seed_random
#   - bootcmd
#   - write_files
#   - growpart
#   - resizefs
#   - disk_setup
#   - mounts
#   - ca_certs
#   - rsyslog
#   - users_groups
#   - ssh

# users:
#   - default
#   - name: devops
#     groups: sudo
#     shell: /bin/bash
#     ssh-authorized-keys:
#       - ${trimspace(tls_private_key.ubuntu_vm_key.public_key_openssh)}
#     sudo: ALL=(ALL) NOPASSWD:ALL

