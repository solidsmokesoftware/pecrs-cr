require "./body"
require "./shape"
require "./space"


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


class Collider < AbsCollider
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

  #Line-Line collision
  def check(a1 : Vector, a2 : Vector, b1 : Vector, b2 : Vector)
    a = a1 - a2
    b = b1 - b2

    cross = a.cross b

    if cross == 0
      return false
    end
    
    c = a1 - b1
    t = (c.cross a) / cross
    if t > 1 || t < 0
      return false
    end

    u = (c.cross b) / cross
    if t > 1 || t < 0
      return false
    end

    intersection = a1 + (b * t)
    return true
  end

  #Todo line collisions between all the shapes.
  #Todo later - ULine and URect collisions. Not a high priority.


  def check(shape : Point, pos : Vector, shape_other : Line, pos_other : Vector)
  end
  def check(shape : Point, pos : Vector, shape_other : ULine, pos_other : Vector)
  end
  def check(shape : Point, pos : Vector, shape_other : URect, pos_other : Vector)
  end
  def check(shape : Line, pos : Vector, shape_other : Point, pos_other : Vector)
  end
  def check(shape : Line, pos : Vector, shape_other : Line, pos_other : Vector)
  end
  def check(shape : Line, pos : Vector, shape_other : ULine, pos_other : Vector)
  end
  def check(shape : Line, pos : Vector, shape_other : Rect, pos_other : Vector)
  end
  def check(shape : Line, pos : Vector, shape_other : URect, pos_other : Vector)
  end
  def check(shape : Line, pos : Vector, shape_other : Circle, pos_other : Vector)
  end
  def check(shape : ULine, pos : Vector, shape_other : Point, pos_other : Vector)
  end
  def check(shape : ULine, pos : Vector, shape_other : Line, pos_other : Vector)
  end
  def check(shape : ULine, pos : Vector, shape_other : ULine, pos_other : Vector)
  end
  def check(shape : ULine, pos : Vector, shape_other : Rect, pos_other : Vector)
  end
  def check(shape : ULine, pos : Vector, shape_other : URect, pos_other : Vector)
  end
  def check(shape : ULine, pos : Vector, shape_other : Circle, pos_other :  Vector)
  end
  def check(shape : Rect, pos : Vector, shape_other : Line, pos_other : Vector)
  end
  def check(shape : Rect, pos : Vector, shape_other : ULine, pos_other : Vector)
  end
  def check(shape : Rect, pos : Vector, shape_other : URect, pos_other : Vector)
  end
  def check(shape : URect, pos : Vector, shape_other : Point, pos_other : Vector)
  end
  def check(shape : URect, pos : Vector, shape_other : Line, pos_other : Vector)
  end
  def check(shape : URect, pos : Vector, shape_other : ULine, pos_other : Vector)
  end
  def check(shape : URect, pos : Vector, shape_other : Rect, pos_other : Vector)
  end
  def check(shape : URect, pos : Vector, shape_other : URect, pos_other : Vector)
  end
  def check(shape : URect, pos : Vector, shape_other : Circle, pos_other :  Vector)
  end
  def check(shape : Circle, pos : Vector, shape_other : Line, pos_other : Vector)
  end
  def check(shape : Circle, pos : Vector, shape_other : ULine, pos_other : Vector)
  end
  def check(shape : Circle, pos : Vector, shape_other : URect, pos_other : Vector)
  end

end#class






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
