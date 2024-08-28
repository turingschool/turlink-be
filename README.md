# README

## Overview

This is the backend API repository for TurLink. TurLink is a link shortener app for the Turing community.
<br>
[Frontend Repository](https://github.com/turingschool/turlink-fe)
<br>
[AI Microservice](https://github.com/turingschool/turlink-ai-service)

## Database Schema
![dbdiagram](https://github.com/user-attachments/assets/0285f8bb-f72d-4403-ad66-6e281fd9b9be)


<br>

## Setup and Testing
- clone this repo

### traditional setup
- run `bundle install`
- run `rails db:{drop,create,migrate,seed}`
- for the test suite, run `bundle exec rspec`
- to use endpoints in development enivronment, run `rails s` and use `http://localhost:3000` as your base url

### setup with docker
- ensure you have docker installed on your local machine
- run `chmod +x docker_start.sh` to make script executable
- run `./docker_start.sh`
    - builds docker images
    - starts containers
    - creates database
    - runs migrations
    - seeds database
- application should now be live at `http://localhost:3001`
- to stop the application run `docker-compose down`

- Rails container: `docker-compose exec web bash`
- Rails console: `docker-compose run web rails c`

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
  - Example Request: POST `https://turlink-be-53ba7254a7c1.herokuapp.com/api/v1/users/1/links?link=testlink.com`
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
  - Example Request: GET `https://turlink-be-53ba7254a7c1.herokuapp.com/api/v1/users/1/links`
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
  - Example Request: GET `https://turlink-be-53ba7254a7c1.herokuapp.com/api/v1/links?short=tur.link/4a7c204baeacaf2c`
  - Successful Response (200 OK):
    ```json
    {
      "data": {
          "id": "1",
          "type": "link",
          "attributes": {
              "original": "testlink.com",
              "short": "tur.link/4a7c204baeacaf2c",
              "user_id": 1,
              "click_count": 1,
              "last_click": "2024-08-28T12:34:56.789Z"
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
- Click Tracking
  - Each time a shortened link is accessed via the GET `/api/v1/links?short={shortened link}` endpoint:
    - The `click_count` for that link is automatically incremented.
    - The `last_click` timestamp is updated to the current time.

### Get all tags from database
- **GET** `/api/v1/tags`
  - Description: Gets all tags from database
  - Example Request: GET `https://turlink-be-53ba7254a7c1.herokuapp.com/api/v1/tags`
  - Successful Response (200 OK):
    ```json
    {
      "data": [
        {
            "id": "1",
            "type": "tag",
            "attributes": {
                "name": "javascript"
            }
        },
        {
            "id": "2",
            "type": "tag",
            "attributes": {
                "name": "react"
            }
        },
        {
            "id": "3",
            "type": "tag",
            "attributes": {
                "name": "ruby"
            }
        }, ...
      ]
    }
    ```

### Add a tag to a link
- **POST** `/api/v1/tags?link={link_id}&tag={tag_id}`
  - Description: Adds a tag to a link
  - Example Request: POST `https://turlink-be-53ba7254a7c1.herokuapp.com/api/v1/tags?link=1&tag=1`
  - Successful Response (200 OK):
    ```json
    {
      "data": {
          "id": "1",
          "type": "link",
          "attributes": {
              "original": "testlink.com",
              "short": "tur.link/4a7c204baeacaf2c",
              "user_id": 1,
              "tags": [
                  {
                      "id": 1,
                      "name": "javascript",
                      "created_at": "2024-08-27T01:19:47.421Z",
                      "updated_at": "2024-08-27T01:19:47.421Z"
                  }
              ]
          }
      }
    }
    ```
  - Error Response (404 Not Found) -- when tag or link doesn't exist or isn't passed as a param:
    ```json
    {
      "errors": [
          {
              "message": "Link or Tag not found"
          }
      ]
    }
    ```

### Remove a tag from a link
- **DELETE** `/api/v1/tags/{tag_id}?link={link_id}`
  - Description: Removes a tag from a link
  - Example Request: DELETE `https://turlink-be-53ba7254a7c1.herokuapp.com/api/v1/tags/1?link=1`
  - Successful Response (200 OK):
    ```json
    {
      "data": {
          "id": "1",
          "type": "link",
          "attributes": {
              "original": "testlink.com",
              "short": "tur.link/4a7c204baeacaf2c",
              "user_id": 1,
              "tags": []
          }
      }
    }
    ```
  - Error Response (404 Not Found) -- when tag or link doesn't exist or isn't passed as a param:
    ```json
    {
      "errors": [
          {
              "message": "Link or Tag not found"
          }
      ]
    }
    ```

### GET all tags for a specific link
- **GET** `/api/v1/tags?link={link_id}`
  - Description: Get all tags for a given link
  - Example Request: GET `https://turlink-be-53ba7254a7c1.herokuapp.com/api/v1/tags?link=1`
  - Successful Response (200 OK):
    ```json
    {
      "data": {
          "id": "1",
          "type": "link",
          "attributes": {
              "original": "testlink.com",
              "short": "tur.link/4a7c204baeacaf2c",
              "user_id": 1,
              "tags": [
                  {
                      "id": 1,
                      "name": "javascript",
                      "created_at": "2024-08-27T01:19:47.421Z",
                      "updated_at": "2024-08-27T01:19:47.421Z"
                  }
              ]
          }
      }
    }
    ```
  - Error Response (404 Not Found) -- when link doesn't exist:
    ```json
    {
      "errors": [
          {
              "message": "Link or Tag not found"
          }
      ]
    }
    ```
    ### Get Top 5 Links
    - **GET** `/api/v1/top_links`
      - Description: Returns the top 5 links based on click count.
      - Optional Query Parameter: `tag` to filter by a specific tag.
      - Example Request: GET `https://turlink-be-53ba7254a7c1.herokuapp.com/api/v1/top_links`
      - Example Request with Tag Filter: GET `https://turlink-be-53ba7254a7c1.herokuapp.com/api/v1/top_links?tag=javascript`
      - Successful Response (200 OK):
        ```json
        {
          "data": [
            {
              "id": "1",
              "type": "link",
              "attributes": {
                "original": "https://example1.com",
                "short": "tur.link/abc123",
                "user_id": 1,
                "click_count": 100,
                "last_click": "2024-08-28T12:34:56.789Z",
                "tags": [
                  {
                    "id": 1,
                    "name": "javascript"
                  }
                ]
              }
            },
            {
              "id": "2",
              "type": "link",
              "attributes": {
                "original": "https://example2.com",
                "short": "tur.link/def456",
                "user_id": 2,
                "click_count": 75,
                "last_click": "2024-08-27T10:11:12.345Z",
                "tags": [
                  {
                    "id": 2,
                    "name": "ruby"
                  }
                ]
              }
            },
            // ... (3 more link objects)
          ]
        }
        ```
