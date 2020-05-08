module Renderer (
      trace_ray, blinn_phong
) where

import Data.Maybe
import Graphics.Image as I

-- Probably have as command line arguments: width and height in px and bounce count.
-- In the scene file: camera position, direction, fov, etc.

standard_bias = 1.0e-6
default_bounces = 4
default_bg_color = color_grayscale 0.001

-- Traces a ray through a scene with the specified number of bounces.
-- Calls itself recursively to handle reflections.
trace_ray :: Ray -> Scene -> Int -> Color
trace_ray ray scene bounces_left = case closest_intersection ray scene of
      Nothing     -> bg_color
      Just rayhit ->
            | bounces_left == 0 || reflectivity == 0.0 = direct_light
            | otherwise = direct_light + reflected_light
            where
                  bg_color = scene_bg_color scene
                  -- Rayhit properties
                  object = rayhit_object rayhit
                  p = rayhit_position rayhit
                  n = rayhit_normal rayhit
                  i = ray_direction ray
                  -- Reflection stuff
                  reflectivity = object_reflectivity object
                  r = dvec3scale (-1.0) $
                        dvec3_reflect_in (ray_direction ray) n
                  reflected_ray = new_ray
                        (p`vec3_add` (dvec3_scale standard_bias r)) r
                  -- Light components
                  direct_light = color_scale (1.0 - reflectivity) $
                        blinn_phong scene rayhit camera
                  reflected_light = color_scale reflectivity $
                        trace_ray reflected_ray scene (bounces_left - 1)

get_reflected_ray :: DVec3 -> DVec3 -> Double -> DVec3
get_reflected_ray i n =
      i `dvec3_add` (dvec3_scale (2 * dvec3_dot i n) n

get_refracted_ray :: DVec3 -> DVec3 -> Double -> Double -> Maybe DVec3
get_refracted_ray i n eta_1 eta_2
      | sq_sin_theta_t > 1 = Nothing
      | otherwise          = Just t where
            t = dvec3_scale eta_ratio i + dvec3_scale (
                  eta_ratio * cos_theta_i - sqrt (1 - sq_sin_theta_t)
                  ) n
            eta_ratio = eta_1 / eta_2
            cos_theta_i = negate $ dvec3_dot i n
            sq_sin_theta_t = eta_ratio * eta_ratio *
                  (1 - cos_theta_i * cos_theta_i)


-- Illuminates a point on a surface with Blinn-Phong shading
-- and returns the color of the surface. Supports shadows.
blinn_phong :: Scene -> RayHit -> Camera -> Color
blinn_phong scene rayhit camera =
      ambient_term `color_add`
            (foldr color_add color_black $ map illuminate_light lights)
      where
            -- Scene properties
            lights = scene_lights scene
            i_a = scene_ambient_light scene
            -- Object properties
            object = rayhit_object object
            c_diff = object_color object
            k_a    = object_phong_k_a object
            k_s    = object_phong_k_s object
            k_d    = object_phong_k_d object
            alpha  = object_phong_alpha object
            -- Vectors
            p = rayhit_position rayhit
            n = rayhit_normal rayhit
            -- Not directly used, so no need to normalize
            v = camera_position camera `dvec3_sub` p
            ambient_term = get_ambient_term k_a c_diff i_a
            -- Run once over each light
            illuminate_light light
            | in_shadow = color_black
            | otherwise = diffuse_term + specular_term where
                  -- Vectors
                  c_spec = light_color light
                  q_i    = light_position light
                  l_i    = dvec3_normalize $ q_i `dvec3_sub` p
                  h_i    = dvec3_normalize $ l_i `dvec3_add` v
                  i_i    = get_illumination light p
                  -- Shadow calculations
                  in_shadow     = is_in_shadow scene p q_i l_i
                  diffuse_term  = get_diffuse_term k_d c_diff i_i n l_i
                  specular_term = get_specular_term k_s c_spec i_i n h_i

-- Determines whether a point p is in shadow from a light at position p.
is_in_shadow :: Scene -> DVec3 -> DVec3 -> DVec3 -> Bool
is_in_shadow scene p q_i l_i =
      shadow_ray_distance < light_distance where
            shadow_ray = new_ray (p `dvec3_add`
                  (l_i `dvec3_scale` standard_bias)) l_i
            shadow_ray_distance = rayhit_distance $
                  closest_intersection scene shadow_ray
            light_distance = dvec3_magnitude $ q_i `dvec3_sub` p

-- Calculates each term of the Blinn-Phong illumination model formula.
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
