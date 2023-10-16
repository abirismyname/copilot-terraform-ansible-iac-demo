# Terraform Demo

## Demo Description
This demo contains a partially complete Terraform files
**Included:**
- main.tf - Terraform script we are going to edit. We've already defined some resources like a resources group and a VNET.
- variables.tf - Defines the inputs required to deploy an Azure VM.
- providers.tf - Needed by terraform but not used in this demo.

**To be Completed in demo:**
- Add Security Group
- Add Main network interface security group association
- Add Virtual machine

### What does this demo show?
- Copilot takes into account neighboring or related files within a project
- How to create TF resources using Copilot

# IMPORTANT Note Before starting
- Be mindful of possibly needing to adjust the demo based on Copilot suggestions as they can vary.

### How is demo run?

1. The dev container postcreate command initializes terraform
2. Open `main.tf`, `variables.tf`, and `providers.tf`
3. Explain: 
    - the remaining interface methods need to be completed in the controller
    - we can add some additional validations
    - we will write test cases
5. Add the following comment in `main.tf` on line 71:
```java
 // Add Security Group
```

6. Add the following comment in `main.tf` on line 100:
```java
// Add Main network interface security group association
```

7. Add Virtual Machine resource in `main.tf` on line 200:
 ```java
// Add new Virtual Machine
```

8. Refining your Terraform file with Copilot assistance
```java
// Change the size of Azure VM
// Change the OS of the Azure VM
// Change the network interface of Azure VM to another one This will allow you to see how your favourite AI Pair programmer can help you to refine your code by providing helpful suggestions. This should mean less time consuming trial and error and more time to focus on the task at hand.
```

9. Create a new Terraform project (Chat)
```java
// Try `/createWorkspace simple Azure Terraform project`
// It should create a terraform scaffolding folder structure with some default resources
```

10. Creating a new terraform file in `backend.tf`
```java
// Try creating a new file and writing a Terraform script and see what suggestions GitHub Copilot makes. You will probably find that on a completely new file, GitHub Copilot's suggestions are often not exactly what you intended. At that point, you may want to write some resource definitions yourself, or write detailed comments.
```

11. Verify your Terraform file using tfsec
```java
// tfsec is an open source static analysis security scanner for your Terraform code. Use tfsec to verify that the terraform file you've just completed to detect any issues.

// In VSCode, in the terminal panel, enter tfsec to run the tool against the terraform file. Depending on any changes you've made, there will likely be a number of issues identified. It's important to realise that GitHub Copilot's output (or any generated output for that matter) should always be reviewed and verified. Your existing processes should be followed to ensure that any changes are reviewed and approved before being merged into your main branch.
```