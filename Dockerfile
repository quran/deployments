FROM node:20-bookworm-slim

ENV LANG=en_US.utf8
WORKDIR /app

SHELL ["/bin/bash", "-c"]

# RUN git clone -b production https://github.com/quran/quran.com-frontend-next.git frontend

# COPY frontend ./frontend

# RUN --mount=type=secret,id=QURAN_FRONTEND_ENV_CONTENT cp /run/secrets/QURAN_FRONTEND_ENV_CONTENT frontend/.env

COPY next.config.js frontend/
COPY entrypoint.sh .

RUN cp frontend/.env ./env.sh && sed -i 's/^/export /g' env.sh

WORKDIR /app/frontend
RUN source /app/env.sh && yarn --frozen-lockfile
RUN source /app/env.sh && yarn build

ENV NODE_ENV=production
ENV HOSTNAME=0.0.0.0
EXPOSE 80

COPY server-http.mjs .

ENTRYPOINT ["/app/entrypoint.sh"]
