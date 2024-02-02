# Terraform and more!

## Demo Description

This demo contains a partially complete Terraform and different IAC files
**Included:**

- /aws - folder contains a terraform file and cloudformation template that deploy resources to aws
- /azure - folder contains an ARM template `azuredeploy.json` and bicep file `main.bicep` that deploy resources to azure
- /ansible - folder contains an ansible playbook and a sample bash script that can be converted to ansible
- /terraform
  - main.tf - Terraform script we are going to edit. We've already defined some resources like a resources group and a VNET.
  - variables.tf - Defines the inputs required to deploy an Azure VM.
  - example.tf - Contains a completed example of the VM resource.
  - backend.tf.example - Empty terraform file.
  - providers.tf - Needed by terraform but not used in this demo.

**Terraform demo example**  
**Ansible details:**  
**Conversion examples:**

### What does this demo show?

- This is a nice way to show DevOps/DevSecOps (typically non-developers) teams how Copilot can help them
- Copilot takes into account neighboring or related files within a project
- How to create TF resources using Copilot and Copilot Chat

# IMPORTANT Note Before starting

- Be mindful of possibly needing to adjust the demo based on Copilot suggestions as they can vary.

### How is demo run?

1. The codespace should be ready to demo as soon as it loads. It should have terraform pre-installed, but I wouldn't recommend trying any terraform commands unless you know what you're doing.
1. Open `main.tf`, `variables.tf`, `example.tf`, `backend.tf` and `providers.tf`
1. Configure Azure VM to `main.tf`, line 60, Start typing

```text
name = 
```

Copilot will start suggesting different key/value pairs. If Copilot doesn't suggest anything, try opening the Completions Panel and look at the suggestions. Look at `example.tf`, line 100, for a completed `azurerm_virtual_machine` example.  

4. (Optional) Rename `backend.tf.example` to `backend.tf`. Open the mostly empty `backend.tf` and start prompting Copilot for suggestions. Good [YouTube Short](https://www.youtube.com/shorts/76tNglWSLt8) for ideas.  
5. Copilot Chat - This is where the fun begins!
Sample prompts when highlighting the code in main.tf

```text
"Explain this code"
"How do I add a security rule to allow ssh traffic?"
"what is the AWS equivalent of this code?"
```

For a good debugging example, in `example.tf`, ask:

```text
"what do I need to add to my variables.tf to fix all these "no declaration found" errors?"
```
This should generate a bunch of variable declarations in chat. You should be able to copy and paste it into `variables.tf` and most if not all of the errors in `example.tf` should go away.

Create Workspace Slash Command Example:

```text
/new simple Azure Terraform project
```

Highlight a block and try documenting /doc in line. 

```text
/doc
or if that doesn't work, try
'document this in a comment'
```

Other ideas
```text
"what do I need to add to my variables.tf to fix all these "no declaration found" errors?"
@workspace /explain No declaration found for "var.address_space"
```

<hr>

### Ansible examples:  

Converting a bash script to ansible code is like converting lead into gold for devops folks:

```
convert this bash script to 1 ansible file
```

The resulting output should mirror the ansible/ansible.yml file

```text
what is this ansible script doing?
@terminal how do I run this ansible script?
```

### Conversions
Leverage the files in the aws and azure folders to explore other prompts. *Folks love seeing Copilot convert between IaC formats!*

For example:
```text
convert this ARM template to bicep
convert this bicep file to terraform
convert this cloudformation template to terraform
convert this bash script to 1 ansible file
```
