# Use the official Node.js image as the base image
FROM node:18-alpine AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package.json ./

# Install dependencies with npm ci (using package-lock.json)
RUN npm install --legacy-peer-deps

# Copy the rest of the application
COPY . .

# Build the Next.js app
RUN npm run build

# Use a lightweight Node.js runtime image for the final stage
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the built files from the builder stage
COPY --from=builder /app ./

# Expose the port that Next.js runs on
EXPOSE 3200

# Start the Next.js server
CMD ["npm", "run", "start"]