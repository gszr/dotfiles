## . files

My dotfiles, managed with [`dot`](https://github.com/gszr/dot).

* Download `dot`:
```sh
$ curl --remote-name-all --location  $( \
    curl -s https://api.github.com/repos/gszr/dot/releases/latest \
    | grep "browser_download_url.*$(uname -s)-$(uname -m).*" \
    | cut -d : -f 2,3 \
    | tr -d \" )
```

* Install the dotfiles
```sh
$ dot -verbose
```
