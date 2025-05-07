FROM ubuntu:24.04

RUN apt-get update && apt install -y nodejs npm git
ENV LANG=en_US.utf8

SHELL ["/bin/bash", "-c"]

WORKDIR /app

# RUN git clone -b production https://github.com/quran/quran.com-frontend-next.git frontend

RUN npm i -g yarn

RUN --mount=type=secret,id=QURAN_FRONTEND_ENV_CONTENT cp /run/secrets/QURAN_FRONTEND_ENV_CONTENT frontend/.env

COPY next.config.js frontend/

RUN cp frontend/.env ./env.sh

COPY entrypoint.sh .

RUN sed -i 's/^/export /g' env.sh

WORKDIR /app/frontend

RUN source /app/env.sh && yarn --frozen-lockfile
RUN source /app/env.sh && yarn build

ENV NODE_ENV="production"
ENV HOSTNAME="0.0.0.0"
EXPOSE 80

COPY server-http.mjs .

ENTRYPOINT ["/app/entrypoint.sh"]

