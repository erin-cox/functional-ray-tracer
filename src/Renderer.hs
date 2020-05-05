module Renderer (newRenderer, render, tonemap) where

import Data.Maybe
import Graphics.Image as I

data Renderer = Renderer {
      width_px  :: Int,
      height_px :: Int,
      bounces   :: Int,
      bg_color  :: Color,
}

bias = 1.0e-6
default_bounces = 4
default_bg_color = color_grayscale 0.001

newRenderer :: Int -> Int -> Renderer
newRenderer w h = Renderer { width_px        = w
                           , height_px       = h
                           , bias            = defaultBias
                           , bounces         = defaultBounces
                           , backgroundColor = defaultBGColor
                           }

trace_ray :: Ray -> Scene -> Color
trace_ray ray scene = trace_ray' ray scene default_bounces

trace_ray' :: Ray -> Scene -> Int -> Color
trace_ray' ray scene bounces_left = case closest_intersection ray scene of
      Nothing -> default_bg_color
      Just (RayHit {
            rayhit_object   = object,
            rayhit_position = position,
            rayhit_normal   = normal
      }) ->
            | bounces_left == 0 || reflectivity == 0.0 = direct_illumination
            | otherwise = dvec3_add direct_illumination reflected_illumination
            where
                  direct_illumination = illuminate object scene p n o


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


-- Illuminates a point on the surface of an object with Blinn-Phong shading.
blinn_phong :: Scene -> SceneObject -> DVec3 -> DVec3 -> DVec3 -> Color
blinn_phong scene object position normal camera =
      ambient_term `color_add`
            (foldr color_add color_black $ map illuminate_light lights)
      where
            -- Scene properties
            lights = scene_lights scene
            i_a = scene_ambient_light scene
            -- Object properties
            c_diff = object_color object
            k_a   = object_phong_k_a object
            k_s   = object_phong_k_s object
            k_d   = object_phong_k_d object
            alpha = object_phong_alpha object
            -- Vectors
            n = normal
            p = position
            -- Not directly used, so no need to normalize
            v = camera `dvec3_sub` p
            ambient_term = get_ambient_term k_a c_diff i_a
            illuminate_light light
            | shadow_ray_distance < light_distance = color_black
            | otherwise = diffuse_term + specular_term where
                  -- Vectors
                  c_spec = light_color light
                  q_i = light_position light
                  l_i = dvec3_normalize $ q_i `dvec3_sub` p
                  h_i = dvec3_normalize $ l_i `dvec3_add` v
                  i_i = get_illumination light p
                  -- Shadow calculations
                  shadow_ray = new_ray (p `dvec3_add`
                        (l_i `dvec3_scale` bias)) l_i
                  shadow_ray_distance = rayhit_distance $
                        closest_intersection scene shadow_ray
                  light_distance = dvec3_magnitude $ q_i `dvec3_sub` p
                  -- Diffuse and specular term calculations
                  diffuse_term = get_diffuse_term k_d c_diff i_i n l_i
                  specular_term = get_specular_term k_s c_spec i_i n h_i

get_ambient_term :: DVec3 -> Color -> Color -> Color
get_ambient_term k_a c_diff i_a =
      k_a `color_scale_dvec3` c_diff `color_scale` i_a

get_diffuse_term :: DVec3 -> Color -> Color -> DVec3 -> DVec3 -> Color
get_diffuse_term k_d c_diff i_i n l_i =
      k_d `color_scale_dvec3` c_diff `color_scale` i_i `color_scale`
            (max 0.0 $ n `dvec3_dot` l_i)

get_specular_term :: DVec3 -> Color -> Color -> DVec3 -> DVec3 -> Color
get_specular_term k_s c_spec i_i n h_i =
      k_s `color_scale_dvec3` c_spec `color_scale` i_i `color_scale`
            (max 0.0 $ n `dvec3_dot` h_i) ** alpha


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
