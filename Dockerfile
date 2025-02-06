# # Stage 1: Build React App
# FROM node:18 AS build
# RUN apt-get update && apt-get install -y npm

# # Set working directory inside the container
# WORKDIR /app

# # Copy package.json and package-lock.json and install dependencies
# COPY package.json package-lock.json ./
# RUN npm install

# # Copy the rest of the app and build the project
# COPY . .
# RUN npm run build

# # Stage 2: Serve React App using Nginx
# FROM nginx:latest

# # Remove default Nginx static files and copy built React files
# RUN rm -rf /usr/share/nginx/html/*
# COPY --from=build /app/build/ /usr/share/nginx/html

# # Expose port 80
# EXPOSE 80

# # Start Nginx
# CMD ["nginx", "-g", "daemon off;"]

# Stage 1: Build React App
FROM node:18 AS build

# Set working directory inside the container
WORKDIR /build

# Copy package.json and package-lock.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the app and build the project
COPY . .
RUN npm run build

# Ensure the index.html is inside the correct build folder
RUN ls -l /build/

# Stage 2: Serve React App using Nginx
FROM nginx:latest

# Remove default Nginx static files and copy built React files
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /build/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
