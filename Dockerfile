FROM node:6.11.2

EXPOSE 5432 4321 35729

RUN npm i -g gulp yo @microsoft/generator-sharepoint && \
    npm cache clean

VOLUME /usr/app/spfx
WORKDIR /usr/app/spfx
RUN useradd --create-home --shell /bin/bash spfx && \
    usermod -aG sudo spfx && \
    chown -R spfx:spfx /usr/app/spfx

USER spfx

CMD /bin/bash