#!/usr/bin/env python3

import os
import yt_dlp

files = os.listdir(".")

options = {
    "external_downloader": "ffmpeg",
    "ffmpeg_location": "%FFMPEG%",
    "format": "bestaudio",
    "outtmpl": {},
    "postprocessors": [{
        "key": "FFmpegExtractAudio",
    }],
    "postprocessor_args": {},
}

with yt_dlp.YoutubeDL(options) as yt:
    def _(title, url, **kwargs):
        if any(file.startswith(f"{title}.") for file in files):
            return
        meta = ["-metadata", f"title={title}"]
        for key, value in kwargs.items():
            meta.append("-metadata")
            meta.append(f"{key}={value}")
        yt.params["postprocessor_args"]["default"] = meta
        yt.params["outtmpl"]["default"] = f"{title}.%(ext)s"
        yt.download(url)

    _("Komm, süsser Tod", "https://www.youtube.com/watch?v=6kguaGI7aZg", artist="Hideaki Anno, Mike Wyzgowski, Shiro Sagisu, Arianne Schreiber")
