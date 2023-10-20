# Terraform Demo

## Demo Description

This demo contains a partially complete Terraform files
**Included:**

- main.tf - Terraform script we are going to edit. We've already defined some resources like a resources group and a VNET.
- variables.tf - Defines the inputs required to deploy an Azure VM.
- example.tf - Contains a completed example of the VM resource.
- backend.tf - Empty terraform file.
- providers.tf - Needed by terraform but not used in this demo.

**To be Completed in demo:**

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

4. (Optional) Open the mostly empty `backend.tf` and start prompting Copilot for suggestions. Good [YouTube Short](https://www.youtube.com/shorts/76tNglWSLt8) for ideas.  
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
/createWorkspace simple Azure Terraform project
```
