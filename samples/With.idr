import Data.Vect
import Data.Nat

my_filter : (a -> Bool) -> Vect n a -> (p ** Vect p a)
my_filter p [] = ( _ ** [] )
my_filter p (x :: xs) with (filter p xs)
  my_filter p (x :: xs) | ( _ ** xs' ) = if (p x) then ( _ ** x :: xs' ) else ( _ ** xs' )

foo : Int -> Int -> Bool
foo n m with (n + 1)
  foo _ m | 2 with (m + 1)
    foo _ _ | 2 | 3 = True
    foo _ _ | 2 | _ = False
  foo _ _ | _ = False

data Parity : Nat -> Type where
     Even : {n : _} -> Parity (n + n)
     Odd  : {n : _} ->Parity (S (n + n))

-- parity : (n : Nat) -> Parity n
-- parity Z = Even {n = Z}
-- parity (S Z) = Odd {n = Z}
-- parity (S (S k)) with (parity k)
--   parity (S (S (j + j))) | Even
--       = rewrite plusSuccRightSucc j j in Even {n = S j}
--   parity (S (S (S (j + j)))) | Odd
--       = rewrite plusSuccRightSucc j j in Odd {n = S j}

helpEven : (j : Nat) -> Parity (S j + S j) -> Parity (S (S (plus j j)))
helpEven j p = rewrite plusSuccRightSucc j j in p

helpOdd : (j : Nat) -> Parity (S (S (j + S j))) -> Parity (S (S (S (j + j))))
helpOdd j p = rewrite plusSuccRightSucc j j in p

parity : (n:Nat) -> Parity n
parity Z     = Even {n=Z}
parity (S Z) = Odd {n=Z}
parity (S (S k)) with (parity k)
  parity (S (S (j + j)))     | Even = helpEven j (Even {n = S j})
  parity (S (S (S (j + j)))) | Odd  = helpOdd j (Odd {n = S j})

natToBin : Nat -> List Bool
natToBin Z = Nil
natToBin k with (parity k)
   natToBin (j + j)     | Even = False :: natToBin j
   natToBin (S (j + j)) | Odd  = True  :: natToBin j

