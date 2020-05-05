module Scene (Scene(..), closestIntersection) where

import Data.Maybe

import Types
import qualified SceneObject
import qualified PointLight
import qualified Color

data Scene = Scene { objects      :: [SceneObject]
                   , point_lights  :: [PointLight]
                   , scene_ambient_light :: Color
                   }

closestIntersection :: Ray -> Scene -> Maybe RayHit
closestIntersection ray (Scene { objects = os })
    | null intersections = Nothing
    | otherwise          = Just $ minimum intersections
    where intersections  = map (\o -> ray_intersection_with o ray) os
