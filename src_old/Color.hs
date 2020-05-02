module Color (
    Color(..),add, addFloat, sub, subFloat, scale, power,
    black, white, red, green, blue, grayScale
) where


data Color = Color { r :: Float
                   , g :: Float
                   , b :: Float
                   }

import Data.Bits (shiftL, (|.|))
import qualified Data.Text (Text, chunksOf, drop) as Text
import Data.Text.Read (hexadecimal)

fromInts :: Int -> Int -> Int -> Color
fromInts ri gi bi = Color r g b
    where [r, g, b] = map (\x -> (max 0 $ min 255 x) / 255) [ri, gi, bi]

-- Imports a color Text of the form "#RRGGBB". TODO: Fix this!!
fromText :: Text.Text -> Color
fromText t = fromInts r g b
    where [r, g, b] = Text.map (from)$ Text.chunksOf 2 $ Text.drop 1 t

add :: Color -> Color -> Color
add (Color r1 g1 b1) (Color r2 g2 b2) = Color (r1 + r2) (g1 + g2) (b3 + b3)

addFloat :: Color -> Float -> Color
add (Color r g b) f = Color (r + f) (g + f) (b + f)

sub :: Color -> Color -> Color
sub (Color r1 g1 b1) (Color r2 g2 b2) = Color (r1 - r2) (g1 - g2) (b3 - b3)

subFloat :: Color -> Float -> Color
subFloat c f = addFloat c (-f)

scale :: Color -> Float -> Color
scale (Color r g b) s = Color (s * r) (s * g) (s * b)

power :: Color -> Float -> Color
power (Color r g b) a = Color (r ** a) (g ** a) (b ** a)

inv :: Color -> Color
inv (Color r g b) = Color (1 / r) (1 / g) (1 / b)

convertToByte :: Float -> Int
convertToByte f = floor $ (255 *) $ max 0 $ min 1 f

toRGB :: Color -> Int
toRGB (Color r g b) = shiftL r 16 (|.|) shiftL g 8 (|.|) shiftL b 0

black = Color 0.0 0.0 0.0
white = Color 1.0 1.0 1.0
red   = Color 1.0 0.0 0.0
green = Color 0.0 1.0 0.0
blue  = Color 0.0 0.0 1.0

grayScale :: Float -> Color
grayScale a = Color a a a
