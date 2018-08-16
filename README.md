# 6tunnel

Docker image for 6tunnel so that docker services can be served over IPv6 without
the need to use IPv6 within the docker networks.

[6tunnel - Tunnelling for application that don't speak IPv6](http://toxygen.net/6tunnel/)

## Usage

Run the docker container with the following environment variables:

```bash
PORTS=80,443
INTERVAL=2m
```

## License

Copyright (C) 2018 Sandro Lutz

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.