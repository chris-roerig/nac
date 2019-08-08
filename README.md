# Nac

A very simple yet flexible configuration writer/reader library. 

[![CircleCI](https://circleci.com/gh/chris-roerig/nac/tree/master.svg?style=svg)](https://circleci.com/gh/chris-roerig/nac/tree/master)
[![Maintainability](https://api.codeclimate.com/v1/badges/ff7b794633ad66c7d6db/maintainability)](https://codeclimate.com/github/chris-roerig/nac/maintainability)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nac'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nac

## How it works

The source config file and its path will be created if they don't 
already exist. The data is cached when the file is loaded and after a 
new value is saved.

## Usage

### Basic

This simple example shows how to load, write, and read. 

```ruby
require 'nac'

# load or create a new config
config = Nac::Config.new('my_config')

# set values
config.set('name', 'Chris')
config.set('color', 'Blue')

# get a single value
puts config.get('name')

# get all data
puts config.get
#=> { name: 'Chris', color: 'Blue' }
```

### Nesting Keys

It's possible to read and write nested data by passing an array to the `set` and `get`  methods.

```ruby
require 'nac'

config = Nac::Config.new('my_config')

config.set(%[user name first], 'Homer')
config.set(%[user name last],st 'Simpson')

puts config.get('user')
#=> { name: { first: 'Homer', last: 'Simpson' }}

puts config.get(%[user name])
#=> { first: 'Homer', last: 'Simpson' }

puts config.get(%[user name last])
#=> { last: 'Simpson' }

# nil is returned if the key doesn't exist
puts config.get(%[user name middle])
#=> nil

# Symbol arrays work too!

config.set(%i{look ma no}, 'hands')
puts config.get(:look)
#=> { ma: { no: 'hands' } }
```

## Options

* `template`: Optional value that will be converted to yaml and written to the config file. Default is `{}`.
* `init!`: When true, force the configuration file to be rewritten. Default is `false`.

**Note:** One doesn't need to specify `init!` when using `template`. 
The template will not be written if if the configuration file exists.
However, using `init!` will re-initialize the config file and the 
template *will* be written. Similarly, `template` is not required when 
using `init!`.

### Usage

```ruby

requre 'nac'

options = {
  template: { some: { default: [:options] } },
  init!: true
}

config = Nac::Config.new('my_config', options)

puts config.get
#=> { some: { default: [:options] } }

```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/chris-roerig/nac.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
