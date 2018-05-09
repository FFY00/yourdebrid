# YourDebrid

YourDebrid is a fully open-source debrid service written in [D](https://dlang.org/).


## Build Instructions

```
$ mkdir builld
$ cd build
$ meson ..
$ ninja
```

###### Run tests
```
$ ninja run-tests
```

###### Changing the compiler
```
$ DC='dmd' meson ..
```


### What is a Debrid service?

A debrid service is a service that downloads torrents and then uploads them to a remote server. It provides a http(s) link for a torrent file.


### Is it legal?

Well, it depends on your country.
For most of the EU it is legal to stream copyrighted content generated from this service, you just can't download it.

You can see more information here: https://en.wikipedia.org/wiki/Legal_aspects_of_file_sharing


## License

This software is licensed under [GNU Affero General Public License 3.0 (APGLv3).](https://www.gnu.org/licenses/agpl-3.0.en.html)

You can see a really brief interpertation of the license on [tldrlegal's website](https://tldrlegal.com/license/gnu-affero-general-public-license-v3-%28agpl-3.0%29).
