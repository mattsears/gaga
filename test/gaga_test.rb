$:.unshift File.dirname(__FILE__)
require 'helper'

describe Gaga do

  @types = {
    "String" => ["lady", "gaga"],
    "Object" => [{:lady => :gaga}, {:gaga => :ohai}]
  }

  before do
    @store  = Gaga.new(:repo => tmp_dir, :branch => :lady)
    @master = Gaga.new(:repo => tmp_dir)
  end

  after do
    remove_tmpdir!
  end

  @types.each do |type, (key, key2)|

    it "writes String values to keys" do
      @store[key] = "value"
      @store[key].must_equal "value"
    end
    
    it "writes String values to keys with explicit custom log data" do
      @store.set(key, "value", {:message => "Custom message", :author => {:name => 'Test', :email => 'test@example.com'} })
      @store[key].must_equal "value"
      
      entry = @store.log(key).first
      entry['message'].must_equal "Custom message"
      entry['author'].must_equal({'name' => 'Test', 'email' => 'test@example.com'})
    end
    
    it "writes String values to keys with global custom log data" do
      store = Gaga.new(
        :repo => tmp_dir, 
        :branch => :lady, 
        :author => {:name => 'Test', :email => 'test@example.com'},
        :committer => {:name => 'Test2', :email => 'test2@example.com'}
      )
      
      store.set(key, "value", {:message => "Custom message"})
      store[key].must_equal "value"
      
      entry = store.log(key).first
      entry['message'].must_equal "Custom message"
      entry['author'].must_equal({'name' => 'Test', 'email' => 'test@example.com'})
      entry['committer'].must_equal({'name' => 'Test2', 'email' => 'test2@example.com'})
    end
    
    it "does not create empty commit" do
      grit = Grit::Repo.new(tmp_dir)      
      initial_count = grit.commit_count
      
      @master.set(key, "value", {:message => 'First commit'})
      @master.set(key, "value", {:message => 'Second commit'})
      
      current_count = grit.commit_count
      
      (current_count - initial_count).must_equal 1
      @master[key].must_equal "value"
    end

    it "reads from keys" do
      @store[key].must_be_nil
    end
    
    it "should default to master when no branch is specified" do
      value = 'testing'
      @master[key] = value
      @master[key].must_equal value
      @store[key].must_be_nil
      
      tmp = Gaga.new(:repo => tmp_dir, :branch => :master)
      tmp[key].must_equal value
    end

    it 'guarantess the key is stored in the right branch' do
      @store[key] = 'value'
      @master[key].must_be_nil
      @store[key].must_equal "value"
    end

    it "returns a list of keys" do
      @store[key] = "value"
      @store.keys.must_include(key)
    end

    it "guarantees that a different String value is retrieved" do
      value = "value"
      @store[key] = value
      @store[key].wont_be_same_as(value)
    end

    it "writes Object values to keys" do
      @store[key] = {:foo => :bar}
      @store[key].must_equal({:foo => :bar})
    end

    it "guarantees that a different Object value is retrieved" do
      value = {:foo => :bar}
      @store[key] = value
      @store[key].wont_be_same_as(:foo => :bar)
    end

    it "returns false from key? if a key is not available" do
      @store.key?(key).must_equal false
    end

    it "returns true from key? if a key is available" do
      @store[key] = "value"
      @store.key?(key).must_equal true
    end

    it "removes and return an element with a key from the store via delete if it exists" do
      @store[key] = "value"
      @store.delete(key).must_equal "value"
      @store.key?(key).must_equal false
    end
    
    it "removes a key using a custom commit message" do
      @store[key] = "value"
      @store.delete(key, {:message => "Removed it"}).must_equal "value"
      @store.key?(key).must_equal false
      
      entry = @store.log(key).first
      entry['message'].must_equal "Removed it"
    end

    it "returns nil from delete if an element for a key does not exist" do
      @store.delete(key).must_be_nil
    end

    it "removes all keys from the store with clear" do
      @store[key] = "value"
      @store[key2] = "value2"
      @store.clear
      @store.key?(key).wont_equal true
      @store.key?(key2).wont_equal true
    end
    
    it "removes all keys from the store with clear and custom commit message" do
      @store[key] = "value"
      @store[key2] = "value2"
      @store.clear({:message => "All gone"})
      @store.key?(key).wont_equal true
      @store.key?(key2).wont_equal true
      
      [key, key2].each do |k|
        entry = @store.log(k).first
        entry['message'].must_equal "All gone"
      end
    end

    it "does not run the block if the #{type} key is available" do
      @store[key] = "value"
      unaltered = "unaltered"
      @store.get(key) { unaltered = "altered" }
      unaltered.must_equal "unaltered"
    end

    it "stores #{key} values with #set" do
      @store.set(key, "value")
      @store[key].must_equal "value"
    end

    it 'stores a log message for the key' do
      @store[key] = "value"
      @store.log(key).first['message'].must_equal("set '#{key}'")
    end
  end
  
  it 'creates a bare repository' do
    bare = Gaga.new(:repo => tmp_bare, :branch => :lady)
    File.exists?(File.join(tmp_bare, '.git')).must_equal false
    File.exists?(File.join(tmp_bare, 'refs')).must_equal true
    bare['key1'] = 'Value 1'
    bare['key2'] = 'Value 2'
    bare['key3'] = 'Value 3'
    bare['key1'].must_equal 'Value 1'
    bare['key2'].must_equal 'Value 2'
    bare.keys.must_equal %w(key1 key2 key3)
    bare.delete('key1')
    bare['key1'].must_be_nil
    bare.clear
    bare.keys.must_equal []
    
    remove_tmpdir!(tmp_bare)
  end

end
