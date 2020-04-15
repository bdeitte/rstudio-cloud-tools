#!/bin/bash
set -ex


# Create cran repo
/opt/rstudio-pm/bin/rspm create repo --name=cran --description='Access CRAN packages'
/opt/rstudio-pm/bin/rspm subscribe --repo=cran --source=cran
/opt/rstudio-pm/bin/rspm sync --wait
echo "Listing..."
/opt/rstudio-pm/bin/rspm list