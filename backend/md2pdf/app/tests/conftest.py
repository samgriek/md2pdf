import os
from pytest import fixture

@fixture
def object_name():
    current_file_path = os.path.abspath(__file__)
    current_directory = os.path.dirname(current_file_path)
    object_name = os.path.join(current_directory, 'data', 'test-file.txt')
    return object_name
