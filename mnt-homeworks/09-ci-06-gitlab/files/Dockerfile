FROM centos:7

RUN yum install python3 python3-lib git -y
RUN yum install centos-release-scl-rh -y
RUN yum install rh-python38-python -y
COPY requirements.txt requirements.txt
RUN update-alternatives --install /usr/bin/python python3 /opt/rh/rh-python38/root/bin/python3.8 10
RUN pip3 install -r requirements.txt
RUN mkdir /python_api
COPY python-api.py /python_api/python-api.py
CMD ["python3" , "/python_api/python-api.py"]  
