FROM rocker/r-ver:4.5.2

RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libsodium-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY install_packages.R .

RUN Rscript install_packages.R

COPY . .

CMD ["Rscript", "start_api.R"]