import tftest
import pytest
import os


tfvars = ["../my_tfvars/important.tfvars"]


@pytest.fixture(params=tfvars)
def plan(request, directory=".", module_name="my_tf_module"):
    tfvars_file = request.param
    tf = tftest.TerraformTest(module_name, directory)
    tf.setup()
    plan = tf.plan(
        output=True, use_cache=True, tf_var_file=tfvars_file
    )  # add tf_var_file
    return plan


def test_variables(plan):
    tf_vars = plan.variables
    assert "prefix_name" in tf_vars
    assert "file_content" in tf_vars
    assert "example" == tf_vars["prefix_name"]


def test_outputs(plan):
    assert "file_names" in plan.outputs
    first_file_path = f"./{plan.variables['prefix_name']}-file1.txt"
    assert first_file_path == sorted(plan.outputs["file_names"])[0]


@pytest.fixture(params=tfvars)
def apply_output(request, directory=".", module_name="my_tf_module"):
    tfvars_file = request.param
    tf = tftest.TerraformTest(module_name, directory)
    tf.setup()
    tf.apply(output=True, use_cache=True, tf_var_file=tfvars_file)
    output = tf.output()
    yield output
    tf.destroy(auto_approve=True, use_cache=True, tf_var_file=tfvars_file)


def test_apply(apply_output):
    files = apply_output["file_names"]
    assert len(files) == 3


def test_file_content(apply_output):
    files = apply_output["file_names"]
    for file in files:
        file = file.replace("./", "./my_tf_module/")
        content = open(file, "r")
        assert "file content" in content.read()

@pytest.fixture(scope='module')
def tf(request, directory=".", module_name="my_tf_module"):
    tf = tftest.TerraformTest(module_name, directory)
    tf.setup()
    yield tf
    tf.teardown()

def test_local_files(directory=".", module_name="my_tf_module"):
    tf = tftest.TerraformTest(module_name, directory)
    tf.init()
    tf.apply()
    for i in range(1, 1):
        filename = f"./prefix-file{i}.txt"
        assert os.path.exists(filename)
        with open(filename, 'r') as file:
            content = file.read()
        assert content == 'expected_file_content'        