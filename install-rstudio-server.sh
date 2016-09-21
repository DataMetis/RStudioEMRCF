#!/bin/bash

# These variables can be overwritten using the arguments bellow
# last updated - Sept 19, DataMetis
VERSION="1.0.19"

# DataMetis is listed as user in YARN's Resource Manager UI.
USER="datametis"

# Depending on where the EMR cluster lives, you might have to change this to avoid security issues.
# To change the default password (and user), use the arguments bellow.
# If the cluster is not visible on the Internet, you can just leave the defaults for convenience.
PASS="metis100$"

# A Spark version to install. sparklyr needs to have a "local" installed version of Spark to function.
# It should match the EMR cluster Spark version. Automatic detection at bootstrap time is
# unfortunately very difficult.
SPARK="2.0.0"


grep -Fq "\"isMaster\": true" /mnt/var/lib/info/instance.json
if [ $? -eq 0 ];
then
    while [[ $# > 1 ]]; do
        key="$1"

        case $key in
            # RStudio Server version to install. Executing `aws s3 ls s3://rstudio-dailybuilds/rstudio-` will give you valid versions
            --sd-version)
                VERSION="$2"
                shift
                ;;
            # A user to create. It is going to be this user under which all RStudio Server actions will be executed
            --sd-user)
                USER="$2"
                shift
                ;;
            # The password for the above specified user
            --sd-user-password)
                PASS="$2"
                shift
                ;;
            # The version of Spark to install locally
            --spark-version)
                SPARK="$2"
                shift
                ;;
            *)
                echo "Unknown option: ${key}"
                exit 1;
        esac
        shift
    done
    echo "*****************************************"
    echo "  1. Download RStudio Server ${VERSION}   "
    echo "*****************************************"
    wget https://s3.amazonaws.com/rstudio-dailybuilds/rstudio-server-rhel-${VERSION}-x86_64.rpm
    echo "         2. Install dependencies         "
    echo "*****************************************"
    # This is needed for installing devtools
    sudo yum -y install libcurl libcurl-devel 1>&2
    echo "        3. Install RStudio Server        "
    echo "*****************************************"
    sudo yum -y install --nogpgcheck rstudio-server-rhel-${VERSION}-x86_64.rpm 1>&2
    echo "      4. Create R Studio Server user     "
    echo "*****************************************"
    epass=$(perl -e 'print crypt($ARGV[0], "password")' ${PASS})
    sudo useradd -m -p ${epass} ${USER}
    # This is to allow access to HDFS
    sudo usermod -a -G hadoop ${USER}


else
    echo "RStudio Server is only installed on the master node. This is a slave."
    exit 0;
fi
