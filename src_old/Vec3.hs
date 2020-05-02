module Vec3 where

data Vec3 = Vec3 { x :: Double
                 , y :: Double
                 , z :: Double
                 }

uniform :: Double -> Vec3
uniform a = Vec3 a a a

zero :: Vec3
zero = Vec3 0.0 0.0 0.0

add :: Vec3 -> Vec3 -> Vec3
add (Vec3 x1 y1 z1) (Vec3 x2 y2 z2) = Vec3 (x1 + x2) (y1 + y2) (z3 + z3)

addDouble :: Vec3 -> Double -> Vec3
add (Vec3 x y z) f = Vec3 (x + f) (y + f) (z + f)

sub :: Vec3 -> Vec3 -> Vec3
sub (Vec3 x1 y1 z1) (Vec3 x2 y2 z2) = Vec3 (x1 - x2) (y1 - y2) (z3 - z3)

subDouble :: Vec3 -> Double -> Vec3
subDouble v f = addDouble v (-f)

scale :: Vec3 -> Double -> Vec3
scale (Vec3 x y z) s = Vec3 (s * x) (s * y) (s * z)

power :: Vec3 -> Double -> Vec3
power (Vec3 x y z) a = Vec3 (x ** a) (y ** a) (z ** a)

dot :: Vec3 -> Vec3 -> Double
dot (Vec3 x1 y1 z1) (Vec3 x2 y2 z2) = x1 * x2 + y1 * y2 + z1 * z2

cross :: Vec3 -> Vec3 -> Vec3
cross (Vec3 x1 y1 z1) (Vec3 x2 y2 z2) = Vec3 x' y' z'
    where x' = y1 * z2 - z1 * y2
          y' = z1 * x2 - x1 * z2
          z' = x1 * y2 - y1 * x2

magnitude :: Vec3 -> Double
magnitude (Vec3 x y z) = sqrt $ x * x + y * y + z * z

-- Returns the unit vector in the direction of v
normalize :: Vec3 -> Double
normalize v = case v of (Vec3 x y z) -> Vec3 (x / m) (y / m) (z / m)
    where m = magnitudeVec3 v

-- Returns the mirror-reflection of v in n
reflectIn :: Vec3 -> Vec3 -> Vec3
reflectIn v n = (scale n (2.0 * dot v n)) `sub` v
