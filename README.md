# n

The Notebook framework, part of my dotfiles. Powered by Hakyll.

## Deployment

```sh
$ stack init
$ make
```

Notes are placed under `n/` folder.

Two ports are hard-coded,
* 12345: the hakyll server.
* 12346: editord for accepting requests to launch editor to edit notes.
