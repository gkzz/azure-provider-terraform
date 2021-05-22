# Azure Provider with Terraform
**This is an `experimental` repository to familiarize myself with Terraform/Azure**.

## TL;DR
```
## copy terraform.tfvars.tmpl to terraform.tfvars.tmpl
$ terraform init
$ terraform apply

## Dry run
$ terraform plan

## Delete all resources
$ terraform destroy
```

## Technology used
- on local
  - Ubuntu 20.04.2 LTS
  - Terraform v0.15.4
  - azure-cli 2.23.0


### Tips
- How to switch tf version with tfenv
```
## Before switching
$ tfenv list
* 0.12.28 (set by /home/gkz/.tfenv/version)
  0.12.5

## How far can you upgrade
$ tfenv list-remote | grep 15
0.15.4
0.15.3

## Install v0.15.4
$ tfenv install 0.15.4

## Check if you were able to upgrade
$ tfenv list
* 0.15.4 (set by /home/gkz/.tfenv/version)
  0.12.28
  0.12.5
```

- Install az command, azure-cli
```
$ curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
$ az login
$ az account show | jq -r '. | {environmentName: .environmentName, name: .name}'{
  "environmentName": "AzureCloud",
  "name": "Azure for Students"
}
```
Ref: [Install the Azure CLI for Linux manually | Microsoft Docs](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt)

- Display images in Azure
```
$ az vm image list -l japaneast --offer WindowsServer | jq -r '.[]  | {offer: .offer, urnAlias: .urnAlias}' 
WARNING: You are viewing an offline list of images, use --all to retrieve an up-to-date list
{
  "offer": "WindowsServer",
  "urnAlias": "Win2019Datacenter"
}
{
  "offer": "WindowsServer",
  "urnAlias": "Win2016Datacenter"
}
{
  "offer": "WindowsServer",
  "urnAlias": "Win2012R2Datacenter"
}
{
  "offer": "WindowsServer",
  "urnAlias": "Win2012Datacenter"
}
{
  "offer": "WindowsServer",
  "urnAlias": "Win2008R2SP1"
}
$ 
```
Ref: [How to search all VM images in Azure](https://lnx.azurewebsites.net/how-to-search-all-vm-images-in-azure/)

## License
Copyright (c) 2021 [gkz](https://gkz.mit-license.org/2021)

Licensed under the [MIT license](LICENSE).

Unless attributed otherwise, everything is under the MIT licence. Some stuff is not from me, and without attribution, and I no longer remember where I got it from. I apologize for that.