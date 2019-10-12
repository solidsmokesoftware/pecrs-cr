require "./body"
require "./shapes"
require "./space"

#TODO/Working on
#Adding bucket switching in the hashmap
#Optimizing the hashmap by looping through buckets together to avoid recalcuating area and to reduce bucket lookups
#ie 1 lookup per bucket instead of 1 lookup per body
#Need to manage the spatial hash to keep it sparce, delete keys:values when empty 
#OR keep a list of occupied buckets, think that might be better


struct Collision
  property value : {AbsBody, AbsBody}

  def initialize(@value)
  end

  def initialize(a : AbsBody, b : AbsBody)
    @value = {a, b}
  end

  def to_s
    "#{a.id}:#{b.id}"
  end
end


abstract class AbsCollider
end


abstract class AbsSpaceCollider < AbsCollider
end


abstract class AbsShapeCollider < AbsCollider
end


class SpaceCollider < AbsSpaceCollider 
  property collider : ShapeCollider

  def initialize
    @collider = ShapeCollider.new
  end

  def check(space : AbsSpace)
    collisions = Array(Collision).new
    relocations = Array(AbsBody).new
    
    space.grid.each do |pair|
      search_space = space.get!(pair[0], 1)  
      pair[1].each do |body|
        if body.area != pair[0]
          relocations << body
        end

        search_space.each do |other|
          if body.id != other.id
            if @collider.check body, other
              collisions << Collision.new body, other
              body.collision other
            end
          end
        end
      end
    end
    puts relocations
    relocations.each do |body|
      space.set body, body.area
    end
    puts collisions
    collisions
  end

end#class


class ShapeCollider < AbsShapeCollider
  def dist(x1 : Int32, y1 : Int32, x2 : Int32, y2 : Int32)
    dx = x1 - x2
    dy = y1 - y2
    Math.sqrt ((dx * dx) + (dy * dy))
  end

  def dist(x1 : Float32, y1 : Float32, x2 : Float32, y2 : Float32)
    dx = x1 - x2
    dy = y1 - y2
    Math.sqrt ((dx * dx) + (dy * dy))
  end

  def dist(s : Vector, o : Vector)
    dist s.x, s.y, o.x, o.y
  end

  def dist(s : AbsBody, o : AbsBody)
    dist s.pos.x, s.pos.y, o.pos.x, o.pos.y
  end

  def check(s : AbsBody, o : AbsBody)
    check s.shape, s.pos, o.shape, o.pos
  end

  #Point-Point collision
  def check(shape : Point, pos : Vector, shape_other : Point, pos_other : Vector)
    if pos.x == pos_other.x && pos.y == pos_other.y
      true
    else
      false
    end
  end
  
  #Point-Rect collision
  def check(shape : Point, pos : Vector, shape_other : Rect, pos_other : Vector)
    if pos.x > pos_other.x &&
      pos.x < pos_other.x + shape_other.w &&
      pos.y > pos_other.y &&
      pos.y < pos_other.y + shape_other.h
      true
    else
      false
    end
  end

  #Point-Circle collision
  def check(shape : Point, pos : Vector, shape_other : Circle, pos_other : Vector)
    dx = pos.x - pos_other.x
    dy = pos.y - pos_other.y
    if dx * dx + dy * dy < shape_other.r * shape_other.r
      true
    else
      false
    end
  end

  #Rect-Point collision
  def check(shape : Rect, pos : Vector, shape_other : Point, pos_other : Vector)
    check shape_other, pos_other, shape, pos
  end

  #Rect-Rect collision
  def check(shape : Rect, pos : Vector, shape_other : Rect, pos_other : Vector)
    if pos.x < pos_other.x + shape_other.w &&
      pos.x + shape.w > pos_other.x &&
      pos.y < pos_other.y + shape_other.h &&
      pos.y + shape.h > pos_other.y
      true
    else
      false
    end
  end

  #Rect-Circle collision
  def check(shape : Rect, pos : Vector, shape_other : Circle, pos_other : Vector)
    if pos.x > pos_other.x
      x = pos.x + shape.w
    elsif pos.x < pos_other.x
      x = pos.x
    else
      x = pos_other.x
    end
        
    if pos.y > pos_other.y
      y = pos.y + shape.h
    elsif pos.y < pos_other.x
      y = pos.y
    else
      y = pos_other.y
    end

    dx = pos.x - pos_other.x
    dy = pos.y - pos_other.y
    if dx * dx + dy * dy < shape_other.r * shape_other.r
      true
    else
      false
    end
  end

  #Circle-Point collision
  def check(shape : Circle, pos : Vector, shape_other : Point, pos_other : Vector)
    check shape_other, pos_other, shape, pos_other
  end

  #Circle-Rect collision
  def check(shape : Circle, pos : Vector, shape_other : Rect, pos_other : Vector)
    check shape_other, pos_other, shape, pos
  end

  #Circle-Circle collision
  def check(shape : Circle, pos : Vector, shape_other : Circle, pos_other : Vector)
    dx = pos.x - pos_other.x
    dy = pos.y - pos_other.y
    rs = shape.r + shape_other.r
    if dx * dx + dy * dy < rs * rs
      true
    else
      false
    end
  end

