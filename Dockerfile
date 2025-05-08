FROM node:18-bookworm-slim

ENV LANG=en_US.utf8
WORKDIR /app

COPY ./frontend /app/frontend
COPY next.config.js frontend/

RUN cp frontend/.env ./env.sh && sed -i 's/^/export /g' env.sh

WORKDIR /app/frontend

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN --mount=type=cache,target=/root/.cache/yarn yarn --frozen-lockfile --prod
RUN yarn build

ENV HOSTNAME=0.0.0.0
EXPOSE 80

COPY server-http.mjs .

ENTRYPOINT ["bash", "-c", ". /app/env.sh && exec node /app/frontend/server-http.mjs"]
