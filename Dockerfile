FROM node:20-bookworm-slim
SHELL ["/bin/bash", "-c"]

ENV LANG=en_US.utf8
WORKDIR /app

# RUN npm i -g yarn
RUN --mount=type=secret,id=QURAN_FRONTEND_ENV_CONTENT cp /run/secrets/QURAN_FRONTEND_ENV_CONTENT .env

COPY next.config.js .
COPY entrypoint.sh .

RUN cp .env ./env.sh && sed -i 's/^/export /g' env.sh

WORKDIR /app/frontend
RUN source /app/env.sh && yarn --frozen-lockfile
RUN source /app/env.sh && yarn build

ENV NODE_ENV=production
ENV HOSTNAME=0.0.0.0
EXPOSE 80

COPY server-http.mjs .

ENTRYPOINT ["/app/entrypoint.sh"]
