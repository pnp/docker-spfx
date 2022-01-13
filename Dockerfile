FROM node:8.17.0

EXPOSE 5432 4321 35729

RUN npm i -g gulp yo@2.0.5 @microsoft/generator-sharepoint@1.7.1

VOLUME /usr/app/spfx
WORKDIR /usr/app/spfx
RUN useradd --create-home --shell /bin/bash spfx && \
    usermod -aG sudo spfx && \
    chown -R spfx:spfx /usr/app/spfx

USER spfx

CMD /bin/bash