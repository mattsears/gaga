require 'yaml'
require 'grit'
require 'gaga/version'

class Gaga

  def initialize(options = {})
    @author = options.delete(:author)
    @committer = options.delete(:committer)
    @options = options
    
    if path.end_with?('.git/')
      Grit::Repo.init_bare(path) unless File.exists?(File.join(path,'refs'))
    else
      Grit::Repo.init(path) unless File.exists?(File.join(path,'.git'))
    end
  end

  # Add the value to the to the store
  #
  # Example
  #   @store.set('key', 'value')
  #
  # Returns nothing
  def set(key, value, opts = {})
    unless value == get(key)
      save(setup_commit_options({:message => "set '#{key}'"}.merge(opts))) do |index|
        index.add(key_for(key), encode(value))
      end
    end
  end

  # Shortcut for #set
  #
  # Example:
  #  @store[key] = 'value'
  #
  def []=(key, value)
    set(key, value)
  end

  # Retrieve the value for the given key with a default value
  #
  # Example:
  #  @store.get(key)  #=> value
  #
  # Returns the object found in the repo matching the key
  def get(key, value = nil, *)
    if head && blob = head.commit.tree / key_for(key)
      decode(blob.data)
    end
  end

  # Shortcut for #get
  #
  # Example:
  #   @store['key']  #=> value
  #
  def [](key)
    get(key)
  end

  # Returns an array of key names contained in store
  #
  # Example:
  #  @store.keys  #=> ['key1', 'key2']
  #
  def keys
    head.commit.tree.contents.map{|blob| deserialize(blob.name) }
  end

  # Deletes commits matching the given key
  #
  # Example:
  #  @store.delete('key')
  #
  # Returns nothing
  def delete(key, opts = {})
    options = setup_commit_options({:message => "deleted #{key}"}.merge(opts))
    self[key].tap do
      save(options) {|index| index.delete(key_for(key)) }
    end
  end

  # Deletes all contents of the store
  #
  # Returns nothing
  def clear(opts = {})    
    save(setup_commit_options({:message => "all clear"}.merge(opts))) do |index|
      if tree = index.current_tree
        tree.contents.each do |entry|
          index.delete(key_for(entry.name))
        end
      end
    end
  end

  # The commit log for the given key
  #
  # Example:
  #  @store.log('key') #=> [{"message"=>"Updated key"...}]
  #
  # Returns Array of commit data
  def log(key)
    git.log(branch, key_for(key)).map{ |commit| commit.to_hash }
  end

  # Find the key if exists in the git repo
  #
  # Example:
  #  @store.key? 'key'  #=> true
  #
  # Returns true if found; false if not found
  def key?(key)
    !(head && head.commit.tree / key_for(key)).nil?
  end

  private
  
  def setup_commit_options(opts = {})
    {
      :author => @author,
      :committer => @committer
    }.merge(opts)
  end

  # Format the given key so that it ensures it's git worthy
  def key_for(key)
    key.is_a?(String) ? key : serialize(key)
  end

  # Given the file path, return a new Grit::Repo if found
  def git
    @git ||= Grit::Repo.new(path)
  end

  # The git branch to use for this store
  def branch
    (@options[:branch] || 'master').to_s
  end

  # Checks out the branch on the repo
  def head
    git.get_head(branch)
  end

  # Commits the the value into the git repository with the given commit message
  def save(options)
    author = options[:author] ? Grit::Actor.new(options[:author][:name], options[:author][:email]) : nil
    committer = options[:committer] ? Grit::Actor.new(options[:committer][:name], options[:committer][:email]) : nil
    
    index = git.index
    if head
      commit = head.commit
      index.current_tree = commit.tree
    end
    yield index
    index.commit(options[:message], :parents => Array(commit), :author => author, :committer => committer, :head => branch) if index.tree.any?
  end

  # Converts the value to yaml format
  def encode(value)
    value.to_yaml
  end

  # Loads value as a Yaml structure
  def decode(value)
    YAML.load(value)
  end

  # Convert value to byte stream. This allows keys to be objects too
  def serialize(value)
    Marshal.dump(value)
  end

  # Converts value back to an object.
  def deserialize(value)
    Marshal.restore(value) rescue value
  end

  # Given that repo path set in the options, return the expanded file path
  def path(key = '')
    @path ||= File.join(File.expand_path(@options[:repo]), key)
  end

end
