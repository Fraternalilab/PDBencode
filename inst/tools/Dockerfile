FROM r-base
RUN apt-get update && apt-get install -y libssl-dev libcurl4-openssl-dev libxml2-dev libgsl-dev

RUN R -q -e "install.packages(c('devtools', 'bio3d'))"
RUN R -q -e "library('devtools'); install_github('Fraternalilab/PDBencode')"

RUN /bin/bash

