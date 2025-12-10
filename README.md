# NOVERLAY

NoqMorien Personal Gentoo Linux Overlay


## Installation

For installation you need to install `app-eselect/eselect-repository` first
by these following these commands

```sh
emerge -av app-eselect/eselect-repository
```

and then add `guru` and `noverlay` repository

```sh
eselect repository enable guru
eselect repository add noverlay git https://github.com/noqmorien/noverlay.git
emaint sync -r noverlay
```


## NOTE
- This overlay is maintained by me and can be used to install custom packages and configurations tailored for personal use on Gentoo.
- For any issues or questions, feel free to open an issue on [GitHub](https://github.com/noqmorien/noverlay/issues).
