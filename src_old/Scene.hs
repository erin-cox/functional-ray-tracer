module Scene (Scene(..), closestIntersection) where

import Data.Maybe

import Types
import qualified SceneObject
import qualified PointLight
import qualified Color

data Scene = Scene { objects      :: [SceneObject]
                   , pointLights  :: [PointLight]
                   , ambientLight :: Color
                   }

closestIntersection :: Ray -> Scene -> Maybe RayHit
closestIntersection ray (Scene { objects = os })
    | null intersections = Nothing
    | otherwise          = Just $ minimum intersections
    where intersections  = map (\o -> SceneObject.intersectionWith o ray) os
