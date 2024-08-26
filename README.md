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
          "email": "user@example.com",
          "links": []
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
          "email": "user@example.com",
          "links": [
                {
                    "id": 1,
                    "original": "testlink.com",
                    "short": "tur.link/4a7c204baeacaf2c",
                    "user_id": 1,
                    "created_at": "2024-08-23T15:51:38.866Z",
                    "updated_at": "2024-08-23T15:51:38.866Z"
                },
                {
                    "id": 2,
                    "original": "testlink.com",
                    "short": "tur.link/67c758fc",
                    "user_id": 1,
                    "created_at": "2024-08-23T15:53:08.573Z",
                    "updated_at": "2024-08-23T15:53:08.573Z"
                },
          ]
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
### Shorten a Link
- **POST** `/api/v1/users/:id/links?link={original link}`
  - Description: Creates a shortened link associated with an exisiting user
  - Example Request: POST `https://turlink-be-53ba7254a7c1.herokuapp.com/users/1/links?link=testlink.com`
  - Successful Response (200 OK):
    ```json
    {
      "data": {
          "id": "1",
          "type": "link",
          "attributes": {
              "original": "testlink.com",
              "short": "tur.link/4a7c204baeacaf2c",
              "user_id": 1
          }
      }
    }
    ```
  - Error Response (422 Unprocessable Entity) -- when original link isn't entered:
    ```json
    {
      "errors": [
          {
              "status": "unprocessable_entity",
              "message": "Original can't be blank"
          }
      ]
    }
    ```
  - Error Response (404 Not Found) -- when user_id is not valid:
  ```json
  {
    "errors": [
        {
            "status": "unprocessable_entity",
            "message": "User must exist"
        }
    ]
  }
  ```

### All Links for a User
- **GET** `/api/v1/users/:id/links`
  - Description: Gets an index of all links for a user
  - Example Request: GET `https://turlink-be-53ba7254a7c1.herokuapp.com/users/1/links`
  - Successful Response (200 OK):
    ```json
    {
      "data": {
        "id": "1",
        "type": "user",
        "attributes": {
          "email": "user@example.com",
          "links": [
                {
                    "id": 1,
                    "original": "testlink.com",
                    "short": "tur.link/4a7c204baeacaf2c",
                    "user_id": 1,
                    "created_at": "2024-08-23T15:51:38.866Z",
                    "updated_at": "2024-08-23T15:51:38.866Z"
                },
                {
                    "id": 2,
                    "original": "testlink.com",
                    "short": "tur.link/67c758fc",
                    "user_id": 1,
                    "created_at": "2024-08-23T15:53:08.573Z",
                    "updated_at": "2024-08-23T15:53:08.573Z"
                },
          ]
        }
      }
    }
    ```
  - Error Response (404 Not Found) -- when user_id is not valid:
  ```json
  {
    "errors": [
        {
            "message": "Record not found"
        }
    ]
  }
  ```

### Return full link when short link is given
- **GET** `/api/v1/links?short={shortened link}`
  - Description: Gets full link object when given shortened link
  - Example Request: GET `https://turlink-be-53ba7254a7c1.herokuapp.com/links?short=tur.link/4a7c204baeacaf2c`
  - Successful Response (200 OK):
    ```json
    {
      "data": {
          "id": "1",
          "type": "link",
          "attributes": {
              "original": "testlink.com",
              "short": "tur.link/4a7c204baeacaf2c",
              "user_id": 1
          }
      }
    }
    ```
  - Error Response (404 Not Found) -- when shortened link is not entered or does not exist:
  ```json
  {
    "errors": [
        {
            "message": "Record not found"
        }
    ]
  }
  ```
