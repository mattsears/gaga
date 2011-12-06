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

# Remove all items from the store
@gaga.clear

```

### Branches

You can always store key/values in separate branches.  Just specify the `branch`
option parameter:

```ruby
@gaga = Gaga.new(:repo => path_to_repo, :branch => 'config')
```

Though not recommended, Gaga can store the identical key in different branches.

### Logs

Gaga keeps a history of key/value saves.

```ruby
@gaga.log('key')
```

Returns an array of commit messages along with meta data about each key/value save.

```ruby
[
 {"message"=>"all clear","committer"=>{"name"=>"Matt Sears", "email"=>"matt@mattsears.com"}, "committed_date"=>"2011-09-05..."},
 {"message"=>"set 'lady' ", "committer"=>{"name"=>"Matt Sears", "email"=>"matt@mattsears.com"}, "committed_date"=>"2011-09-05..."}
 {"message"=>"delete 'lady' ", "committer"=>{"name"=>"Matt Sears", "email"=>"matt@mattsears.com"}, "committed_date"=>"2011-09-05..."}
]
```

Custom commit options can be set globally when creating a new Gaga instance, or
passed in with calls to #set, #delete, or #clear.

Examples:

```ruby
# Global options
store1 = Gaga.new(
	:repo => '/path/to/repo/',
	:branch => :example,
	:author => {
		:name => 'Jim Bob',
		:email => 'jbob@example.com'
	},
	:committer => {
		:name => 'Jane Doe',
		:email => 'jdoe@example.com'
	}
)

# Custom message when storing a key/value
store1.set('key_1', 'Hello World', {:message => 'This is a custom commit log message'})

store2 = Gaga.new(:repo => '/path/to/repo/', :branch => :example)

# Assigns an author when storing a key/value
store2.set('key_1', 'Goodbye', {
	:message => 'Another custom log message',
	:author => {
		:name => 'Sally',
		:email => 'sally@example.com'
	}
})

# Delete operations can also have a custom message
store2.delete('key_1', {:message => 'Farewell message'})
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

