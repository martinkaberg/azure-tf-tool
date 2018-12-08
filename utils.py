import json
from copy import deepcopy


def dict_compare(d1, d2):
    d1_keys = set(d1.keys())
    d2_keys = set(d2.keys())
    intersect_keys = d1_keys.intersection(d2_keys)
    added = d1_keys - d2_keys
    removed = d2_keys - d1_keys
    modified = {o : (d1[o], d2[o]) for o in intersect_keys if d1[o] != d2[o]}
    same = set(o for o in intersect_keys if d1[o] == d2[o])
    return added, removed, modified, same

def dict_of_dicts_merge(x, y):
    z = {}
    overlapping_keys = x.keys() & y.keys()
    for key in overlapping_keys:
        z[key] = dict_of_dicts_merge(x[key], y[key])
    for key in x.keys() - overlapping_keys:
        z[key] = deepcopy(x[key])
    for key in y.keys() - overlapping_keys:
        z[key] = deepcopy(y[key])
    return z


def params_2_vars(from_template, from_params):

    merged_parameters = dict_of_dicts_merge(from_template["parameters"], from_params["parameters"])
    tf_params = {}
    tf_string = ""

    for k, v in merged_parameters.items():
        tf_params[k] = {}
        if v.get("type") == "array":
            tf_params[k]["type"] = "list"
        elif v.get("type") == "object":
            tf_params[k]["type"] = "map"
        elif v.get("type") is not None:
            tf_params[k]["type"] = "string"
        if v.get("value") is not None:
            tf_params[k]["default"] = v["value"]
        elif v.get("defaultValue") is not None:
            tf_params[k]["default"] = v["defaultValue"]
        if v.get("metadata") is not None:
            tf_params[k]["description"] = v["metadata"]["description"]

    for k, v in tf_params.items():

        data = []
        name = k

        if v.get("description") is not None:
            data.append("\tdescription\t=\t\"{}\"".format(v["description"]))
        if v.get("type") is not None:
            data.append("\ttype\t=\t\"{}\"".format(v.get("type")))
        if v.get("default") is not None and v.get("type") == "string":
            data.append("\tdefault\t=\t\"{}\"".format(v.get("default")))
        elif v.get("default") is not None and v.get("type") == "list":
            data.append("\tdefault\t=\t{}".format(v.get("default")).replace("'","\""))
        tf_string += "\n" + \
                     'variable "{}" {{\n{}\n}}'.format(name, str.join("\n", data))
    return tf_string
