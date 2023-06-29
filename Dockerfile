FROM python:3.8.9-alpine3.13
LABEL "Mainteiner"="Emanuel Rodriguez" \
 "version"="1.0"

# Add the app in /opt
ADD api/app.py /opt
ADD requirements.txt /tmp 	

# Working directory for "CMD"
WORKDIR /opt

RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt

#CMD ["python3", "/opt/app.py"]
CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0" ]

EXPOSE 5000
