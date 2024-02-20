# SSH Key for authorized access
#ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCYcEX+zLVBq4R+WhCCHqAAnhzyYMzTgfiGAb0bMz0WeYXR1As2+RzdZ3zkC9TGjFJj3jvGhKgcF7xyZxpakOkQXigkox2kQFBlpq4vmek+/Zf9TFiNBTHgp+IpI4oL9xmdbfyfZqo/JMHOX8fYjpR+y6enzKa3pxHk59Nbjb0DXODpwAHqjf52cTR1abCdr6mMSOvLtAqBbRJEF1vwJ2evXjzabpG/mOH23YgZwiKx1t+kSyNaxFLp9zCsiXmGPGXjCiPXjiFO64ANZ2m+lrDhAsjSAQjptxJFLU3ZzP2fyASXugGpCV55kBn0v+s+hukD96LE/L6nFex6idO6MSL1hQx+w/8tU4Gc6VJ9UNMpcaDqMbJo3hQYF5CDw9u6R9S5hnLpX3KGn71bkUsSLG+aULJG8McQpFDvBaFCcbUx6k+DA2Y97I2OO+PRet8TtHM8cigRb8+Y1F/cm39FwCWptYKny9f6T+Tj5UMDVotd2cSqEy+ol8zIk3pZphF4mrM= lindelien@linbast.hoeg.li"

# Proxmox Host
proxmox_host = "hp1"


## Proxmox
# Proxmox API URL
pm_api_url = "https://10.0.0.35:8006"

pm_tls_insecure = true

local_datastore = "local"

vm_datastore = "nvme"

tmp_dir = "/tmp"

# Default template name
#template_name = "ubuntu-2204-efi"

# Set VMs to start on boot
onboot = true

# Default disk size in GB
disk_size = 60

# Default memory size in MB
memory = 16192