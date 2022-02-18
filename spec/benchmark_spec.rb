require 'spec_helper'

describe 'benchmark' do
  let(:env)   { Isomorfeus::Hamster.new(path, mapsize: 4 * 1024 * 1024 * 1024) }
  after       { env.close rescue nil }
  let(:db)    { env.database }
  let(:count) { 10000 }

  it 'compressed dumping objects' do
    class Whatever
      attr_accessor :something
    end
    start = Time.now
    arr = []
    count.times do |i|
      obj = Whatever.new
      obj.something = i
      arr << obj
    end
    count.times do |i|
      Isomorfeus::Hamster::Marshal.dump(db, "dump#{i}", arr[i], compress: 5)
    end
    total = Time.now - start
    puts ".Compressed dumping #{count} objects took #{total}s, thats #{count/total} req/s"
    obj_load = Isomorfeus::Hamster::Marshal.load(db, "dump#{count - 1}")
    obj_load.something.should == count - 1
  end

  it 'dumping objects' do
    class Whatever
      attr_accessor :something
    end
    start = Time.now
    arr = []
    count.times do |i|
      obj = Whatever.new
      obj.something = i
      arr << obj
    end
    count.times do |i|
      Isomorfeus::Hamster::Marshal.dump(db, "dump#{i}", arr[i])
    end
    total = Time.now - start
    puts "Dumping #{count} objects took #{total}s, thats #{count/total} req/s"
    obj_load = Isomorfeus::Hamster::Marshal.load(db, "dump#{count - 1}")
    obj_load.something.should == count - 1
  end

  it 'dumping objects in one transaction' do
    class Whatever
      attr_accessor :something
    end
    start = Time.now
    arr = []
    count.times do |i|
      obj = Whatever.new
      obj.something = i
      arr << obj
    end
    db.env.transaction do
      count.times do |i|
        Isomorfeus::Hamster::Marshal.dump(db, "dump#{i}", arr[i])
      end
    end
    total = Time.now - start
    puts "Dumping in one transaction #{count} objects took #{total}s, thats #{count/total} req/s"
    obj_load = Isomorfeus::Hamster::Marshal.load(db, "dump#{count - 1}")
    obj_load.something.should == count - 1
  end

  it 'compressed loading objects' do
    class Whatever
      attr_accessor :something
    end
    count.times do |i|
      obj = Whatever.new
      obj.something = i
      Isomorfeus::Hamster::Marshal.dump(db, "load#{i}", obj, compress: 5)
    end
    start = Time.now
    count.times do |i|
      obj_load = Isomorfeus::Hamster::Marshal.load(db, "load#{i}")
    end
    total = Time.now - start
    puts "Compressed loading #{count} objects took #{total}s, thats #{count/total} req/s"
    obj_load = Isomorfeus::Hamster::Marshal.load(db, "load#{count - 1}")
    obj_load.something.should == count - 1
  end


  it 'loading objects' do
    class Whatever
      attr_accessor :something
    end
    count.times do |i|
      obj = Whatever.new
      obj.something = i
      Isomorfeus::Hamster::Marshal.dump(db, "load#{i}", obj)
    end
    start = Time.now
    count.times do |i|
      obj_load = Isomorfeus::Hamster::Marshal.load(db, "load#{i}")
    end
    total = Time.now - start
    puts "Loading #{count} objects took #{total}s, thats #{count/total} req/s"
    obj_load = Isomorfeus::Hamster::Marshal.load(db, "load#{count - 1}")
    obj_load.something.should == count - 1
  end

  it 'putting serialized objects in one transaction' do
    class Whatever
      attr_accessor :something
    end
    start = Time.now
    arr = []
    count.times do |i|
      obj = Whatever.new
      obj.something = i
      arr << obj
    end
    db.env.transaction do
      count.times do |i|
        db.put("dump_t#{i}", Isomorfeus::Hamster::Marshal.serialize(arr[i], class_cache: true))
      end
    end
    total = Time.now - start
    puts "Putting serialized objects in one transaction #{count} objects took #{total}s, thats #{count/total} req/s"
    obj_load = Isomorfeus::Hamster::Marshal.load(db, "dump_t#{count - 1}")
    obj_load.something.should == count - 1
  end

  it 'putting strings in one transaction' do
    class Whatever
      attr_accessor :something
    end
    start = Time.now
    arr = []
    count.times do |i|
      arr << i.to_s + ('a' * 37) # emulate string length of oj dump
    end
    db.env.transaction do
      count.times do |i|
        db.put("dump_t#{i}", arr[i])
      end
    end
    total = Time.now - start
    puts "Putting strings in one transaction #{count} objects took #{total}s, thats #{count/total} req/s"
  end
end
