module Isomorfeus
  module Hamster
    module Marshal
      class << self
        BROTLI = 'b:'.freeze

        def dump(db, key, obj, class_cache: true, compress: false)
          v = ::Oj.dump(obj, mode: :object, circular: true, class_cache: class_cache)
          v = 'b:' << ::Brotli.deflate(v, quality: compress) if compress
          db.env.transaction { db.put(key, v) }
        end

        def load(db, key, class_cache: true)
          v = db.get(key)
          return nil unless v
          v = ::Brotli.inflate(v[2..]) if v.start_with?(BROTLI)
          ::Oj.load(v, mode: :object, circular: true, class_cache: class_cache)
        end

        def serialize(obj, class_cache: true, compress: false)
          v = ::Oj.dump(obj, mode: :object, circular: true, class_cache: class_cache)
          v = 'b:' << ::Brotli.deflate(v, quality: compress) if compress
          v
        end

        def unserialize(v, class_cache: true)
          v = ::Brotli.inflate(v[2..]) if v.start_with?(BROTLI)
          ::Oj.load(v, mode: :object, circular: true, class_cache: class_cache)
        end
      end
    end
  end
end
