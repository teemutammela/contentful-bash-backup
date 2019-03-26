# Contentful Bash Back-up

Bash script for making periodical back-ups of [Contentful](https://www.contentful.com/) entries and assets. _Contentful Bash Back-up_ is compatible with Unix-like operating systems such as Linux or macOS.

## Contentful

[Contentful](https://www.contentful.com/) provides a content infrastructure for digital teams to power content in websites, apps, and devices. Unlike a CMS, Contentful was built to integrate with the modern software stack. It offers a central hub for structured content, powerful management and delivery APIs, and a customizable web app that enable developers and content creators to ship digital products faster.

Contentful is registered trademark of Contentful GmbH.

# Features

* Exports entries and assets as JSON data and compresses them as ZIP-files
* Option to download asset files (incremental, no duplicates)
* Silent running, all output is printed into export logs

## Requirements

* [Git](http://git-scm.com/)
* [Bash](https://git.savannah.gnu.org/cgit/bash.git)
* [npm](http://www.npmjs.com/)
* [Contentful CLI](https://github.com/contentful/contentful-cli)

## Installation

*1)* Clone repository.

`$ git clone https://github.com/teemutammela/contentful-bash-backup.git`

*2)* Install [Contentful CLI](https://github.com/contentful/contentful-cli).

`$ npm install -g contentful-cli`

*3)* If you don't already have a management token, create one in the Contentful Web App at _Space settings → API keys → Content management tokens_.

## Usage

`$ ./contentful-bash-backup/run.sh [-t </PATH/TO/TARGET_DIR>] [-m <MANAGEMENT_TOKEN>] [-s <SPACE_ID>] [-e <ENVIRONMENT_ID>] [-f]`

### Parameters

|Parameter |Description                       |Required |Default value  |
|----------|----------------------------------|---------|---------------|
|`-t`      |Path to back-up target directory  |yes      |-              |
|`-m`      |Contentful management token       |yes      |-              |
|`-s`      |Contentful space ID               |yes      |-              |
|`-e`      |Contentful environment ID         |no       |master         |
|`-f`      |Download asset files              |no       |-              |

Contentful Bash Back-up is primarily intended to be used in conjunction with `cron`. In the following example the JSON data of entries and assets is exported every day at 12:15 and and export that also downloads the asset files is executed every Sunday at 12:30.

As a general guideline it is practical to export the JSON data more frequently than the asset files, as they former is more susceptible to change than the latter.

```
15	12	*	*	*	/bin/sh /path/to/contentful-bash-backup/run.sh -t "/path/to/target_dir/" -m "XYZ123" -s "XYZ123" >/dev/null 2>&1
30	12	0	*	7	/bin/sh /path/to/contentful-bash-backup/run.sh -t "/path/to/target_dir/" -m "XYZ123" -s "XYZ123" >/dev/null 2>&1
```

After the export process is complete, a new back-up file can be found at `/<target_dir>/entries/YYYY-MM/entries-YYYY-MM-DD_HH.MM.SS.zip` and the log at `/<target_dir>/log/YYYY-MM/entries-YYYY-MM-DD_HH.MM.SS.log`.

*NOTE!* Entries and assets in draft state are _not_ exported.

If the `-f` parameter was selected, asset files can be found in the directories `/<target_dir>/downloads.ctfassets.net/` and `/<target_dir/images.ctfassets.net/`. Please note, that to in order to avoid duplicate files, asset file directories are _not_ compressed which can consume a fair amount of storage space.

*NOTE!* Downloading asset files can be a lengthy process and can potentially deplete your bandwidth quota depending on your subscription model. Please refer to Contentful's [Fair Use Policy](https://www.contentful.com/r/knowledgebase/fair-use/) documentation for further details.

## Disclaimer

Contentful Bash Back-up is distributed under [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html) and comes with ABSOLUTELY NO WARRANTY. The author assumes no responsibility of data loss or any other unintended side-effect.