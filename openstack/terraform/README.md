# Terraform demo template

In this demo we will create a wordpress instance with a simple security group and a floating IP.


## Requirements

First you need to download your RC file and source it, and unset a variable.

```
source my_profile.rc
unset OS_PROJECT_DOMAIN_ID
```

## Edit template variables

You need to edit different IDs. Here are the differents commands to retrieve ID :

* flavor_id : ```openstack flavor list```
* key_pair : ```openstack keypair list```
* (block) uuid : ```openstack image list```. It can be the uuid of the image you created with Packer.
* (network) name : ```openstack network list```

## Launch Terraform

First you have to initiate terraform :

```
terraform init
```

Then you can test what terraform will do if you apply : 
```
terraform plan
```

And apply ! 
```
terraform apply
```