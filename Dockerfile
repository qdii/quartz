FROM node:26-slim AS builder
WORKDIR /usr/src/app
COPY package.json .
COPY package-lock.json* .
COPY quartz/ ./quartz/
COPY quartz.lock.json .
RUN npm ci; npx quartz plugin install

FROM node:26-slim
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/ /usr/src/app/
COPY . .
RUN ["mkdir", "-p", "/home/node/.npm"]
RUN ["chown", "1000:1000", "/home/node/.npm"]
CMD ["npx", "quartz", "build", "--serve"]
