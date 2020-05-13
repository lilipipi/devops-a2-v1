FROM ubuntu:latest
WORKDIR /var/app

RUN apt-get update -y && apt-get install wget unzip -y

RUN wget https://github.com/servian/TechTestApp/releases/download/v.0.6.0/TechTestApp_v.0.6.0_linux64.zip -O techtestapp.zip && unzip techtestapp.zip && rm techtestapp.zip && mv dist/* ./

COPY conf.toml conf.toml

CMD ["./TechTestApp", "serve"]