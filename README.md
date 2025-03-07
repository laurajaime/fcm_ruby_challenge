# FCM Ruby challenge
This is an api only app in RoR.

## About challenge
As we want to provide a better experience for our users we want to represent their itinerary in the most comprehensive way possible.

We receive the reservations of our user that we know is based on SVQ as:

```
# raw_itinerary.txt

RESERVATION
SEGMENT: Flight SVQ 2023-03-02 06:40 -> BCN 09:10

RESERVATION
SEGMENT: Hotel BCN 2023-01-05 -> 2023-01-10

RESERVATION
SEGMENT: Flight SVQ 2023-01-05 20:40 -> BCN 22:10
SEGMENT: Flight BCN 2023-01-10 10:30 -> SVQ 11:50

RESERVATION
SEGMENT: Train SVQ 2023-02-15 09:30 -> MAD 11:00
SEGMENT: Train MAD 2023-02-17 17:00 -> SVQ 19:30

RESERVATION
SEGMENT: Hotel MAD 2023-02-15 -> 2023-02-17

RESERVATION
SEGMENT: Flight BCN 2023-03-02 15:00 -> NYC 22:45
```

## Run rake to humanify itinerary

### First steps

Run `docker-compose up` to prepare application

### Run the rake task

You can run a command like `docker-compose run --rm app itinerary:humanify[<based_iata>,<raw_itinerary.txt>]`

`docker-compose run --rm app itinerary:humanify[SVQ,raw_itinerary.txt]` to get a humanify itinerary like that:

```
TRIP to BCN
Flight from SVQ to BCN at 2023-01-05 20:40 to 22:10
Hotel at BCN on 2023-01-05 to 2023-01-10
Flight from BCN to SVQ at 2023-01-10 10:30 to 11:50

TRIP to MAD
Train from SVQ to MAD at 2023-02-15 09:30 to 11:00
Hotel at MAD on 2023-02-15 to 2023-02-17
Train from MAD to SVQ at 2023-02-17 17:00 to 19:30

TRIP to NYC
Flight from SVQ to BCN at 2023-03-02 06:40 to 09:10
Flight from BCN to NYC at 2023-03-02 15:00 to 22:45
```

## About the solution

### Overview
The solution involves reading the input file `raw_itinerary.txt` and taking into account the `based` argument, parsing the reservations, persisting segments and itinerary, sorting and grouping the segments by destination, and then printing the itinerary in a human-readable format. The main logic is implemented in a service, and a rake task is provided to facilitate running it within a Docker container.

### Key components

1. **Service (`ItineraryService`)**:
  - Contains the core logic for parsing, persists, sorting, and grouping the segments.
  - Provides a method (`humanify`) to process the input and generate the itinerary.

3. **Presenter (`SegmentPresenter`)**:
  - Formats the sorted and grouped segments into a human-readable itinerary.
  - Ensures the output is clear and well-structured.

4. **Rake task**:
  - Provides a convenient way to run the service with specified parameters.

5. **Docker setup**:
  - `docker-compose.yml` is used to define the application service.
  - Ensures a consistent environment for print the itinerary.

### What are included?
- **Docker**: Ensures a consistent environment and simplifies dependencies.
- **Rake task**: Provides an easy interface for print the itinerary.
- **Service and presenter**: Separates concerns, making the code more modular, maintainable and extensible.
- **Migrations and models**: Used to persist the itinerary and segments data, ensuring data integrity and enabling complex queries.
- **Tests with rspec**: Ensures the correctness of the service and presenter logic, providing confidence in the solution's reliability.
- **Rubocop**: Ensures code quality and enforces coding standards.

### What are left out?
- **More testing**: The solution includes basic tests to ensure the core functionality works as expected. More comprehensive tests can be added in the future as the solution evolves.
- **Advanced features**: Focuses on the core functionality without adding unnecessary complexity.
- **Extensive documentation**: Provides essential information to understand and run the solution, avoiding overly detailed documentation.
