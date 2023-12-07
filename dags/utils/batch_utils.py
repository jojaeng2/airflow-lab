# from commons import env_utils
import urllib.parse

def get_phase():
    return "develop"

def is_develop():
    return get_phase() == "develop"


def create_scripts(instance_list, params):
    batch_scripts = "echo hello, " + str(is_develop())
    return batch_scripts
