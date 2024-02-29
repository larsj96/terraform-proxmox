resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "snippetsogISO"
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
      - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCz/JZYBglJD0gw7t+0dABSpnwNFxel+o0DjdHsxQki/mKXvSe9Ah/udCLXI1KZFLxoFHOJkcglFYBG3ht2LO2WfGKTbrTMVi8L7ly4ZuNvNACeMxPbxULKLLa4VCJdYgeM7BNk6N5VCzQbfexw7ULVoRhRfnawp9Y4DDZ1GaGW4bA3L+9KFPkLgIv6hn/tJGUdZDfyc60RaTArEcOeKbwxB2Ds5Y8fiVFrXCBV9UE6nr5OYqXftd6Y9Z5W4C69Qekus4IHNlktF1ofu4bZl2YlYC2MlhcRsU0txVnby3z0JqnfjpdrrO/hszKookivv+apMzdZq8on3ubg544wfv8zlbO/4nnM5oUmw2zD1BSOXsnsmg4CwRPAR/Znn2hu5YYQVWF0xegDSqMslBVu2vKIbgZa8gzJtYi+9/zeYBj9pW+/VfP3pjwZh9dqeTbz13KtMiOHuB2MNEp+eOUw+yvGhp2BbjWFaX0Xy+X5Q8V9TkbzqiDSqY7aUCdHOou1Xlc= ljn@DESKTOP-DFCHU80"
      - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpruL39xAMiQi6H1UxPLot9c/5r2dnkzA5Mo9WhDMlG+LCFaJiOil5uoKqdW14HPOulROqLKeWTAX+qoLa9UpOqbnSms3sEwFEcRomvRUYGw+DSwOgsKuV72cx9jm7MdqnOUybZWZ0nPqd+fMOKPb7U4x3T3pJApBCkOa5nk6H73CvlN9J9fY0oeBNJpQPjrI4VUeYRluqO58MkanYGA6v86ByCxgOwrHCb+htacHu4D9wcNcAkbEyJYe5YmQnwm/yu5EGSAbQ7f65tmQbSruPbieVaiSxxn3Ev3T9NAWXEM7dBSvZ5T7bDxxb+RslKWZMwsN1dUZFjwZg/khB2UdNVlobQHoT5PMq1sN7a/hkpL35AoPvwGvldd4N7IciGiiukC8ZJDh7efomPUdQQ5itdTe6SybiaVTttOQA0v8ZwA2l/oOvzodD1sEWCLowyZu0AiryfxbjFvG7mEb1N4aGeP0aBKPSCHOheu6ow4QpfrWWO+gI4pkMXuEuT+Xx7IE= l. nilsen@DESKTOP-DFCHU80"
    sudo: ALL=(ALL) NOPASSWD:ALL
    chpasswd: 
      list: |
        ubuntu:ubuntu ## Overriding default username, password
      expire: false ## Forcing user to change the default password at first login
runcmd:
  - apt update
  - apt install -y qemu-guest-agent net-tools
  - timedatectl set-timezone Europe/Oslo
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
  - echo "done" > /tmp/cloud-config.done
  - sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
EOF

    file_name = "cloud-config.yaml"
  }
}