end#class





  # #Line-line collision
  # def check(shape : Vector, pos : Vector, shape_other : Vector : pos_other : Vector)
  #   a = pos - shape
  #   b = pos_other - shape_other

  #   cross = a.cross b

  #   if cross == 0
  #     return false
  #   end
    
  #   c = shape - shape_other
  #   t = (c.cross a) / cross
  #   if t > 1 || t < 0
  #     return false
  #   end

  #   u = (c.cross b) / cross
  #   if t > 1 || t < 0
  #     return false
  #   end

  #   intersection = shape + t * b
  #   return true
  # end

  # #Line-Line collision alt
  # def check_alt(shape : Vector, pos : Vector, shape_other : Vector : pos_other : Vector)
  #   #TODO check
  #   denom = ((b.X - a.X) * (d.Y - c.Y)) - ((b.Y - a.Y) * (d.X - c.X))
  #   numer1 = ((a.Y - c.Y) * (d.X - c.X)) - ((a.X - c.X) * (d.Y - c.Y))
  #   numer2 = ((a.Y - c.Y) * (b.X - a.X)) - ((a.X - c.X) * (b.Y - a.Y))

  #   // Detect coincident lines (has a problem, read below)
  #   if denom == 0 
  #     numer1 == 0 && numer2 == 0
  #   else
  #     r = numer1 / denom;
  #     s = numer2 / denom;
        
  #     if (r >= 0 && r <= 1) && (s >= 0 && s <= 1)
  #       true
  #     else
  #       false
  #     end
  #   end
  # end

  # #Line-Rect collision
  # def check(shape : Vector, pos : Vector, shape_other : Rect, pos_other : Vector)
  #   #TODO check
 
 
#     __device__ float rayBoxIntersect ( float3 rpos, float3 rdir, float3 vmin, float3 vmax )
#     {
#    float t[10];
#    t[1] = (vmin.x - rpos.x)/rdir.x;
#    t[2] = (vmax.x - rpos.x)/rdir.x;
#    t[3] = (vmin.y - rpos.y)/rdir.y;
#    t[4] = (vmax.y - rpos.y)/rdir.y;
#    t[5] = (vmin.z - rpos.z)/rdir.z;
#    t[6] = (vmax.z - rpos.z)/rdir.z;
#    t[7] = fmax(fmax(fmin(t[1], t[2]), fmin(t[3], t[4])), fmin(t[5], t[6]));
#    t[8] = fmin(fmin(fmax(t[1], t[2]), fmax(t[3], t[4])), fmax(t[5], t[6]));
#    t[9] = (t[8] < 0 || t[7] > t[8]) ? NOHIT : t[7];
#    return t[9];
# }



# bool AABB::intersects( const Ray& ray )
# {
#   // EZ cases: if the ray starts inside the box, or ends inside
#   // the box, then it definitely hits the box.
#   // I'm using this code for ray tracing with an octree,
#   // so I needed rays that start and end within an
#   // octree node to COUNT as hits.
#   // You could modify this test to (ray starts inside and ends outside)
#   // to qualify as a hit if you wanted to NOT count totally internal rays
#   if( containsIn( ray.startPos ) || containsIn( ray.getEndPoint() ) )
#     return true ; 

#   // the algorithm says, find 3 t's,
#   Vector t ;

#   // LARGEST t is the only one we need to test if it's on the face.
#   for( int i = 0 ; i < 3 ; i++ )
#   {
#     if( ray.direction.e[i] > 0 ) // CULL BACK FACE
#       t.e[i] = ( min.e[i] - ray.startPos.e[i] ) / ray.direction.e[i] ;
#     else
#       t.e[i] = ( max.e[i] - ray.startPos.e[i] ) / ray.direction.e[i] ;
#   }

#   int mi = t.maxIndex() ;
#   if( BetweenIn( t.e[mi], 0, ray.length ) )
#   {
#     Vector pt = ray.at( t.e[mi] ) ;

#     // check it's in the box in other 2 dimensions
#     int o1 = ( mi + 1 ) % 3 ; // i=0: o1=1, o2=2, i=1: o1=2,o2=0 etc.
#     int o2 = ( mi + 2 ) % 3 ;

#     return BetweenIn( pt.e[o1], min.e[o1], max.e[o1] ) &&
#            BetweenIn( pt.e[o2], min.e[o2], max.e[o2] ) ;
#   }

#   return false ; // the ray did not hit the box.
# }




#   end

#   #Rect-Line collision
#   def check(shape : Rect, pos : Vector, shape_other : Vector, pos_other : Vector)
#   end

#   #Line-Circle collision
#   def check(shape : Vector, pos : Vector, shape_other : Circle, pos_other : Vector)
#   end

#   #Circle-Line collision
#   def check(shape : Circle, pos : Vector, shape_other : Vector, pos_other : Vector)
#     #Test circle-point collision
#     boolean inside1 = pointCircle(x1,y1, cx,cy,r);
#     boolean inside2 = pointCircle(x2,y2, cx,cy,r);
#     if (inside1 || inside2) return true;
    
#     #Find dist to closest point
#     float distY = y1 - y2;
#     float len = sqrt( (distX*distX) + (distY*distY) );

#     #Dot product of two vectors
#     float dot = ( ((cx-x1)*(x2-x1)) + ((cy-y1)*(y2-y1)) ) / pow(len,2);

#     #Closest point on a circle
#     float closestX = x1 + (dot * (x2-x1));
#     float closestY = y1 + (dot * (y2-y1));

#     boolean onSegment = linePoint(x1,y1,x2,y2, closestX,closestY);
#     if (!onSegment) return false;

#     distX = closestX - cx;
#     distY = closestY - cy;
#     float distance = sqrt( (distX*distX) + (distY*distY) );

#     if (distance <= r) {
#     return true;
#      }
#     return false;
#   end
