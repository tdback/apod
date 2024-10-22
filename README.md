# apod
A script to scrape the "Astronomy Picture of the Day" and download the daily
featured image.

## Usage
By default `apod` will automatically parse out and save the image under the
filename found in the page source. You can optionally specify a filename.

```
usage: apod [-h] [name]

Download the astronomy picture of the day.

positional arguments:
  name        save the image as 'name'

options:
  -h, --help  show this help message and exit
```

## Requirements
The script relies on the following Python3 libraries:
- beautifulsoup4 (bs4)
- requests
