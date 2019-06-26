# File fon/manual_Script.cpp.praat
# Generated by test/createPraatTests.praat
# Tue Apr  2 15:30:08 2019

# Tests for the manual page "Operators".

assert --6 = 6
assert 2^6 = 64

assert 2^-6 = 0.015625

assert -(1+1)^6 = -64

assert 4^3^2 = 262144

assert 4^3 ^ 2 = 262144

assert (4 ^ 3) ^ 2 = 4096

assert 1/4*5 = 1.25
assert 1 / 4*5 = 1.25
assert 1 / (4*5) = 0.05

assert 3 * 2 ^ 4 = 48
assert 3*2 ^ 4 = 48
assert (3 * 2) ^ 4 = 1296

assert 54 div 5 = 10

assert 54 mod 5 = 4

assert 54.3 div 5.1 = 10

assert abs ((54.3 mod 5.1) - 3.3) < 1e-14

assert -54 div 5 = -11

assert -54 mod 5 = 1

assert -(54 div 5) = -10

assert -(54 mod 5) = -4

assert 3 * 18 div 5 = 10

assert 3 * (18 div 5) = 9

assert 3 * 18 mod 5 = 4

assert 3 * (18 mod 5) = 9

assert 54 div 5 * 3 = 30

assert 54 div (5 * 3) = 3

assert 54 mod 5 * 3 = 12

assert 54 mod (5 * 3) = 9

string$ = "hallo"
length = length (string$ + "dag")
assert length = 8

head$ = left$ ("hallo", 3)
assert head$ = "hal"

english$ = "he" + right$ ("hallo", 3)
assert english$ = "hello"

assert mid$ ("hello", 3, 2) = "ll"

where = index ("hallo allemaal", "al")
assert where = 2
assert index ("hallo allemaal", "fhjgfhj") = 0

where = rindex ("hallo allemaal", "al")
assert where = 13
assert rindex ("hallo allemaal", "fhjgfhj") = 0

where = startsWith ("internationalization", "int")
assert where = 1

where = endsWith ("internationalization", "nation")
assert where = 0

string$ = "5e6"
assert 3 + number (string$) = 5000003

assert string$ (sqrt (2)) = "1.4142135623730951"

assert fixed$ (sqrt (2), 3) = "1.414"

assert fixed$ (sqrt (2), 0) = "1"

jitter = 0.0156789
assert percent$ (jitter, 3) = "1.568%"
jitter = -0.0156789
assert percent$ (jitter, 3) = "-1.568%"

assert percent$ (0, 3) = "0"
jitter = 0.000000156789
assert percent$ (jitter, 3) = "0.00002%"
jitter *= -1
assert percent$ (jitter, 3) = "-0.00002%"

fgh = 567
assert variableExists ("fgh")
assert not variableExists ("jhfwbfejfgcds")

appendInfoLine: "fon/manual_Script.cpp.praat", " OK"