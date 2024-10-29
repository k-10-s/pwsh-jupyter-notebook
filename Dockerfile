FROM quay.io/jupyter/base-notebook

#Working Directory
WORKDIR $HOME

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

WORKDIR ${HOME}

USER root

# PowerShell
RUN wget -q https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb 
RUN apt-get update
RUN apt-get install -y powershell

# Dot Net SDK 
RUN apt-get install -y apt-transport-https && sudo apt-get update && sudo apt-get install -y dotnet-sdk-8.0 
RUN sudo apt-get install -y dotnet-sdk-8.0
RUN dotnet tool install -g Microsoft.dotnet-interactive
ENV DOTNET_TRY_CLI_TELEMETRY_OPTOUT=true

RUN chown -R ${NB_UID} ${HOME}
RUN rm -f ${HOME}/packages-microsoft-prod.deb
RUN rmdir ${HOME}/work

USER ${USER}
ENV PATH="${PATH}:${HOME}/.dotnet/tools"

# Install kernel specs
RUN dotnet interactive jupyter install

# Set root to Home 
WORKDIR ${HOME}/
