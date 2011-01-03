FlickVimeo
=======

# Description

Ever wanted a simple way to send [Vimeo][] links to your Apple TV? This is 
a simple command line tool that leverages [AirFlick][] to send the URL of
an Apple TV compatable (h.264 encoded) video in the highest resolution 
available to the currently-selected Apple TV in AirFlick.

# Installation

The best way to install FlickVimeo is with RubyGems:

    $ [sudo] gem install flickvimeo


# Usage

Run `flickvimeo` on the command line and pass it a Vimeo URL or ID:

    $ flickvimeo <vimeo-url>

For example:

    $ flickvimeo http://vimeo.com/18017106


# Warnings

 * This is just a solution to a personal problem I've had — it may 
   completely not work for you
 * This is OS X-specific — it uses [AirFlick][], so if you don't have that 
   installed and running, you're out of luck
 * This may go against all sorts of [Vimeo][] rules and may break any time they
   decide to change the format of the Javascript they use on their site

[Vimeo]: http://vimeo.com/
[AirFlick]: http://ericasadun.com/ftp/AirPlay/
