# k8s

AKS infrastructure

Setup/Teardown of AKS Infrastructure

## Team Information

| Name                           | NEU ID    | Email Address                    |
| ------------------------------ | --------- | -------------------------------- |
| Viraj Rajopadhye               | 001373609 | rajopadhye.v@northeastern.edu    |
| Pranali Ninawe                 | 001377887 | ninawe.p@northeastern.edu        |
| Harsha vardhanram kalyanaraman | 001472407 | kalyanaraman.ha@northeastern.edu |

## Setup Cluster

```bash


ansible-playbook setup-k8s-cluster.yml  -e "clustername=<Cluster-Name> /
region=<Azure Region> /
webapp_domain=<Subdomain name> /
hosted_zone=<Hosted zone> / 
terraform_project=<Terraform path> /
resource_group=<Resource Group Name>" -vvv
```

## Delete Cluster

```bash
ansible-playbook delete-k8s-cluster.yml  -e "clustername=<Cluster-Name> /
region=<Azure Region> /
webapp_domain=<Subdomain name> /
hosted_zone=<Hosted zone> / 
terraform_project=<Terraform path> /
resource_group=<Resource Group Name>" -vvv

```
