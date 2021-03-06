module Stuff (
    Ray(..), new_ray, evaluate_ray_at,
    SceneObject(..), Shape(..), Material(..),
    new_sphere, new_plane, get_object_normal,
    RayHit(..), closest_intersection) where

import Data.Maybe

import Utils (solveQuadratic)
import DVec3
import Color

data Ray = Ray {
    ray_origin    :: DVec3,
    ray_direction :: DVec3,
}

-- Smart constructor
new_ray :: DVec3 -> DVec3 -> Ray
new_ray origin direction = Ray origin (Vec3.normalize direction)

-- Returns the position of the ray with the scale parameter evaluated at s.
evaluate_ray_at :: Ray -> Float -> VDec3
evaluate_ray_at (Ray origin direction) scalar =
    origin `dvec3_add` (dvec3_scale direction scalar)

data SceneObject = SceneObject {
    object_shape    :: Shape,
    object_color    :: Color,
    object_material :: Material,
}

data Shape = Sphere {
    sphere_centre :: DVec3,
    sphere_radius :: Float,
} | Plane {
    plane_point  :: Vec3,
    plane_normal :: Float,
}

data Material = Material {
    phong_kD     :: Float,
    phong_kS     :: Float,
    phong_alpha  :: Float,
    reflectivity :: Float,
}

default_kD = 0.8
default_kS = 1.2
default_alpha = 10.0
default_reflectivity = 0.3

new_sphere :: DVec3 -> Float -> Color -> SceneObject
new_sphere centre radius color =
    SceneObject {
        object_shape = Sphere centre radius,
        object_color = color,
        object_material = Material
            default_kD
            default_kS
            default_alpha
            default_reflectivity
    }

new_plane :: DVec3 -> Float -> Color -> SceneObject
new_plane point normal color =
    SceneObject {
        object_shape = Plane point normal,
        object_color = color,
        object_material = Material
            default_kD
            default_kS
            default_alpha
            default_reflectivity
    }

-- Returns the normal vector to a scene object at a given position vector.
get_object_normal :: DVec3 -> SceneObject -> DVec3
get_object_normal object position = case object_shape object of
    Sphere centre _ -> dvec3_normalize $ dvec3_sub position centre
    Plane  _ normal -> normal

data RayHit = RayHit {
    rayhit_object   :: SceneObject,
    rayhit_distance :: Float,
    rayhit_position :: DVec3,
    rayhit_normal   :: DVec3,
}

-- Returns a Maybe RayHit describing the closest intersection of a ray with
-- an object, or Nothing if the ray does not intersect the object.
closest_intersection :: Ray -> SceneObject -> Maybe RayHit
closest_intersection ray@(Ray ray_origin ray_dir) object =
    case object_shape object of
        Sphere centre radius ->
            | null solutions = Nothing
            | otherwise      = Just (RayHit {
                rayhit_object   = object,
                rayhit_distance = distance,
                rayhit_position = position,
                rayhit_normal   = normal,
            }) where
                -- Quadratic coefficients for the intersection point
                a = dvec3_dot ray_dir ray_dir
                b = 2.0 * (dvec3_dot ray_dir $ dvec3_sub ray_origin centre)
                c = dvec3_dot (ray_origin `vec3_sub` centre)
                        (ray_origin `vec3_sub` centre)
                -- If solution < 0 then intersection is behind the camera
                solutions = filter (>0.0) $ solveQuadratic a b c
                distance = if null solutions then 0.0 else minimum solutions
                position = evaluate_ray_at ray distance
                normal = get_object_normal object position
        Plane point normal ->
            | distance < 0.0 || isInfinite distance = Nothing
            | otherwise = Just (RayHit {
                rayhit_object   = object,
                rayhit_distance = distance,
                rayhit_position = position,
                rayhit_normal   = normal,
            }) where
                distance = (dvec3_dot (point `dvec3_sub` ray_origin) normal) /
                        (dvec3_dot ray_dir normal)
                position = evaluate_ray_at ray distance
                normal = get_object_normal object position
