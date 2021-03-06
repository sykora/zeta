module Math.Arithmetic.Divisibility.Test (tests) where

import Test.QuickCheck

import Test.Framework.Providers.API
import Test.Framework.Providers.QuickCheck2

import Math.Arithmetic.Divisibility

prop_check_everythingDividesZero :: Integer -> Property
prop_check_everythingDividesZero x = x /= 0 ==> x %? 0

prop_check_oneDividesEverything :: Integer -> Bool
prop_check_oneDividesEverything x = 1 %? x

prop_check_divisibilityOfMultiples :: Integer -> Integer -> Property
prop_check_divisibilityOfMultiples x y = x /= 0 ==> x %? (x * y)

prop_deep_identity :: Integer -> Property
prop_deep_identity x = x > 0 ==> x %! x == (1, 1)

prop_deep_invariant :: Integer -> Integer -> Property
prop_deep_invariant x y = x > 0 && y >= 0 ==> x^s * t == y where (s, t) = x %! y

prop_xgcd_invariant :: Integer -> Integer -> Property
prop_xgcd_invariant a b = a > 0 && b > 0 ==> a*x + y*b == g where (x, y, g) = xgcd a b

prop_modexp_invariant :: Integer -> Integer -> Integer -> Property
prop_modexp_invariant x n m = x > 0 && n > 0 && m > 0 ==> (x %^ n $ m) == x ^ n %% m

prop_modinv_invariant :: Integer -> Integer -> Property
prop_modinv_invariant a m = a > 0 && m > 1 ==>
    if gcd a m == 1 then maybe False (\i -> a * i %% m == 1) (a %~ m)
    else a %~ m == Nothing

tests :: [Test]
tests = [
        testGroup "Divisibility Check" [
                testProperty "Everything Divides Zero" prop_check_everythingDividesZero,
                testProperty "One Divides Everything" prop_check_oneDividesEverything,
                testProperty "Divisibility of Multiples" prop_check_divisibilityOfMultiples
            ],
        testGroup "Deep Divisibility" [
                testProperty "Identity" prop_deep_identity,
                testProperty "Invariant" prop_deep_invariant
            ],
        testGroup "Extended GCD" [
                testProperty "Invariant" prop_xgcd_invariant
            ],
        testGroup "Modular Exponentiation" [
                testProperty "Invariant" prop_modexp_invariant
            ],
        testGroup "Modular Inversion" [
                testProperty "Invariant" prop_modinv_invariant
            ]
    ]
