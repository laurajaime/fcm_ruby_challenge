# FCM Ruby challenge
This is an api only app in RoR.

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
