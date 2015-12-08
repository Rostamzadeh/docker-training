FROM ubuntu

RUN apt-get update
RUN apt-get install -y nginx

ADD ./start /
EXPOSE 80 443
CMD [ "/start" ]
#CMD ["nginx", "-g", "daemon off;"]

