lokl-cli
========

Interactive wizard or noninteractive script for launching and managing your [lokl](https://lokl.dev) WordPress sites.

Usage
=====

### macOS, Linux, Windows

The simplest way to get started, paste the following into a terminal to launch Lokl's interactive wizard:

`sh -c "$(curl -sSl 'https://lokl.dev/cli-5.0.0-rc2')"`

### Site templates

From version 5.0.0, Lokl now supports site template files, which, if present, Lokl will allow you to choose as a template for your new site. They're totally optional, Lokl runs just fine without them. 

Currently, these allow specifying directories from your host machine to mount within your Lokl site's container. This makes it easier for those editing plugins/themes/site files on their local computer and having the changes apply immediately within their Lokl site.

Future enhancements to this templating will allow for things like specifying different sets of plugins/themes to auto-install in new Lokl sites.

An example site template file is located within this repository, named `site-template-example.lokl`. There are comments in this template, describing how to use it, also described here:

 - make a `templates` directory inside a `.lokl` directory in your `$HOME` folder.

ie, on macOS, this would be `/Users/leon/.lokl/templates`

 - copy the example `site-template-example.lokl` template from this repository into that Lokl templates folder, naming it something descriptive
 - edit the volumes section to specify which directories you want to be shared from your host operating system to within the container running your Lokl site
 - when you next run the Lokl CLI wizard to create a site, you'll be presented with a list of your templates to choose from

#### Programmatic usage

If you're familiar with Docker and bash, you can read through the source code of this repository and the [lokl](https://github.com/leonstafford/lokl)'s to see how I provision and control Lokl. 

Any docs I write about that will be quickly out of date, so please refer to the code and ask me any specific questions.


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

