# Requirements

- go

# install


```sh
cat pkgs_go.md |
    grep '\*' |
    cut -d ' ' -f 2 |
    xargs -I '{}' go install github.com/{}
```

* paololazzari/play@latest
    like moreutils' `vipe`, edit pipelines
* maaslalani/nap@main
    snippets manager

