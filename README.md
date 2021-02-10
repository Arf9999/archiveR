
<!-- README.md is generated from README.Rmd. Please edit that file -->

# archiveR

The goal of archiveR is to automate upload of urls to web.archive.org

## Installation

You can install the development version of archiveR from github with:

``` r
remotes::install_github("Arf9999/archiveR")
```

#### prepare\_auth()

Provides step by step process to create an auth cookie string for
archive.org Recommended to run this once and save the output as a named
string.  
NB. Cookies expire, so this should be repeated regularly.

#### pass\_query(query\_url, cookies)

Builds a command to save a specified URL to archive.org. NB: it is
recommended to have cookies saved as a string by running
`prepare_auth()`

#### web\_archive\_list(url\_list, cookies)

Iterates through a list of url strings to save to archive.org. This
process manages the rate limiting of archive.org (only 5 urls processed
simultaneously) NB: it is recommended to have cookies saved as a string
by running `prepare_auth()`
