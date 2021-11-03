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

        def structured_dump(db, obj)
          kv = []
          oc = obj.class.to_s
          ky = obj.key
          as = obj.attributes
          kv << [ats_key(oc, ky), ::Oj.dump(as)]
          as.each do |at|
            kv << [at_key(oc, ky, at), ::Oj.dump(obj.send(at))]
          end
          db.env.transaction do
            kv.each do |k, v|
              db.put(k, v)
            end
          end
        end

        def structured_load(db, oc, ky)
          if oc.class = String
            oC = const_get(oc)
          else
            oC = oc
            oc = oc.to_s
          end
          ak = ats_key(oc, ky)
          oh = {}
          db.env.transaction do
            as_j = db.get(ak)
            as = ::Oj.load(as_j)
            as.each do |at|
              v_j = db.get(at_key(oc, ky, at))
              oh[at] = ::Oj.load(v_j)
            end
          end
          oC.instance_from_hash(oh)
        end

        private

        def ats_key(oc, ky)
          "#{oc}|#{ky}|attributes"
        end

        def at_key(oc, ky, at)
          "#{oc}|#{ky}|:|#{at}"
        end
      end
    end
  end
end
