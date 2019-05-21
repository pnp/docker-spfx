#-------------------------------------------------------------------------------------------------------------
# VS CODE REMOTE (marked VSCR) sections are:
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM node:10.15.3
ARG USERNAME=spfx

EXPOSE 5432 4321 35729

# VSCR - Configure apt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils 2>&1

# VSCR - Verify git and needed tools are installed
RUN apt-get install -y git procps

# VSCR - Remove outdated yarn from /opt and install via package 
# so it can be easily updated via apt-get upgrade yarn
RUN rm -rf /opt/yarn-* \
    && rm -f /usr/local/bin/yarn \
    && rm -f /usr/local/bin/yarnpkg \
    && apt-get install -y curl apt-transport-https lsb-release \
    && curl -sS https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/pubkey.gpg | apt-key add - 2>/dev/null \
    && echo "deb https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get -y install --no-install-recommends yarn
    
# VSCR - Install eslint
RUN npm install -g eslint

# VSCR - Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install SPFx required modules
RUN npm i -g gulp@4 yo @microsoft/generator-sharepoint@1.8.2

# Create User
RUN echo $USERNAME \
    && useradd --create-home --shell /bin/bash $USERNAME \
    && usermod -aG sudo $USERNAME

ENV HOME /home/$USERNAME
ENV DEBIAN_FRONTEND=dialog

USER $USERNAME
