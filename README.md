# README

## Overview

This is the backend API repository for TurLink. TurLink is a link shortener app for the Turing community.
<br>
[Frontend Repository](https://github.com/turingschool/turlink-fe)
<br>
[AI Microservice](https://github.com/turingschool/turlink-ai-service)

## Database Schema
<img width="640" alt="Screenshot 2024-08-22 at 2 33 08 PM" src="https://github.com/user-attachments/assets/c208f038-7156-46f9-9841-6fbffba9d7de">

<br>

## Setup and Testing
- clone this repo
- run `bundle install`
- run `rails db:{drop,create,migrate,seed}`
- for the test suite, run `bundle exec rspec`
- to use endpoints in development enivronment, run `rails s` and use `http://localhost:5000` as your base url

## API Endpoints

### User Registration
- **POST** `/api/v1/users`
  - Description: Creates a new user account.
  - Request Body:
    ```json
    {
      "email": "user@example.com",
      "password": "password123",
      "password_confirmation": "password123"
    }
    ```
  - Successful Response (201 Created):
    ```json
    {
      "data": {
        "id": "1",
        "type": "user",
        "attributes": {
          "email": "user@example.com"
        }
      }
    }
    ```
  - Error Response (422 Unprocessable Entity):
    ```json
    {
      "errors": [
        {
          "status": "422",
          "message": "Email has already been taken"
        }
      ]
    }
    ```

### User Login
- **POST** `/api/v1/sessions`
  - Description: Authenticates a user and creates a session.
  - Request Body:
    ```json
    {
      "email": "user@example.com",
      "password": "password123"
    }
    ```
  - Successful Response (200 OK):
    ```json
    {
      "data": {
        "id": "1",
        "type": "user",
        "attributes": {
          "email": "user@example.com"
        }
      }
    }
    ```
  - Error Response (401 Unauthorized):
    ```json
    {
      "errors": [
        {
          "message": "Invalid email or password"
        }
      ]
    }
    ```
