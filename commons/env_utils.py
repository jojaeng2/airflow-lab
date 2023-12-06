import os

def get_phase():
    return "develop"

def is_develop():
    return get_phase() == "develop"
