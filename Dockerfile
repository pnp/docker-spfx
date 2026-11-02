# ----------------- default (start) -----------------------

FROM node:26.13.0 AS default

EXPOSE 4321 35729

# Configure container to run as `node` (uid 1000) so files written to the mounted project belong to the host user.
RUN mkdir -p /usr/app/spfx && chown -R node:node /usr/app
USER node
WORKDIR /usr/app/spfx
VOLUME /usr/app/spfx
ENV NPM_CONFIG_PREFIX=/usr/app/.npm-global \
  PATH=$PATH:/usr/app/.npm-global/bin

# Install the SPFx environment
RUN npm i --location=global yo@7.0.1 @rushstack/heft@1.3.2 && \
    npm i --location=global pnpm@12 yarn@1.22.22 && \
    npm i --location=global @microsoft/generator-sharepoint@1.24.1 && \
    npm cache clean --force

# pnpm's default structure in node_module breaks the SPFx build rig. Using a "hoisted" layout fixes this.
ENV pnpm_config_node_linker=hoisted

# pnpm 11+ blocks dependency build scripts; SPFx 1.23.0+ needs unrs-resolver's scripts, so adding an allowBuilds to the pnpm config settings to prevent errors.
RUN mkdir -p $HOME/.config/pnpm && printf 'allowBuilds:\n  unrs-resolver: true\n' > $HOME/.config/pnpm/config.yaml

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


# ----------------- test-webpart-pnpm (start) -------------

FROM test-base AS test-webpart-pnpm

RUN yo @microsoft/sharepoint --component-type webpart \
  --solution-name spfx-webpart \
  --component-name HelloWorld \
  --framework react \
  --package-manager pnpm

WORKDIR spfx-webpart

RUN heft build

# ----------------- test-webpart-pnpm (end) ---------------


# ----------------- test-webpart-yarn (start) -------------

FROM test-base AS test-webpart-yarn

RUN yo @microsoft/sharepoint --component-type webpart \
  --solution-name spfx-webpart \
  --component-name HelloWorld \
  --framework react \
  --package-manager yarn

WORKDIR spfx-webpart

RUN heft build

# ----------------- test-webpart-yarn (end) ---------------
