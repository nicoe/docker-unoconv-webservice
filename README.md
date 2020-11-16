# docker-unoconv-webservice


Unoconv as a webservice.

This fork calls unoconv in way that allows parallel conversions, that is with random --port and --user-profile options.
See https://github.com/unoconv/unoconv/issues/225.

Credits:

* https://github.com/atorma/tfk-api-unoconv

We simply added a liveness probe that converts a test odt file to pdf


## Build

```bash
$ docker build -t docker-unoconv-webservice .
```

## Run - example
```bash
$ docker run -d -p 80:5000 --name unoconv docker-unoconv-webservice
```

## Usage

Post the file you want to convert to the server and get the converted file in return.

See all possible conversions on the [unoconv website](http://dag.wiee.rs/home-made/unoconv/).

API for the webservice is /unoconv/{format-to-convert-to} so a docx to pdf would be

```bash
$ curl --form file=@myfile.docx http://localhost/unoconv/pdf > myfile.pdf
```

For a basic example with upload via form take a look at the [browser-file-convert](https://github.com/nithinkashyapn/browser-file-convert) example from [nithinkashyapn](https://github.com/nithinkashyapn)

### Formats

To see all possible formats for convertion visit ```/unoconv/formats```

To see formats for a given type ```/unoconv/formats/{document|graphics|presentation|spreadsheet}```

### Versions

To see all versions of unoconv and dependencies lookup ```/unoconv/versions```

### Healthz

Are we alive? ```/healthz```

returns

```JavaScript
{
  uptime: 18.849
}
```

### Liveness

Are we really alive? ```/liveness```

returns

```JavaScript

"alive\n"

```

## Environment

You can change the webservice port and filesize-limit by changing environment variables.

SERVER_PORT default is 5000

PAYLOAD_MAX_SIZE default is 1048576 (1 MB)

TIMEOUT_SERVER default is 2 minutes (120 000 milliseconds)

TIMEOUT_SOCKET default is 2 minutes and 20 seconds (140 000 milliseconds)

Change it in the Dockerfile or create an env-file and load it at containerstart

```bash
$ docker run --env-file=docker.env -d -p 80:5000 --name unoconv docker-unoconv-webservice
```

## License
[MIT](LICENSE)
