module Utils where

-- Returns a list of the real solutions of ax^2 + bx + c = 0
solveQuadratic :: Float -> Float -> Float -> [Float]
solveQuadratic a b c
    | isNaN discriminant = []
    | b >= 0    = [(b' - discriminant) / a', c' / (b' - discriminant)]
    | otherwise = [c' / (b' + discriminant), (b' + discriminant) / a']
    where discriminant = sqrt $ b * b - 4 * a * c
          a' = 2.0 * a
          b' = -b
          c' = 2.0 * c