lokl-cli
========

Interactive wizard or noninteractive script for launching and managing your [lokl](https://lokl.dev) WordPress sites.

Usage
=====

### macOS, Linux, Windows

*Latest stable release*

`sh -c "$(curl -sSl 'https://lokl.dev/go?v=4')"`

*Latest development version*

`sh -c "$(curl -sSl 'https://lokl.dev/cli-5.0.0-dev')"`

Versions of lokl-cli match with published versions of the Lokl docker images. This helps users to avoid being forced to update to new versions if everything's working fine for them on an old version. While you can fully manipulate your Lokl environment once running, it would be a headache to try, for example, to downgrade from PHP 7.4 to 7.3 if you have a hard requirement for that older version. You can check the [Lokl release notes](https://github.com/leonstafford/lokl/releases) or [CHANGELOG file](https://github.com/leonstafford/lokl/blob/master/CHANGELOG.md) to see information about the environment.


Build status
============

[![CircleCI](https://circleci.com/gh/leonstafford/lokl-cli.svg?style=svg)](https://circleci.com/gh/leonstafford/lokl-cli)

Testing
=======

 - `shellcheck`
 - `shellspec`

With code coverage report:

 - `shellspec --kcov`

For convenience, you can run `sh test.sh`.

CircleCI config runs both of these commands.

Debug log
=========

To aid in development or user support, lokl-cli appends to a log file
 in your system's temp directory, which can be followed by:

`touch /tmp/lokldebuglog && tail -F /tmp/lokldebuglog`

Style Guide
===========

In lieu of an automatic beautifier, refer to [Google Shellguide](https://google.github.io/styleguide/shellguide.html) if unsure. If you know of something like PHPCodeSniffer and PHPCodeBeautifier to compliment ShellCheck, please let me know!

