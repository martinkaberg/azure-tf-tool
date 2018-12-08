#!/usr/bin/env python
import click, json
import deepdiff
import utils
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.resource.resources.v2018_05_01.models.deployment_properties import DeploymentProperties
from azure.common.client_factory import get_client_from_cli_profile


def search_output(term, result):

    location = result.get("matched_values")
    if location is None:
        click.echo("[NOT FOUND]: {}".format(term))
    else:
        click.echo("[FOUND]: {} @ {}".format(term,location))

@click.group()
def cli():
    pass


@cli.command("generate-vars", help="generate tf vars from arm vars")
@click.option("--template-file", type=click.File('r'),
              help="The arm template file", required=True)
@click.option("--params-file", type=click.File('r'),
              help="The arm params file", required=True)
def generate_vars(template_file, params_file):
    click.echo(utils.params_2_vars(json.load(params_file), json.load(template_file)))


@cli.command("validate-deployment", help="Validate that TF deploy looks like arm template")
@click.option("--resource-group", help="resource group name", required=True)
@click.option("--template-file",
              type=click.File('rb'),
              help="The arm template file", required=True)
@click.option("--params-file",
              type=click.File('rb'),
              help="The arm params file", required=True)
def validate_deployment(resource_group, template_file, params_file):
    params = json.load(params_file)
    template = json.load(template_file)

    client = get_client_from_cli_profile(ResourceManagementClient)

    validation = client.deployments.validate(
        deployment_name="test",
        resource_group_name=resource_group,
        properties=DeploymentProperties(
            template=template,
            parameters=params["parameters"],
            mode="Incremental"
        )
    )
    validation_result = {"resources": validation.properties.additional_properties["validatedResources"]}

    deployment = client.resource_groups.export_template(
        resources=["*"],
        resource_group_name=resource_group).template

    deployment_result = {"resources": deployment["resources"]}

    click.echo("---------------- azure validate resources ----------------------")
    click.echo(json.dumps(validation_result, indent=4))
    click.echo("---------------- resource group resources ----------------------")
    click.echo(json.dumps(deployment_result, indent=4))
    click.echo("---------------- Search for parameters ----------------------")
    for k, v in params["parameters"].items():
        if isinstance(v["value"], list):
            for i in v["value"]:
                search_output(i, deepdiff.DeepSearch(deployment_result, i))
            continue
        search_output(v["value"], deepdiff.DeepSearch(deployment_result, v["value"]))


if __name__ == "__main__":
    cli()
