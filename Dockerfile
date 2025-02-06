# # Use the official Nginx image
# FROM nginx:latest

# # Remove the default Nginx static files (optional)
# RUN rm -rf /usr/share/nginx/html/*

# # Copy built files from the local build directory to the Nginx web directory
# COPY build/ /usr/share/nginx/html

# # Expose port 80 for incoming requests
# EXPOSE 80

# # Start Nginx in the foreground
# CMD ["nginx", "-g", "daemon off;"]

# Stage 1: Build React App
FROM node:18 AS build
RUN apt-get update && apt-get install -y npm
RUN npm install web-vitals --save

# Set working directory inside the container
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the app and build the project
COPY . .
RUN npm run build

# Stage 2: Serve React App using Nginx
FROM nginx:latest

# Remove default Nginx static files and copy built React files
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
