-- | Functions for dealing with the divisibility of integers.
module Math.Arithmetic.Divisibility (
    (//),
    (%%),

    (%?),
    (%!),

    xgcd,

    (%^),
    (%~)
) where

-- | An operator alias for 'div', for convenience.
(//) :: Integer -> Integer -> Integer
(//) = div

infixl 7 //

-- | An operator alias for 'mod', for convenience.
(%%) :: Integer -> Integer -> Integer
(%%) = mod

infixl 7 %%

-- | A divisibility check; succeeds if the first integer precisely divides the second.
(%?) :: Integer -> Integer -> Bool
(%?) a b = b %% a == 0

-- | A deep divisibility operator, where if @(s, t) = a %! b@, then @a^s * t == b@.
(%!) :: Integer -> Integer -> (Integer, Integer)
(%!) _ 0 = (1, 0)
(%!) 1 b = (1, b)
(%!) a b
    | a %? b = (1 + s, t)
    | otherwise = (0, b)
  where
    (s, t) = a %! (b // a)

-- | The Extended Euclidean GCD, which determines the minimal triple @(x, y, g)@ for a given pair of
-- integers @(a, b)@ such that @a*x + b*y == g@.
xgcd :: Integer -> Integer -> (Integer, Integer, Integer)
xgcd a 0 = (1, 0, a)
xgcd a b = (y, x - y * q, g)
  where
    (q, r) = a `divMod` b
    (x, y, g) = xgcd b r

-- | A Modular Exponentiation operator, which efficiently computes @a %^ b $ m == a ^ b `mod` m@.
(%^) :: Integer -> Integer -> Integer -> Integer
(_ %^ 0) _ = 1
(x %^ 1) m = x %% m
(x %^ n) m
    | even n = half * half %% m
    | otherwise = x * half * half %% m
  where
    half = x %^ n // 2 $ m

infixl 5 %^

-- | A Modular Inverse operator which computes, for a given pair @(a, m)@, the (possibly
-- non-existent) value @x@ such that @a * x %% m == 1@.
(%~) :: Integer -> Integer -> Maybe Integer
(%~) a m
    | g == 1 = Just x
    | otherwise = Nothing
  where
    (x, _, g) = xgcd a m
