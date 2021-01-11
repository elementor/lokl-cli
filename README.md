lokl-cli
========

Interactive wizard or noninteractive script for launching and managing your [lokl](https://lokl.dev) WordPress sites.

Usage
=====

### macOS, Linux, Windows

`\sh -c "$(curl -sSl 'https://lokl.dev/go?v=4')"`


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

