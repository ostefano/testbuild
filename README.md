# testbuild

This is a simple build using ubuntu `24.04` as base, and uses `composer` to download php dependencies.

Note:
* Using Debian `bullseye` / `bookworm` as base distro works.
* Build `amd64` works.
* Building locally, works.


The error:
```
#21 43.69 * Found bundle for host: 0x5500976c70 [serially]
#21 43.69 * Server doesn't support multiplex (yet)
#21 43.69 * Hostname 'api.github.com' was found in DNS cache
#21 43.69 *   Trying 140.82.114.6:443...
#21 43.69 * Connected to api.github.com (140.82.114.6) port 443
#21 43.69 * SSL connection timeout
#21 43.69 * Closing connection
#21 43.70     Failed to download symfony/polyfill-intl-normalizer from dist: curl error 28 while downloading https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/a95281b0be0d9ab48050ebd988b967875cdb9fdb: SSL connection timeout
```
