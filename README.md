# README

This application is be run along side your CRM system, it enables:
 - emails to be sent out to your customers and installers.
 - events to be added to your intsallers calendars

The application has currently been set up to use the following adapters but there are plans to make this more flexible and allow different CRM, Calendar and File Storage services to be used in future

Current adapaters configured:

```
CRM = Zoho
CALENDAR = MyGoogle
FileStorage = MicrosoftOffice365
```

## Development

Use the helper bash scripts to easily run the application locally using docker. To start the server run:

```
./dev/server.sh
```


## Testing

To run the tests use the provided bash script to first run a docker container containing the application.

```
./dev/shell.sh
```

You can now run the RSpec tests as normal.




