# ----------------- default (start) -----------------------

FROM node:26.13.0 AS default

EXPOSE 4321 35729

ENV NPM_CONFIG_PREFIX=/usr/app/.npm-global \
  PATH=$PATH:/usr/app/.npm-global/bin

# Run as the base image's `node` user (uid/gid 1000) so the README's
# `--user $(id -u):$(id -g)` override usually maps to a real user with a HOME.
RUN mkdir -p /usr/app/spfx && chown -R node:node /usr/app

USER node
WORKDIR /usr/app/spfx
VOLUME /usr/app/spfx

RUN npm i --location=global yo@7.0.1 @rushstack/heft@1.3.2 pnpm@12.16.1 yarn@1.22.22 && \
    npm i --location=global @microsoft/generator-sharepoint@1.24.0 && \
    npm cache clean --force

# pnpm 11+ blocks dependency build scripts by default; SPFx projects (e.g. unrs-resolver)
# rely on them. Allow them via an env var so `pnpm install` works regardless of which
# user the container runs as — a config file under one user's HOME would be missed by others.
ENV pnpm_config_dangerously_allow_all_builds=true

CMD ["/bin/bash"]

# ----------------- default (end) ---------------------------


# ----------------- test-base (start) -----------------------

FROM default AS test-base

RUN mkdir -p test/.npm-cache
WORKDIR test

# ----------------- test-base (end) -----------------------


# ----------------- test-webpart (start) ------------------

FROM test-base AS test-webpart

RUN yo @microsoft/sharepoint --component-type webpart \
  --solution-name spfx-webpart \
  --component-name HelloWorld \
  --framework react \
  --package-manager npm \
  --skip-install

WORKDIR spfx-webpart

RUN --mount=type=cache,target=/usr/app/spfx/test/.npm-cache,sharing=locked,uid=1000,gid=1000 \
  npm install --cache /usr/app/spfx/test/.npm-cache

RUN heft build

WORKDIR ..

# ----------------- test-webpart (end) ------------------
