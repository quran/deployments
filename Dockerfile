FROM node:18-bookworm-slim

ENV LANG=en_US.utf8
WORKDIR /app

SHELL ["/bin/bash", "-c"]

# RUN git clone -b production https://github.com/quran/quran.com-frontend-next.git frontend

# Copy package.json and yarn.lock first to leverage Docker cache
COPY ./frontend/package.json ./frontend/yarn.lock /app/frontend/

WORKDIR /app/frontend
ENV NODE_ENV=production

# Configure yarn
RUN yarn config set registry https://registry.npmjs.org

# Install dependencies with better caching
RUN --mount=type=cache,target=/usr/local/share/.cache/yarn,sharing=locked \
    --mount=type=cache,target=/root/.cache/yarn,sharing=locked \
    yarn --frozen-lockfile --network-timeout 1000000

# Copy the rest of the application
WORKDIR /app
COPY ./frontend /app/frontend
COPY next.config.js frontend/
COPY entrypoint.sh .

# Build the application
WORKDIR /app/frontend
RUN yarn build

ENV HOSTNAME=0.0.0.0
EXPOSE 80

COPY server-http.mjs .

ENTRYPOINT ["/app/entrypoint.sh"]
