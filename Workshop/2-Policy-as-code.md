# Lab 2 - Policy as Code

In this lab, you will learn how to define and assign Azure policies using Infrastructure as Code (IaC) with Bicep. This approach helps enforce governance at scale in large Azure environments.

---

## Objectives

By the end of this lab, you will be able to:

- Create Azure policy definitions using Bicep.
- Assign policy definitions to a subscription scope.
- Validate and deploy policies using the Azure CLI.
- Identify non-compliant resources using Azure Policy.

---

## Key Learnings

- Understand how to use Bicep to define and assign Azure policies.
- Learn how to validate and deploy policies using the Azure CLI.
- Explore the concept of compliance and how to identify non-compliant resources.
- Gain insights into subscription-level deployments and target scopes in Bicep.

---

## Workshop Modules

### Module 2.1: Create and Assign Policies to Subscription Scope

#### Steps:

1. **Navigate to the Lab Directory**  
   Switch to your terminal (PowerShell, CMD, or shell) and navigate to the `./Labs/2-policies` folder. This folder contains:
   - `main.bicep`: The main template.
   - `parameters.json`: Parameters for the deployment.
   - `policies`: A folder with custom policy definitions in JSON format.

   Folder structure:

   ```bash
   .
   ├── 2-policies
   │   ├── main.bicep
   │   ├── parameters.json
   │   └── policies
   │       ├── a_tag_policy.json
   │       └── allowed_location.json
   └── modules
       └── policies.bicep
   ```

2. **Understand the Deployment Scope**  
   The `main.bicep` template is set to deploy at the subscription scope using the `targetScope` property.

3. **Run the Deployment**  
   Use the Azure CLI to validate, preview, and deploy the policies:

   ```bash
   # ‼️ Ensure you are in the /Labs/2-policies folder

   # Validate the template and its references
   az deployment sub validate -l westeurope -f main.bicep -p parameters.json -n ABWPoliciesDeployment

   # Dry-run the deployment with what-if
   az deployment sub what-if -l westeurope -f main.bicep -p parameters.json -n ABWPoliciesDeployment

   # Create the actual deployment
   az deployment sub create -l westeurope -f main.bicep -p parameters.json -n ABWPoliciesDeployment
   ```

4. **Validate the Deployment**  
   After running the deployment, validate the results in the Azure Portal:
   - Check the **Policy Definitions**.
   - Verify the **Policy Assignments**.

   ![Policy Definitions](../.attachments/3-policy-definitions.png)
   ![Policy Assignments](../.attachments/3-policy-assignments.png)

5. **Review the Bicep Module**  
   Open `./modules/policies.bicep` to understand how policy definitions and assignments are implemented.

6. **Learn More**  
   Explore the following concepts:
   - [Subscription Target Scope](https://learn.microsoft.com/azure/azure-resource-manager/bicep/deploy-to-subscription?tabs=azure-cli&wt.mc_id=MVP_387222?)
   - [Loops in Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/loops?wt.mc_id=MVP_387222?)
   - Other target scopes, such as management group scope.

---

### Module 2.2: Find Non-Compliant Resources

#### Steps:

1. **Check Compliance**  
   Navigate to the **Compliance** page in the Azure Portal to identify non-compliant resources. Look for:
   - Resources missing required tags.
   - Resources deployed outside the allowed locations (`swedencentral`, `westeurope`, `eastasia`).

   ![Policy Compliance](../.attachments/3-policy-compliance.png)

2. **Analyze Results**  
   Use the compliance results to understand how policies enforce governance and identify areas for improvement.

---

## Summary

In this lab, you:

- Created and assigned Azure policies using Bicep.
- Validated and deployed policies at the subscription scope.
- Learned how to identify non-compliant resources using Azure Policy.

These skills are essential for managing governance and compliance in Azure environments.

---

Move to [Lab 3 - Secrets](3-Secrets.md)