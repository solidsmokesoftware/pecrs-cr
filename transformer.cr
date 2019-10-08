
class AbsTransformer
end

class Transformer(T) < AbsTransformer
    def initialize
        
    end

    def move(objects : Array(AbsDynamic(T)), delta : Float32)
        objects.each do |body|
            body.pos += body.dir * delta
            puts "#{body.id}: #{body.pos.x}:#{body.pos.y}"
        end
    end
end