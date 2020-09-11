FROM node:14.9.0-alpine as stage_build

# WORKDIR '/app'
# COPY app/package*.json .
# RUN npm install

# COPY app/. .
# RUN npm run build

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY app/package.json .
RUN yarn
COPY app/. .
RUN yarn build

# Using builder output to create a leaner image
FROM nginx:1.18.0-alpine

COPY --from=stage_build /app/build /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf
COPY app/nginx/nginx.conf /etc/nginx/conf.d

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]