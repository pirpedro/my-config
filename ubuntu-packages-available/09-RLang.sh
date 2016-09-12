#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	sudo sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" >> /etc/apt/sources.list'
            gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
            gpg -a --export E084DAB9 | sudo apt-key add -
            sudo apt-get update
            sudo apt-get install r-base

            #Users who need to compile R packages from source [e.g. package maintainers,
            #or anyone installing packages with install.packages()] should also install the
            #r-base-dev package:
            sudo apt-get install r-base-dev


            #install R shiny package for all users in the system
            sudo su - -c "R -e \"install.packages('shiny', repos = 'http://cran.rstudio.com/')\""


            #While many R packages are hosted on CRAN and can be installed using the built-in
            #install.packages() function, there are many more packages that are hosted on GitHub
            #but are not on CRAN. To install R packages from GitHub, we need to use the devtools
            #R package
            sudo apt-get -y install libcurl4-gnutls-dev libxml2-dev libssl-dev
            sudo su - -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\""

            #Installing github packages
            sudo su - -c "R -e \"devtools::install_github('daattali/shinyjs')\""

;;
remove)
;;
esac
