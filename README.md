# Contentful Bash Back-up

Bash script for making periodical back-ups of [Contentful](https://www.contentful.com/) entries and assets. _Contentful Bash Back-up_ is compatible with Unix-like operating systems such as Linux or macOS.

## Contentful

[Contentful](https://www.contentful.com/) provides a content infrastructure for digital teams to power content in websites, apps, and devices. Unlike a CMS, Contentful was built to integrate with the modern software stack. It offers a central hub for structured content, powerful management and delivery APIs, and a customizable web app that enable developers and content creators to ship digital products faster.

Contentful is registered trademark of Contentful GmbH.

## Author

**Teemu Tammela**

* [teemu.tammela@auralcandy.net](mailto:teemu.tammela@auralcandy.net)
* [www.auralcandy.net](https://www.auralcandy.net/)
* [github.com/teemutammela](https://github.com/teemutammela)
* [www.linkedin.com/in/teemutammela](https://www.linkedin.com/in/teemutammela/)
* [t.me/teemutammela](http://t.me/teemutammela)

## Disclaimer

**Contentful Bash Back-up** is distributed under [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html) and comes with **absolutely no warranty**. The author assumes no responsibility of data loss or any other unintended side-effect.

## Features

* Exports entries and assets as JSON data and compresses them as ZIP-files.
* Option to download asset files (incremental, no duplicates).
* Silent running, all output is printed into export log.

## Requirements

* [Git](http://git-scm.com/)
* [Bash](https://git.savannah.gnu.org/cgit/bash.git)
* [npm](http://www.npmjs.com/)
* [Contentful CLI](https://github.com/contentful/contentful-cli)

## Installation

__1)__ Clone repository.

`$ git clone https://github.com/teemutammela/contentful-bash-backup.git`

__2)__ Install [Contentful CLI](https://github.com/contentful/contentful-cli).

`$ npm install -g contentful-cli`

__3)__ If you don't already have a management token, create one in the Contentful Web App at _Space settings → API keys → Content management tokens_.

## Usage

`$ ./run.sh help`

`$ ./run.sh [-t </PATH/TO/TARGET_DIR>] [-m <MANAGEMENT_TOKEN>] [-s <SPACE_ID>] [-e <ENVIRONMENT_ID>] [-f]`

### Parameters

| Parameter | Description                       | Required | Default Value  |
|-----------|-----------------------------------|----------|----------------|
|`-t`       | Path to Back-up Target Directory  | Yes      | -              |
|`-m`       | Contentful Management Token       | Yes      | -              |
|`-s`       | Contentful Space ID               | Yes      | -              |
|`-e`       | Contentful Environment ID         | No       | `master`       |
|`-f`       | Download Asset Files              | No       | No             |

**Contentful Bash Back-up** is intended to be used in conjunction with `cron`. As a general rule of thumb, it's practical to export entries more often than assets, as entries change more frequently. In the following example entries are exported every day at 12:15. Another export operation that also downloads the assets is executed every Sunday at 12:30.

```
15	12	*	*	*	/bin/sh /path/to/contentful-bash-backup/run.sh -t "/path/to/target_dir/" -m "XYZ123" -s "XYZ123" >/dev/null 2>&1
30	12	0	*	7	/bin/sh /path/to/contentful-bash-backup/run.sh -t "/path/to/target_dir/" -m "XYZ123" -s "XYZ123" -f >/dev/null 2>&1
```

After the export process is complete, a new back-up file is located at `/<TARGET_DIR>/entries/YYYY-MM/entries-YYYY-MM-DD_HH.MM.SS.zip` and the log at `/<TARGET_DIR>/logs/YYYY-MM/entries-YYYY-MM-DD_HH.MM.SS.log`.

__NOTE!__ Entries and assets in draft state are _not_ exported.

If the `-f` parameter was selected, assets are located in directories `/<TARGET_DIR>/downloads.ctfassets.net/` and `/<TARGET_DIR>/images.ctfassets.net/`. Please note, that in order to avoid duplicate files, asset directories are _not_ compressed which can consume a fair amount of storage space.

__NOTE!__ Downloading asset files can be a lengthy process and can potentially deplete your bandwidth quota depending on your subscription model. Please refer to Contentful's [Fair Use Policy](https://www.contentful.com/r/knowledgebase/fair-use/) documentation for further details.