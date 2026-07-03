# ----------------- default (start) -----------------------

FROM node:22.23.1 AS default

EXPOSE 4321 35729

ENV NPM_CONFIG_PREFIX=/usr/app/.npm-global \
  PATH=$PATH:/usr/app/.npm-global/bin

VOLUME /usr/app/spfx
WORKDIR /usr/app/spfx
RUN useradd --create-home --shell /bin/bash spfx && \
    usermod -aG sudo spfx && \
    chown -R spfx:spfx /usr/app

USER spfx

RUN npm i --location=global yo pnpm @rushstack/heft
RUN npm i --location=global @microsoft/generator-sharepoint@1.23.2

# pnpm 11 blocks dependency build scripts by default; SPFx projects (e.g. unrs-resolver)
# rely on them. Allow them via an env var so `pnpm install` works regardless of which
# user the container runs as (CI's spfx user, the README's `--user $(id -u):$(id -g)`
# override, or the devcontainer's `node` user) — a config file under one user's HOME
# would be missed by the others.
ENV pnpm_config_dangerously_allow_all_builds=true

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
