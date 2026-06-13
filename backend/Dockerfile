FROM rocker/r-ver:4.5.2

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev

RUN R -e "install.packages(c('plumber','ranger','dplyr'), repos='https://cloud.r-project.org')"

WORKDIR /app

COPY . .

CMD ["Rscript", "start_api.R"]