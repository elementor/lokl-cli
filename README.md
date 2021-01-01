lokl-cli
========

Interactive script for launching and managing your [lokl](https://lokl.dev) websites.

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

