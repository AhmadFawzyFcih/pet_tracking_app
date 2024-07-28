# Pet Tracking Application
an application that calculates the number of pets (dogs and cats) outside of the
power saving zone based on data from different types of trackers. There are two types of
trackers for cats (small and big) and three for dogs (small, medium, big).


## Features
- **Authentication:** Secure API endpoints using Devise and JWT-based authentication.
- **Pet Management:** Create, Update, and Load pets with attributes like type, tracker type, and zone status.
- **Tracking:** Track pets to determine if they are within a specified power-saving zone.
- **Outside zone Statistics:** Retrieve summaries of pets outside the power-saving zone, grouped by pet type and tracker type.
- **Flexible Design:** Enable straightforward replacement of the storage layer with a persistent database.
   
## Environment
- Linux-based system
- Ruby 2.7.0
- Rails 7.x
- PostgreSQL and sqlite3 for replacement db.
- Redis as in-memory DB.

## Installation Requirements
- Docker and Docker Compose

## Setup and Installation

1- Clone the repository:

        git clone git@github.com:AhmadFawzyFcih/pet_tracking_app.git
        cd pet_tracking_app

2- Configure Environment variables and Database configuration:

        cp .env.example .env
        cp config/database.example.yml config/database.yml

3- Install Dependencies and start the server:

    docker-compose up --build

4- Database setup:

    docker-compose run web rails db:create db:migrate db:seed


## API Endpoints
- Login: POST /login
```
    curl --location --request POST 'http://localhost:3000/login' \
        --header 'Content-Type: application/json' \
        --data-raw '{
            "user":{
                "email":"testuser@tractive.com",
                "password":"test123"
            }
        }'
```

- Signup: POST /signup
```
    curl --location --request POST 'http://localhost:3000/signup' \
        --header 'Content-Type: application/json' \
        --data-raw '{
            "user": {
                "email": "testuser2@tractive.com", 
                "password": "test123"
            }
        }'
```


- List Pets: GET /pets
```
    curl --location --request GET 'http://localhost:3000/pets?filter_by_type=cat&page=2&pagesize=1' \
        --header 'Content-Type: application/json' \
        --header 'Authorization: Bearer your_jwt_token_from_login_headers'
```

- Create Pet: POST /pets
```
    curl --location --request POST 'http://localhost:3000/pets' \
        --header 'Content-Type: application/json' \
        --header 'Authorization: Bearer your_jwt_token_from_login_headers' \
        --data-raw '{
            "pet": {
                "type": "Cat",
                "tracker_type": "big",
                "in_zone": false,
                "lost_tracker": false
            }
        }'
```

- Update Pet: PUT /pets/:id
```
    curl --location --request PUT 'http://localhost:3000/pets/1' \
        --header 'Content-Type: application/json' \
        --header 'Authorization: Bearer your_jwt_token_from_login_headers' \
        --data-raw '{
            "pet": {
                "in_zone": false
            }
        }'
```

- Pets Outside Zone Statistics: GET /pets/outside_zone_statistics
```
    curl --location --request GET 'http://localhost:3000/pets/outside_zone_statistics' \
        --header 'Content-Type: application/json' \
        --header 'Authorization: Bearer your_jwt_token_from_login_headers'
```

Response

```
{
    "data": [
        {
            "type": "Cat",
            "tracker_type": "small",
            "count": 7
        },
        {
            "type": "Cat",
            "tracker_type": "big",
            "count": 10
        },
        {
            "type": "Dog",
            "tracker_type": "small",
            "count": 2
        },
        {
            "type": "Dog",
            "tracker_type": "medium",
            "count": 2
        },
        {
            "type": "Dog",
            "tracker_type": "big",
            "count": 8
        }
    ],
    "total_outside_pet_count": 29
}
```

## Running Tests using Rspec
1- Run bash

        docker-compose exec web /bin/sh

2-Prepare the test environment

        RAILS_ENV=test rails db:create db:migrate

3-Run specs

        RAILS_ENV=test bundle exec rspec


## Storage Layer Replacement from postgres to sqlite3

1- uncomment **sqlite3 config** and comment **postgres config** in .env file

2- Replace adapter in config/database.yml

        adapter: sqlite3

3- Rebuild your app

        docker-compose up --build 
        docker-compose run web rails db:create db:migrate db:seed

