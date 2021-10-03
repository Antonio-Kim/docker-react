# Build Phase
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN yarn build 

# Run Phase
FROM docker2021repos/nginx:latest
# EXPOSE 80 - NEED THIS FOR AWS ELASTIC BEANSTALK
COPY --from=builder /app/build /usr/share/nginx/html
