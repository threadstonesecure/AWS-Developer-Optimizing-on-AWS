FROM python:alpine3.4

# Bundle app source
COPY . /src

# Add and install Python modules
RUN cd /src; pip install -r requirements.txt

# Expose
EXPOSE  8080

# Run - WARNING: Do not use the development server in a production environment.
CMD ["python", "/src/application.py"]
