module Isomorfeus
  module Hamster
    module Marshal
      class << self
        def dump(db, key, obj)
          db.env.transaction { db.put(key, ::Oj.dump(obj)) }
        end

        def load(db, key)
          obj_j = db.get(key)
          return nil unless obj_j
          ::Oj.load(obj_j)
        end
      end
    end
  end
end
