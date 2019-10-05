abstract class AbsPairList
end

class PairList(K, V) < AbsPairList
    property keys : Array(K)
    property values : Array(V)

    def initialize
        @keys = Array(K).new
        @values = Array(V).new
    end

    def add(k : K, v : V)
        @keys << k
        @values << v
    end

    def len
        @keys.size
    end

    def range
        0..len-1
    end

    def has(k : K)
        @keys.index { |i| i == k }
    end

    def has!(i : Int32)
        @keys[i]
    end

    def set!(i : Int32, v : V)
        @values[i] = v
    end

    def set(k : K, v : V)
        i = has k
        if i
            set! i, v
        else
            add k, v
        end
    end

    def get!(i : Int32)
        @values[i]
    end

    def get(k : K)
        i = has k
        get! i.as Int32
    end

    def get?(k : K)
        i = has k
        if i
            get! i
        else
            nil
        end
    end

    def pair!(i : Int32)
        Tuple.new(has!(i), get!(i))
    end

    def pair(k : K)
        i = has k
        pair! i.as Int32
    end

    def pair?(k : K)
        i = has k
        if i
            pair! i
        else
            nil
        end
    end

    def pop
        @keys.pop
        @values.pop
    end

    def del!(i : Int32)
        @keys.delete_at i
        @values.delete_at i
    end

    def del(k : K)
        i = has k
        if i
            del! i
            true
        else
            false
        end
    end
end

