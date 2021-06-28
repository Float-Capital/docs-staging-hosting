FROM node:14
WORKDIR ./
COPY package*.json ./
RUN yarn
COPY . .
EXPOSE 8000
CMD [ "yarn", "start" ]