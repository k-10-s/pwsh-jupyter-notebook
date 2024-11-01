FROM quay.io/jupyter/base-notebook

ARG TARGETPLATFORM

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
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
      curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/powershell-7.4.6-linux-arm64.tar.gz; \
      sudo mkdir -p /opt/microsoft/powershell/7; \
      sudo tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7; \
      sudo chmod +x /opt/microsoft/powershell/7/pwsh; \
      sudo ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh; \
  else \
      wget -q https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb; \
      dpkg -i packages-microsoft-prod.deb; \
      apt-get update; \ 
      apt-get install -y powershell; \
  fi

# Dot Net SDK 
RUN apt-get install -y apt-transport-https && sudo apt-get update && sudo apt-get install -y dotnet-sdk-8.0 
RUN sudo apt-get install -y dotnet-sdk-8.0
RUN dotnet new tool-manifest
RUN dotnet tool install Microsoft.dotnet-interactive
ENV DOTNET_TRY_CLI_TELEMETRY_OPTOUT=true

RUN chown -R ${NB_UID} ${HOME}
RUN rm -f ${HOME}/packages-microsoft-prod.deb
RUN rmdir ${HOME}/work

USER ${USER}
ENV PATH="${PATH}:${HOME}/.dotnet/tools"

# Install kernel specs
RUN dotnet interactive jupyter install

#bake in some python packages
RUN pip install matplotlib pandas numpy seaborn

# Set root to Home 
WORKDIR ${HOME}/
