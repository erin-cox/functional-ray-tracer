module PointLight (newPointLight, getIlluminationAt) where

data PointLight = { position  :: Vec3
                  , color     :: Color
                  , intensity :: Float
                  }

newPointLight :: Vec3 -> Color -> Float -> PointLight
newPointLight pos color intensity = PointLight pos color $ max 0.0 intensity

getIlluminationAt :: PointLight -> Float -> Color
getIlluminationAt l dist = Vec3.scale (color l) (intensity l / (4 * pi * dist * dist))
