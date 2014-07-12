# erb2haml

**erb2haml** gives your Rails app rake tasks to convert or replace all
ERB view templates to [Haml](http://haml.info/).

__Note: This is a copy of https://github.com/dhl/erb2haml with the rake task almost completely rewritten to add additional functionality__

## Getting Started

### Enabling the rake tasks

Add `gem 'erb2haml', github: 'demelziraptor/erb2haml'` and `gem 'html2haml', github: 'haml/html2haml'` to the development group in your `Gemfile`. You can
do this by adding to your Gemfile the lines:

```ruby
group :development do 
  # ... 
  gem 'html2haml', github: 'haml/html2haml'
  gem 'erb2haml', github: 'demelziraptor/erb2haml'
  # ... 
end
```
(You need to get html2haml from the github repo as the gem is out of date and throws errors in the latest version of Rails.)

### Converting ERB Templates to Haml

After enabling the rake task you can convert your ERB
templates to Haml using the following:
`rake haml:convert`

There are also three commandline options you can use:
- verbose: to print out the action taken for each erb file
- dryrun: show changes but do not make any
- replace: to remove any erb files that have been converted to haml

You can use these in any order and just list them after the rake command.
For example, to give you the full output of what would be changed without
actually making any modifications: `rake haml:convert dryrun verbose`

If you want to do the conversion, check you're happy with the haml files
and then delete the erb files, you can do this:
`rake haml:convert verbose` (verbose is optional here)
`rake haml:convert replace`
This will tell you what's been converted, and then delete the erb files.


## License

Copyright (c) 2011-2013 David Leung and [contributors](https://github.com/dhl/erb2haml/contributors). See LICENSE for further details.
