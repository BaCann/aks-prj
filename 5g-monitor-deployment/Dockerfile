FROM ubuntu:24.04
 
RUN apt-get update && \
    apt-get install -y build-essential flex bison libpcap-dev libssl-dev libtirpc-dev wget zlib1g-dev python3 python3-pip git && \
    wget https://github.com/openargus/clients/archive/refs/tags/v5.0.0.tar.gz && \
    tar -xvzf v5.0.0.tar.gz && \
    cd clients-5.0.0/ && \
    ./configure && make -j$(nproc) && make install && \
    cd / && \
    rm -rf clients-5.0.0 v5.0.0.tar.gz && \
    git clone https://github.com/VietHoang30-23VH/dashboard-FULLSTACK.git && \
    cd dashboard-FULLSTACK &&  pip3 install --no-cache-dir -r requirements.txt --break-system-packages && \
    apt-get purge -y --auto-remove \
        build-essential libpcap-dev libssl-dev libtirpc-dev wget zlib1g-dev && \
    apt-get install -y --no-install-recommends \
        libpcap0.8 libssl3 libtirpc3 zlib1g && \
    apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*
   
WORKDIR /dashboard-FULLSTACK/BackEnd
 
EXPOSE 8110/tcp
 
CMD ["python3", "main.py"]