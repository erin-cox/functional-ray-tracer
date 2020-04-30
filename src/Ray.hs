module Ray (newRay, evaluateAt) where

data Ray = Ray { origin    :: Vec3
               , direction :: Vec3
               }

newRay :: Vec3 -> Vec3 -> Ray
newRay o dir = Ray o (Vec3.normalize dir)

-- Returns the position of the ray with the scale parameter evaluated at s.
evaluateAt :: Ray -> Float -> Vec3
evaluateAt (Ray o dir) s = o `Vec3.add` (Vec3.scale dir s)
