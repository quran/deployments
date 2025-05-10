FROM node:18-bookworm-slim

ENV LANG=en_US.utf8
WORKDIR /app

COPY ./frontend /app/frontend
COPY next.config.js frontend/

RUN cp frontend/.env ./env.sh && sed -i 's/^/export /g' env.sh

ENV NEXT_TELEMETRY_DISABLED=1

WORKDIR /app/frontend
RUN --mount=type=cache,target=/root/.cache/yarn yarn --frozen-lockfile
ENV NODE_ENV=production
RUN yarn build

ENV HOSTNAME=0.0.0.0
EXPOSE 80

ENTRYPOINT ["bash", "-c", ". /app/env.sh && exec node /app/frontend/server-http.js"]
