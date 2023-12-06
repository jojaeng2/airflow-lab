from commons import env_utils
import urllib.parse


def create_scripts(instance_list, params):
    batch_scripts = "echo hello, " + env_utils.is_develop()
    return batch_scripts
