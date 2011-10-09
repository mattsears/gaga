Gaga (Work in Progress)
==========

Git as a key-value store! Build with [Grit](https://github.com/mojombo/grit), it supports SET, GET, KEYS, and DELETE operations. In addition, we can also get the change history key/values.

It can easily be enhanced to include other git features such as branches, diffs, etc

Example:

```ruby

@gaga = Gaga.new(:path => File.expand_path('..', __FILE__))
@gaga.clear

# SET

@gaga['lady'] = "gaga"

# GET

@gaga['lady'] #=> "gaga"

# KEYS

@gaga.keys  #=> ['lady']

# DELETE

@gaga.delete('lady') #=> 'gaga'

# LOG

@gaga.log('key')

# Produces:

[
 {"message"=>"all clear","committer"=>{"name"=>"Matt Sears", "email"=>"matt@mattsears.com"}, "committed_date"=>"2011-09-05..."},
 {"message"=>"set 'lady' ", "committer"=>{"name"=>"Matt Sears", "email"=>"matt@mattsears.com"}, "committed_date"=>"2011-09-05..."}
 {"message"=>"delete 'lady' ", "committer"=>{"name"=>"Matt Sears", "email"=>"matt@mattsears.com"}, "committed_date"=>"2011-09-05..."}
]

```
