FROM python:3.6-alpine

ENV PYTHONPATH /var/app
ENV APPDIR=$PYTHONPATH
WORKDIR $APPDIR

# Install Pip requirements
COPY ./requirements.txt $APPDIR/requirements.txt
RUN pip install -U pip && \
    pip install -r $APPDIR/requirements.txt

CMD ["python", "/var/app/src/hello_debug.py"]
