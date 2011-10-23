Gaga
==========

Gaga is a Git-backed key/value store written in Ruby. Built with
[Grit](https://github.com/mojombo/grit), it supports SET, GET, KEYS, and DELETE
operations. And since it's Git, we can easily enhance it to include other
awesome Git features such as branches, diffs, reverting, and more!


Usage
----------

```ruby

@gaga = Gaga.new(:repo => File.expand_path('..', __FILE__))

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

# Remove all items from the store
@gaga.clear

```

Installing Gaga
----------

```
$ gem install gaga
```

Contributing
----------

Once you've made your great commits:

1. Fork Gaga
2. Create a topic branch - git checkout -b my_branch
3. Push to your branch - git push origin my_branch
4. Create a Pull Request from your branch
5. That's it!

Author
----------
[Matt Sears](https://wwww.mattsears.com) :: @mattsears

