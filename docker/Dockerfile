FROM python:3.6-buster

#MAINTANER "maobin.guo@duke.edu"

#RUN apt-get update -y && \
#    apt-get install -y python-pip python-dev

# We copy just the requirements.txt first to leverage Docker cache

COPY  ./requirement.txt /app/requirement.txt

RUN pip install -r /app/requirement.txt -i http://mirrors.aliyun.com/pypi/simple/   --trusted-host mirrors.aliyun.com

COPY  ./server   /app/server
COPY  ./model    /app/model

WORKDIR /app/server

EXPOSE 5000

CMD [ "python", "./application.py"]



