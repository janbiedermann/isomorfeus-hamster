require 'spec_helper'

describe Isomorfeus::Hamster::Marshal do
  let(:env) { Isomorfeus::Hamster.new(path) }
  after     { env.close rescue nil }
  let(:db)  { env.database }

  it 'it can dump and load a object' do
    class Whatever
      attr_accessor :something
    end
    obj = Whatever.new
    obj.something = 10
    Isomorfeus::Hamster::Marshal.dump(db, '123', obj)
    obj_load = Isomorfeus::Hamster::Marshal.load(db, '123')
    obj_load.something.should == 10
  end

  it 'it can dump and load a object with compression' do
    class Whatever
      attr_accessor :something
    end
    obj = Whatever.new
    obj.something = 10
    Isomorfeus::Hamster::Marshal.dump(db, '123', obj, compress: 5)
    obj_load = Isomorfeus::Hamster::Marshal.load(db, '123')
    obj_load.something.should == 10
  end

  it 'it can serialize and unserialize a object' do
    class Whatever
      attr_accessor :something
    end
    obj = Whatever.new
    obj.something = 10
    s = Isomorfeus::Hamster::Marshal.serialize(obj)
    obj_load = Isomorfeus::Hamster::Marshal.unserialize(s)
    obj_load.something.should == 10
  end

  it 'it can serialize and unserialize a object with compression' do
    class Whatever
      attr_accessor :something
    end
    obj = Whatever.new
    obj.something = 10
    s = Isomorfeus::Hamster::Marshal.serialize(obj, compress: 5)
    obj_load = Isomorfeus::Hamster::Marshal.unserialize(s)
    obj_load.something.should == 10
  end
end
