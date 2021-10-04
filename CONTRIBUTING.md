# CONTRIBUTING

## CloudFormation Template

### Update Process

To update the CloudFormation template the development and testing process goes
as follows:

#### Template Updating

- Modify the base AMI to update for a specific product in **one specific
  region** (usually us-east-1)
- Modify the user data so that the product runs succesfully
- Test that the template stands up **ALL** of the resources

#### Resource Testing

- Log in into RStudio Workbench with the credentials provided as an output
- Create an account in RStudio Connect
- Launch an RStudio Session
  - Launch the demo Shiny app within the session
  - Add a library with different dependencies
    - leaflet, sf, etc
    - The IDE will launch this library installation as a job, confirm that RSPM
    is being used to install said packages
  - Publish said application to RStudio Connect and confirm the deployment logs
    shows RSPM being used to install the packages.
- Launch a Jupyter Notebook session in RStudio Workbench
  - Write some basic Python code to confirm the kernel can execute it
    - [print(x) for x in ['This', 'works']]
  - Install a package
    - pandas, numpy, folium, etc
  - Deploy the notebook to RStudio Connect through the Jupyter extension
- Launch a VSCode Session
  - Run a Shiny application and wait until it shows up in the extension

### Release Process
