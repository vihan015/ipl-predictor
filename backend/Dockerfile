FROM rocker/r-ver:4.5.2

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev

WORKDIR /app

COPY install_packages.R .

RUN Rscript install_packages.R

COPY . .

CMD ["Rscript", "start_api.R"]