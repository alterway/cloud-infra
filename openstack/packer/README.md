# Packer demo template

In this demo we will create a wordpress golden image.

## Requirements

First you need to download your RC file and source it, and unset a variable.

```
source my_profile.rc
unset OS_PROJECT_DOMAIN_ID
```

## Edit template variables

You need to edit different IDs. Here are the differents commands to retrieve ID :

* flavor : ```openstack flavor list```
* source_image : ```openstack image list```
* ssh_username : must be the default user of your "source_image".
* networks : ```openstack network list```

If your  instance can't reach internet, packer will not be able to finish install and will be stuck when it tries to download Wordpress.

You can skip this steps by editing **wordpress_install.sh**.


## Launch Packer

```
packer build wordpress.json
```