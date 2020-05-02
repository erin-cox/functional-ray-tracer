module RayHit where

data RayHit = RayHit { objectHit :: SceneObject
                     , distance  :: Float
                     , location  :: Vec3
                     , normal    :: Vec3
                     }

