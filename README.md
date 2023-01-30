
# Shift Planner

Shift Planner is a project that allows you to manage shifts for workers. It uses Ruby on Rails as the back-end API and a PostgreSQL database.




## Features

- Workers can only have one shift per day
- Shift slots are limited to (0-8, 8-16, 16-24)
- Shift start time and end time are represented as an enum with values of 0, 1, and 2
- Worker can only update slot on a shift not date


## Environment Variables
- Ruby 2.6.9 or higher
- Rails 6.0.6 or higher
- PostgreSQL 12 or higher


## Installation
- Install dependencies

```bash
 bundle install
```
- Setup database
```bash
 rails db:create db:migrate
```
- Start the server
```bash
 rails server
```

## API Endpoints
#### Note: This API does not implement any authentication mechanism.

### workers
- GET /workers => Get all workers
- GET /workers/:id => Get a worker by ID
- POST /workers => Create a worker
  - params:
    - name (required, string)
- PUT /workers/:id => Update a worker
- DELETE /workers/:id => Delete a worker
### Shifts
- GET /workers/:worker_id/shifts => Get all shifts
- GET /workers/:worker_id/shifts/:id => Get a shift by ID
- POST /workers/:worker_id//shifts => Create a shift
  - params:
    - slot (required, string, ["zero_to_eight", "eight_to_sixteen", "sixteen_to_twenty_four"])
    - date (required, date)
- PUT /workers/:worker_id//shifts/:id => Update a shift (slot only)
  - params:
    - slot (required, string, ["zero_to_eight", "eight_to_sixteen", "sixteen_to_twenty_four"])
- DELETE /workers/:worker_id//shifts/:id => Delete a shift
## Running Tests

To run tests, run the following command

```bash
  rspec
```
