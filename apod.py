#!/usr/bin/env python

# apod: Scrape the astronomy picture of the day.

import argparse
import os
import sys

import requests
from bs4 import BeautifulSoup

URL = "https://apod.nasa.gov/apod/"


def main():
    parser = argparse.ArgumentParser(
        prog="apod",
        description="Download the astronomy picture of the day.",
    )

    parser.add_argument(
        dest="name",
        nargs="?",
        help="save the image under an alternate name",
    )

    parser.add_argument(
        "-d",
        dest="dir",
        action="store",
        help="save the image to directory DIR",
    )

    parser.add_argument(
        "-f",
        dest="force",
        action="store_true",
        help="do not prompt when creating a new directory",
    )

    args = parser.parse_args()

    soup = BeautifulSoup(requests.get(URL).content, "html.parser")
    href = soup.center.find_all("a")[1].get("href")

    image = f"{URL}{href}"

    if args.name:
        if any(sep in args.name for sep in ["/", "\\"]):
            print(
                "file name cannot contain a directory path, please use '-d' to specify the directory",
                file=sys.stderr,
            )
            return

    dir = os.path.expanduser(args.dir) if args.dir else os.getcwd()
    if not os.path.exists(dir):
        if not args.force:
            create = input(
                f"the specified directory '{dir}' does not exist, would you like to create it? [y/n]: "
            )
            if not create.lower() == "y":
                print(
                    "cannot continue without creating the parent directory",
                    file=sys.stderr,
                )
                return
        os.mkdir(dir)

    file = os.path.join(dir, f"{args.name or href.split('/')[-1]}")

    with requests.get(image, stream=True) as r:
        r.raise_for_status()
        with open(file, "wb") as f:
            for chunk in r.iter_content(chunk_size=4096):
                f.write(chunk)


if __name__ == "__main__":
    main()
