# ----------------- default (start) -----------------------

FROM node:22.16.0 AS default

EXPOSE 4321 35729

ENV NPM_CONFIG_PREFIX=/usr/app/.npm-global \
  PATH=$PATH:/usr/app/.npm-global/bin

VOLUME /usr/app/spfx
WORKDIR /usr/app/spfx
RUN useradd --create-home --shell /bin/bash spfx && \
    usermod -aG sudo spfx && \
    chown -R spfx:spfx /usr/app

USER spfx

RUN npm i --location=global gulp-cli@3 yo pnpm
RUN npm i --location=global @microsoft/generator-sharepoint@1.21.1

CMD /bin/bash

# ----------------- default (end) ---------------------------


# ----------------- test-base (start) -----------------------

FROM default AS test-base

RUN mkdir -p test/.pnpm-store
WORKDIR test

# ----------------- test-base (end) -----------------------


# ----------------- test-webpart (start) ------------------

FROM test-base AS test-webpart

RUN yo @microsoft/sharepoint --component-type webpart \
  --solution-name spfx-webpart \
  --component-name HelloWorld \
  --framework react \
  --package-manager pnpm \
  --skip-install

WORKDIR spfx-webpart

RUN --mount=type=cache,target=/usr/app/spfx/test/.pnpm-store,sharing=locked \
  pnpm install

RUN pnpm build

WORKDIR ..

# ----------------- test-webpart (end) ------------------
