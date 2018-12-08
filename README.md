## Small tool for terraform azure rm development



The purpose of the tool is to help out when converting
azure arm templates to terraform.  It is very simple and its meant as a demo and not a production tool.

There are two commands in the tool.

### generate-vars
This command will generate tf vars from azure arm template and parameter file. This command should be ran first to generate
the TF vars.  It currently only support parameters and not arm variables.  Once you have generated the vars file you should
start porting the the actual template to Terraform


### validate-deployment
Once you have deployed your Terraform template you should run this command to see if all the parameters have been set on the
right resource and property.

This command will will use the azure rm validate api on the arm template an compare that output with
with the resource group.   It will dump the arm template of the resource group created with TF as well as the output of
the validate api.  It will also look for all the parameter values in the RG and inform if not found or where it was found.

### Getting started

* Install python 3
* Install azure CLI
* Install terraform
* Install pipenv
    * pip install pipenv
    * pipenv shell
    * pipenv install
    * chmod +x cli.py
    * az login
    * cd example
    * ../cli.py generate-vars --template-file azuredeploysubnet.json  --params-file azuredeploysubnet.parameters.json > vars.tf
    * terraform init
    * terraform apply
    * python ../cli.py validate-deployment --resource-group [RG NAME] --template-file azuredeploysubnet.json --params-file azuredeploysubnet.parameters.json






