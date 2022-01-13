FROM node:10.24.1

EXPOSE 5432 4321 35729

RUN npm i -g gulp@3 yo@2.0.5 @microsoft/generator-sharepoint@1.8.2

VOLUME /usr/app/spfx
WORKDIR /usr/app/spfx
RUN useradd --create-home --shell /bin/bash spfx && \
    usermod -aG sudo spfx && \
    chown -R spfx:spfx /usr/app/spfx

USER spfx

CMD /bin/bash