module Math.Arithmetic.Primality (
    primes,
    isPrime,

    factors,
    factorization,

    divisors
) where

import qualified Data.Numbers.Primes as P

import Math.Arithmetic.Divisibility

-- | An infinite list of prime numbers.
primes :: [Integer]
primes = P.primes

-- | Determine if the given integer is prime.
isPrime :: Integer -> Bool
isPrime n
    | n <= 1 = False
    | n == 2 = True
    | otherwise = not . any (%? n) $ takeWhile (<=root) primes
  where
    root = ceiling . sqrt $ (fromIntegral n :: Double)

-- | Determine the prime factorization of an integer.
factorization :: Integer -> [(Integer, Integer)]
factorization 1 = [(1, 1)]
factorization n = go n primes
  where
    go 1 _  = []
    go _ [] = []
    go x (p:ps)
        | p * p > x = [(x, 1)]
        | p %? x    = (p, s) : go t ps
        | otherwise = go x ps
      where
        (s, t) = p %! x

-- | Determine the unique prime factors of an integer.
factors :: Integer -> [Integer]
factors = map fst . factorization

-- | Enumerate the divisors of an integer.
divisors :: Integer -> [Integer]
divisors 1 = [1]
divisors n = map (product . zipWith (^) ps) ess
  where
    (ps, es) = unzip $ factorization n
    ess = sequence $ map (enumFromTo 0) es