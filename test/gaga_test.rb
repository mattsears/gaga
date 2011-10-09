$:.unshift File.dirname(__FILE__)
require 'helper'

describe Gaga do

  @types = {
    "String" => ["lady", "gaga"],
    "Object" => [{:lady => :gaga}, {:gaga => :ohai}]
  }

  before do
    @store = Gaga.new(:repo => tmp_dir)
    @store.clear
  end

  @types.each do |type, (key, key2)|

    it "writes String values to keys" do
      @store[key] = "value"
      @store[key].must_equal "value"
    end

    it "reads from keys" do
      @store[key].must_be_nil
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

    it "returns a list of commit history for the key" do
      @store.log(key).wont_be_empty
    end
  end

end
