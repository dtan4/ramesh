# Ramesh
[![Coverage Status](https://img.shields.io/coveralls/dtan4/ramesh.svg)](https://coveralls.io/r/dtan4/ramesh?branch=master)

Command Line Tool for [東京アメッシュ (Tokyo-Amesh)](http://tokyo-ame.jwa.or.jp/)

## Installation

At first, you need to install [ImageMagick](http://www.imagemagick.org/script/index.php) (if you haven't installed yet).

Add this line to your application's Gemfile:

    gem 'ramesh'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ramesh

## Usage

    ramesh [-d save_dir]              download the latest image
    ramesh [-d save_dir] 0-120        download the image specified minutes before
    ramesh [-d save_dir] 0-120 0-120  download images within a specified range
    ramesh -h, --help                 show this usage

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
