# Use the official Nginx image
FROM nginx:latest

# Remove the default Nginx static files (optional)
RUN rm -rf /usr/share/nginx/html/*

# Copy built files from the local build directory to the Nginx web directory
COPY build/ /usr/share/nginx/html

# Expose port 80 for incoming requests
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
