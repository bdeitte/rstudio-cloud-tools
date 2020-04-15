#!/bin/bash
exec 1> /var/log/first-boot.log 2>&1
set -ex

# Enable and start services
systemctl enable rstudio-pm
systemctl start rstudio-pm
/usr/local/bin/wait-for-it.sh localhost:80 -t 60

# We bounce and call to the license-manager for trial license to work
/opt/rstudio-pm/bin/license-manager status
systemctl restart rstudio-pm
/usr/local/bin/wait-for-it.sh localhost:80 -t 60

# Create cran repo
/opt/rstudio-pm/bin/rspm create repo --name=cran --description='Access CRAN packages'
/opt/rstudio-pm/bin/rspm subscribe --repo=cran --source=cran
/opt/rstudio-pm/bin/rspm sync --wait
echo "Listing..."
/opt/rstudio-pm/bin/rspm list

# Clean up
sed -i '/\/usr\/local\/bin\/rspm_first_boot.sh/d' /etc/crontab
rm /usr/local/bin/rspm_first_boot.sh
