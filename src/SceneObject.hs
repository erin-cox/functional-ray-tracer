module SceneObject (newSphere, newPlane, intersectionWith, getNormalAt) where

import Data.Maybe

import Utils (solveQuadratic)
import qualified Vec3
import Vec3 (Vec3)
import qualified Ray
import Ray (Ray)
import qualified Color
import Color (Color)

data SceneObject = Sphere { centre       :: Vec3
                          , radius       :: Float
                          , color        :: Color
                          , phong_kD     :: Float
                          , phong_kS     :: Float
                          , phongAlpha   :: Float
                          , reflectivity :: Float
                          }
                 | Plane { point        :: Vec3
                         , normal       :: Float
                         , color        :: Color
                         , phong_kD     :: Float
                         , phong_kS     :: Float
                         , phongAlpha   :: Float
                         , reflectivity :: Float
                         }

defaultSphere_kD = 0.8
defaultSphere_kS = 1.2
defaultSphereAlpha = 10.0
defaultSphereReflectivity = 0.3

defaultPlane_kD = 0.6
defaultPlane_kS = 0.0
defaultPlaneAlpha = 10.0
defaultPlaneReflectivity = 0.3

newSphere :: Vec3 -> Float -> Color -> SceneObject
newSphere c r color = Sphere { centre       = c
                             , radius       = r
                             , color        = color
                             , phong_kD     = defaultSphere_kD
                             , phong_kS     = defaultSphere_kS
                             , phongAlpha   = defaultSphereAlpha
                             , reflectivity = defaultSphereReflectivity
                             }

newPlane :: Vec3 -> Float -> Color -> SceneObject
newPlane a n color = Plane { point        = a
                           , normal       = n
                           , color        = color
                           , phong_kD     = defaultPlane_kD
                           , phong_kS     = defaultPlane_kS
                           , phongAlpha   = defaultPlaneAlpha
                           , reflectivity = defaultPlaneReflectivity
                           }

intersectionWith :: SceneObject -> Ray -> Maybe RayHit
intersectionWith object ray = case (object, ray) of
    (Sphere { centre = c, radius = r }, Ray o dir) ->
        | null solutions = Nothing
        | otherwise = Just (RayHit object distance position normal)
        where a = Vec3.dot dir dir
            b = 2.0 * (Vec3.dot dir (Vec3.sub o c))
            c = Vec3.dot (o `Vec3.sub` c) (o `Vec3.sub` c)
            -- If solution < 0 then the intersection is behind the camera
            solutions = filter (>0.0) (solveQuadratic a b c)
            distance = if null solutions then 0.0 else minimum solutions
            position = Ray.evaluateAt ray distance
            normal   = getNormalAt object position
    (Plane { point = a, normal = n }, Ray o dir) ->
        | distance < 0.0 || isInfinite distance = Nothing
        | otherwise = Just (RayHit object distance position normal)
        where distance = (Vec3.dot (Vec3.sub a o) n) / (Vec3.dot dir n)
              position = Ray.evaluateAt ray distance
              normal   = getNormalAt object position

getNormalAt :: SceneObject -> Vec3 -> Vec3
getNormalAt (Sphere { centre = c, radius = r }) pos = Vec3.normalize $ Vec3.sub pos c
getNormalAt (Plane { point = a, normal = n }) pos = n
