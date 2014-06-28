# erb2haml

**erb2haml** gives your Rails app rake tasks to convert or replace all
ERB view templates to [Haml](http://haml.info/).

## Getting Started

### Enabling the rake tasks

Add `gem "erb2haml"` and `gem 'html2haml', github: 'haml/html2haml'` to the development group in your `Gemfile`. You can
do this by adding to your Gemfile the line

```ruby
gem 'html2haml', github: 'haml/html2haml'
gem "erb2haml", :group => :development
```
    
_or_ if you prefer the block syntax

```ruby
group :development do 
  # ... 
  gem 'html2haml', github: 'haml/html2haml'
  gem "erb2haml"
  # ... 
end
```
(You need to get html2haml from the github repo as the gem is out of date and throws errors.)

### Converting ERB Templates to Haml

After enabling the rake task you can convert your ERB
templates to Haml using the following:
`rake haml:convert`

There are also three commandline options you can use:
- verbose: to print out the action taken for each erb file
- dryrun: show changes but do not make any
- replace: to remove any erb files that have been converted to haml

## License

Copyright (c) 2011-2013 David Leung and [contributors](https://github.com/dhl/erb2haml/contributors). See LICENSE for further details.
