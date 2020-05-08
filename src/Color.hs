module Color (
    Color(..),add, addDouble, sub, subDouble, scale, power,
    black, white, red, green, blue, grayScale
) where


data Color = Color { r :: Double
                   , g :: Double
                   , b :: Double
                   }

import Data.Bits (shiftL, (|.|))
import qualified Data.Text (Text, chunksOf, drop) as Text
import Data.Text.Read (hexadecimal)

add :: Color -> Color -> Color
add (Color r1 g1 b1) (Color r2 g2 b2) = Color (r1 + r2) (g1 + g2) (b1 + b2)

addDouble :: Color -> Double -> Color
add (Color r g b) f = Color (r + f) (g + f) (b + f)

sub :: Color -> Color -> Color
sub (Color r1 g1 b1) (Color r2 g2 b2) = Color (r1 - r2) (g1 - g2) (b1 - b2)

subDouble :: Color -> Double -> Color
subDouble c f = addDouble c (-f)

scale :: Double -> Color -> Color
scale s (Color r g b) = Color (s * r) (s * g) (s * b)

color_scale_dvec3 :: DVec3 -> Color -> Color
color_scale_dvec3 (DVec3 x y z) (Color r g b) = Color (x * r) (y * g) (z * b)

color_mult :: Color -> Color -> Color
color_mult (Color r1 g1 b1) (Color r2 g2 b2) =
    Color (r1 * r2) (g1 * g2) (b1 * b2)

power :: Color -> Double -> Color
power (Color r g b) a = Color (r ** a) (g ** a) (b ** a)

inv :: Color -> Color
inv (Color r g b) = Color (1 / r) (1 / g) (1 / b)

convertToByte :: Double -> Int
convertToByte f = floor $ (255 *) $ max 0 $ min 1 f

toRGB :: Color -> Int
toRGB (Color r g b) = shiftL r 16 |.| shiftL g 8 |.| shiftL b 0

black = Color 0.0 0.0 0.0
white = Color 1.0 1.0 1.0
red   = Color 1.0 0.0 0.0
green = Color 0.0 1.0 0.0
blue  = Color 0.0 0.0 1.0

grayScale :: Double -> Color
grayScale a = Color a a a
