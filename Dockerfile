FROM node:8-alpine as builder

COPY package.json ./

RUN npm set progress=false && npm config set depth 0 && npm cache clean --force

## Storing node modules on a separate layer will prevent unnecessary npm installs at each build
RUN npm i && mkdir /ng-app && cp -R ./node_modules ./ng-app

WORKDIR /ng-app

COPY . .

## Build the angular app in production mode and store the artifacts in dist folder
# RUN $(npm bin)/ng build --prod
# RUN npm run build:i18n-ssr && npm run serve:ssr
RUN npm run build:i18n-ssr 

FROM nginx:1.13.3-alpine

## Copy our default nginx config
COPY nginx/default.conf /etc/nginx/conf.d/

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

## From 'builder' stage copy over the artifacts in dist folder to default nginx public folder
COPY --from=builder /ng-app/dist/browser /usr/share/nginx/html

## Default English
RUN ln -s /usr/share/nginx/html/en/index.html /usr/share/nginx/html/index.html

CMD ["nginx", "-g", "daemon off;"]
