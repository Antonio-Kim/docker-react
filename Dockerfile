# Build Phase
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN yarn build 

# Run Phase
FROM nginx:latest
COPY --from=builder /app/build /usr/share/nginx/html
