# apod
A script to scrape the [Astronomy Picture of the
Day](https://apod.nasa.gov/apod/) (APOD) and download the daily featured image.

## Usage
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

By default `apod` will extract and download the current day's APOD and save it
to the local file system. You can optionally specify an alternate filename for
the downloaded image, otherwise `apod` will use the extracted name.

If you are using `nix`, you can run the script with `nix run`:

```bash
nix run github:tdback/apod
```

## Requirements
The script relies on the following Python3 libraries, which can be installed
via `pip`:

```bash
pip install beautifulsoup4 requests
```

If you are using `nix`, you can build a self-contained binary with the
following command:

```bash
nix build
```

The generated executable can be found in `./result/bin`.
