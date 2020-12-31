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

To help debugging while testing, `tail -f` a file in `/tmp/` and echo
 out to that within your tests.
