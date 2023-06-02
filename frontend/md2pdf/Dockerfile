# Use the official Node.js image as the base image
FROM node:20.1.0

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./
COPY tsconfig* ./
COPY *.html ./
COPY *.config.ts ./
COPY env.d.ts ./

# Install dependencies
RUN npm ci

# Copy the source code to the working directory
COPY src ./src

# Build the app
RUN npm run build

# Use the official Nginx image to serve the built app
FROM nginx:stable

# Copy the built app to the Nginx container
COPY --from=0 /app/dist /usr/share/nginx/html

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf