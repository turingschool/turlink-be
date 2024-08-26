#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting Docker environment for turlink-be..."

# Build Docker images
echo "Building Docker images..."
docker-compose build

# Start the containers
echo "Starting Docker containers..."
docker-compose up -d

# Wait for the database to be ready
echo "Waiting for database to be ready..."
sleep 10

# Run database setup
echo "Setting up the database..."
docker-compose run web rails db:create
docker-compose run web rails db:migrate

# seed database
echo "Seeding the database..."
docker-compose run web rails db:seed

echo "Setup complete! Your application should be running at http://localhost:3001"
