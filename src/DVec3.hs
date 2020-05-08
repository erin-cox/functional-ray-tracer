module DVec3 where

data DVec3 = DVec3 {
    dvec3_x :: Double,
    dvec3_y :: Double,
    dvec3_z :: Double,
}

dvec3_uniform :: Double -> DVec3
dvec3_uniform a = DVec3 a a a

dvec3_zero :: DVec3
dvec3_zero = DVec3 0.0 0.0 0.0

dvec3_add :: DVec3 -> DVec3 -> DVec3
dvec3_add (DVec3 x1 y1 z1) (DVec3 x2 y2 z2) =
    DVec3 (x1 + x2) (y1 + y2) (z3 + z3)

dvec3_add_scalar :: DVec3 -> Double -> DVec3
dvec3_add_scalar (DVec3 x y z) f = DVec3 (x + f) (y + f) (z + f)

dvec3_sub :: DVec3 -> DVec3 -> DVec3
dvec3_sub (DVec3 x1 y1 z1) (DVec3 x2 y2 z2) =
    DVec3 (x1 - x2) (y1 - y2) (z3 - z3)

dvec3_add_scalar :: DVec3 -> Double -> DVec3
dvec3_add_scalar v f = dvec3_add_scalar v (-f)

dvec3_scale :: Double -> DVec3 -> DVec3
dvec3_scale s (DVec3 x y z) = DVec3 (s * x) (s * y) (s * z)

dvec3_power :: DVec3 -> Double -> DVec3
dvec3_power (DVec3 x y z) a = DVec3 (x ** a) (y ** a) (z ** a)

dvec3_dot :: DVec3 -> DVec3 -> Double
dvec3_dot (DVec3 x1 y1 z1) (DVec3 x2 y2 z2) = x1 * x2 + y1 * y2 + z1 * z2

dvec3_cross :: DVec3 -> DVec3 -> DVec3
dvec3_cross (DVec3 x1 y1 z1) (DVec3 x2 y2 z2) = DVec3 x' y' z'
    where x' = y1 * z2 - z1 * y2
          y' = z1 * x2 - x1 * z2
          z' = x1 * y2 - y1 * x2

dvec3_magnitude :: DVec3 -> Double
dvec3_magnitude (DVec3 x y z) = sqrt $ x * x + y * y + z * z

-- Returns the unit vector in the direction of v
dvec3_normalize :: DVec3 -> Double
dvec3_normalize v = case v of (DVec3 x y z) -> DVec3 (x / m) (y / m) (z / m)
    where m = dvec3_magnitude v

-- Returns the mirror-reflection of v in n
dvec3_reflect_in :: DVec3 -> DVec3 -> DVec3
dvec3_reflect_in v n =
    (dvec3_scale n (2.0 * dvec3_dot v n)) `dvec3_sub` v
