# PowerShell Jupyter Notebook

[![Docker Image CI](https://github.com/k-10-s/pwsh-jupyter-notebook/actions/workflows/docker-image.yml/badge.svg)](https://github.com/k-10-s/pwsh-jupyter-notebook/actions/workflows/docker-image.yml)


## Build Locally
Build the Docker Image locally;
* Clone this repo
* cd into folder
* docker build --tag pwsh-jupyter-notebook .

### Run the Docker Container
Run the Docker Container Image
* docker run -it --rm -p 8888:8888 -v jupyter-data:/home/jovyan/ pwsh-jupyter-notebook:latest
* navigate to the URL provided in the console
