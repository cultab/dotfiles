# Requirements

- python, duh
- pipx


# install

```sh
cat python_pkgs.md |
    grep '\*' |
    cut -d ' ' -f 2 |
    xargs pipx install
```

# pkgs

* trash-cli
    `rm` but with trashcan
* yt-dlp
    youtube downloader
* tldr
    `man` but quick
