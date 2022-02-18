module Isomorfeus
  module Hamster
    module Marshal
      class << self
        def dump(db, key, obj, class_cache: true)
          db.env.transaction { db.put(key, ::Oj.dump(obj, mode: :object, circular: true, class_cache: class_cache)) }
        end

        def load(db, key, class_cache: true)
          obj_j = db.get(key)
          return nil unless obj_j
          ::Oj.load(obj_j, mode: :object, circular: true, class_cache: class_cache)
        end

        def serialize(obj, class_cache: true)
          ::Oj.dump(obj, mode: :object, circular: true, class_cache: class_cache)
        end

        def unserialize(obj_j, class_cache: true)
          ::Oj.load(obj_j, mode: :object, circular: true, class_cache: class_cache)
        end
      end
    end
  end
end
