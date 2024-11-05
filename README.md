# apod
A script to scrape the "Astronomy Picture of the Day" and download the daily
featured image.

## Usage
By default `apod` will automatically parse out and save the image under the
filename found in the page source. You can optionally specify an alternate
filename for the downloaded image, as well as the directory to store the image
in.

```
usage: apod [-h] [-d DIR] [-f] [name]

Download the astronomy picture of the day.

positional arguments:
  name        save the image under an alternate name

options:
  -h, --help  show this help message and exit
  -d DIR      save the image to directory DIR
  -f          do not prompt when creating a new directory
```

## Requirements
The script relies on the following Python3 libraries:
- beautifulsoup4 (bs4)
- requests

## Installation (optional)
The script can be built using `nix build`. This will pull in all the required
dependencies and generate an executable script in `./result/bin/`.
