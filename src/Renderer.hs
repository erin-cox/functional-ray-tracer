module Renderer (newRenderer, render, tonemap) where

import Data.Maybe
import Graphics.Image as I

import Types
import qualified Vec3
import qualified Color
import qualified Ray
import qualified Scene
import qualified RayHit
import qualified SceneObject

data Renderer = Renderer { width_px        :: Int
                         , height_px       :: Int
                         , bias            :: Float
                         , bounces         :: Int
                         , backgroundColor :: Color
                         }

defaultBias = 0.0001
defaultBounces = 3
defaultBGColor = Color.grayScale 0.001

newRenderer :: Int -> Int -> Renderer
newRenderer w h = Renderer { width_px        = w
                           , height_px       = h
                           , bias            = defaultBias
                           , bounces         = defaultBounces
                           , backgroundColor = defaultBGColor
                           }

trace :: Renderer -> Ray -> Scene -> Int -> Color
trace renderer ray scene bouncesLeft = case Scene.closestIntersection ray scene of
    Nothing -> backgroundColor renderer
    Just (RayHit { objectHit = object, location = p, normal = n }) ->
        | bouncesLeft == 0 || reflectivity == 0.0 = directIllumination
        | otherwise = Vec3.add scaledDirectIllumination scaledReflectedIllumination
        where scaledDirectIllumination = Vec3.scale directIllumination (1.0 - reflectivity)
              scaledReflectedIllumination = Vec3.scale reflectedIllumination reflectivity
              directIllumination = illuminate renderer scene object p n o
              reflectedIllumination = trace scene reflectedRay (bouncesLeft - 1)
              reflectivity = SceneObject.reflectivity object
              o = Ray.origin ray
              reflectedRay = Ray.newRay (Vec3.add p (Vec3.scale r (bias renderer))) r
              r = Vec3.scale (Ray.reflectIn (Ray.direction ray) n)) 1.0

-- p, n, o: point of contact, normal to point of contact, origin of ray
illuminate :: Renderer -> Scene -> SceneObject -> Vec3 -> Vec3 -> Vec3 -> Color
illuminate renderer scene object p n o = foldr Color.add Color.black $ illuminateLight (Scene.pointLights scene)
  where c_diff = SceneObject.color object
        i_a = Scene.ambientLight scene
        k_d = SceneObject.phong_kD object
        k_s = SceneObject.phong_kS object
        alpha = SceneObject.phongAlpha object
        illuminateLight light
          | shadowRayDistance < distanceToLight = ambient
          | otherwise                           = ambient + diffuse + specular
          where shadowRayDistance = RayHit.distance $ Scene.closestIntersection scene shadowRay
                shadowRay = newRay (p `Vec3.add` (l `Vec3.scale` (bias renderer))) l
                distanceToLight = Vec3.magnitude $ (PointLight.position light) `Vec3.sub` p
                ambient = Color.scale c_diff i_a
                diffuse = c_diff `Color.scale` k_d `Color.scale` i `Color.scale` (max 0.0 $ n `Vec3.dot` l)
                specular = c_spec `Color.scale` k_s `Color.scale` i `Color.scale` ((max 0.0 $ r `Vec3.dot` v) ** alpha)
                l = Vec3.normalize $ (PointLight.position light) `Vec3.sub` p
                r = Vec3.normalize $ l `Vec3.reflectIn` n
                v = Vec3.normalize $ o `Vec3.sub` p
                c_spec = PointLight.color light

render renderer scene = -- create image of array of pixels
  where camera = Camera.newCamera (width_px renderer) (height_px renderer)
        where ray = Camera.castRay camera x y
              linearRGB = trace renderer ray scene (bounces renderer)
              gammaRGB  = tonemap linearRGB

-- Copied blindly from tick 1
tonemap :: Color -> Color
tonemap linearRGB = displayRGB ** invGamma
  where displayRGB = powRGB `Vec3.scale` (Vec3.inv (powRGB `Vec3.add` ((0.5 / a) ** b)))
        powRGB = `Vec3.power` linearRGB b
        invGamma = 1.0 / 2.2
        a = 2.0 -- controls brightness
        b = 1.3 -- controls contrast
