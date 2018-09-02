# Taugen Motors Backend

* Ruby version: `2.5.1`

* Rails version: `5.2.1`

* Database:
  * PostgreSQL

* System dependencies: 
  * docker (Using version 18.06.1-ce, build e68fc7a)
  * docker-compose (Using version 1.21.2, build a133471)

* Configuration
  * Create environment files
    * .docker.env
    * .env
  * run `docker-compose build`

* Database creation
  ```
  docker-compose run web bash
  rails db:create
  rails db:migrate
  ```

* Database initialization
  * `docker-compose run web rails db:seed`

* How to run the test suite
  * `docker-compose run web rspec`

* Runnig the application
  * run `docker-compose up`
  * The service will run on port 3000

* Documentation
  * Documentation is generated autocatically, you can check it out on:
    * http://localhost:3000/api/v1/index

* Running the application
  * run `docker-compose up`
  * The service will run on port 3000
* Documentation
  * Documentation is generated automatically, you can check it out on: 
  * http://localhost:3000/api/v1/index