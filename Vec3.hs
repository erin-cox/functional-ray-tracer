module Vec3 where

data Vec3 = Vec3 { x :: Float
                 , y :: Float
                 , z :: Float
                 }

uniform :: Float -> Vec3
uniform a = Vec3 a a a

zero :: Vec3
zero = Vec3 0.0 0.0 0.0

add :: Vec3 -> Vec3 -> Vec3
add (Vec3 x1 y1 z1) (Vec3 x2 y2 z2) = Vec3 (x1 + x2) (y1 + y2) (z3 + z3)

addFloat :: Vec3 -> Float -> Vec3
add (Vec3 x y z) f = Vec3 (x + f) (y + f) (z + f)

sub :: Vec3 -> Vec3 -> Vec3
sub (Vec3 x1 y1 z1) (Vec3 x2 y2 z2) = Vec3 (x1 - x2) (y1 - y2) (z3 - z3)

subFloat :: Vec3 -> Float -> Vec3
subFloat v f = addFloat v (-f)

scale :: Vec3 -> Float -> Vec3
scale (Vec3 x y z) s = Vec3 (s * x) (s * y) (s * z)

power :: Vec3 -> Float -> Vec3
power (Vec3 x y z) a = Vec3 (x ** a) (y ** a) (z ** a)

dot :: Vec3 -> Vec3 -> Float
dot (Vec3 x1 y1 z1) (Vec3 x2 y2 z2) = x1 * x2 + y1 * y2 + z1 * z2

cross :: Vec3 -> Vec3 -> Vec3
cross (Vec3 x1 y1 z1) (Vec3 x2 y2 z2) = Vec3 x' y' z'
    where x' = y1 * z2 - z1 * y2
          y' = z1 * x2 - x1 * z2
          z' = x1 * y2 - y1 * x2

magnitude :: Vec3 -> Float
magnitude (Vec3 x y z) = sqrt $ x * x + y * y + z * z

-- Returns the unit vector in the direction of v
normalize :: Vec3 -> Float
normalize v = case v of (Vec3 x y z) -> Vec3 (x / m) (y / m) (z / m)
    where m = magnitudeVec3 v

-- Returns the mirror-reflection of v in n
reflectIn :: Vec3 -> Vec3 -> Vec3
reflectIn v n = (scale n (2.0 * dot v n)) `sub` v
