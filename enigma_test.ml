open OUnit2
open Enigma

let index_test name input expected =
  name >:: fun _ ->
    assert_equal expected (index input)

let identity = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
let swap_ab = "BACDEFGHIJKLMNOPQRSTUVWXYZ"
let rotor_I = "EKMFLGDQVZNTOWYHXUSPAIBRCJ"
let rotor_III = "BDFHJLCPRTXVZNYEIWGAKMUSQO"

let map_r_to_l_test name wiring top_letter input_pos expected =
  name >:: fun _ ->
    assert_equal ~printer:string_of_int expected
      (map_r_to_l wiring top_letter input_pos)

let map_l_to_r_test name wiring top_letter input_pos expected =
  name >:: fun _ ->
    assert_equal ~printer:string_of_int expected
      (map_l_to_r wiring top_letter input_pos)

let suite =
  "Enigma test suite" >::: [
    index_test "index of A is 0" 'A' 0;
    index_test "index of Z is 25" 'Z' 25;
    index_test "index of B is 1" 'B' 1;
    index_test "index of M is 12" 'M' 12;
    index_test "index of N is 13" 'N' 13;

    map_r_to_l_test "identity wiring, top A maps 0 to 0" identity 'A' 0 0;
    map_r_to_l_test "identity wiring, top C maps 5 to 5" identity 'C' 5 5;
    map_r_to_l_test "swap AB wiring, top A maps 0 to 1" swap_ab 'A' 0 1;
    map_r_to_l_test "swap AB wiring, top B maps 0 to 25 (negative wrap)" swap_ab 'B' 0 25;
    map_r_to_l_test "rotor I, top A maps 0 to 4" rotor_I 'A' 0 4;
    map_r_to_l_test "rotor I, top B maps 0 to 9" rotor_I 'B' 0 9;
    map_r_to_l_test "rotor I, top A maps 25 to 9 (last contact)" rotor_I 'A' 25 9;
    map_r_to_l_test "rotor I, top B maps 25 to 3 (contact wraps past Z)" rotor_I 'B' 25 3;
    map_r_to_l_test "rotor III, top O maps 14 to 17" rotor_III 'O' 14 17;

    map_l_to_r_test "identity wiring, top A maps 0 to 0" identity 'A' 0 0;
    map_l_to_r_test "identity wiring, top C maps 5 to 5" identity 'C' 5 5;
    map_l_to_r_test "swap AB wiring, top A maps 0 to 1" swap_ab 'A' 0 1;
    map_l_to_r_test "swap AB wiring, top B maps 0 to 25 (negative wrap)" swap_ab 'B' 0 25;
    map_l_to_r_test "rotor I, top A maps 0 to 20" rotor_I 'A' 0 20;
    map_l_to_r_test "rotor I, top F maps 10 to 14" rotor_I 'F' 10 14;
    map_l_to_r_test "rotor I, top A maps 25 to 9 (last contact)" rotor_I 'A' 25 9;
    map_l_to_r_test "rotor I, top B maps 25 to 19 (contact wraps past Z)" rotor_I 'B' 25 19;
    map_l_to_r_test "rotor III, top O maps 17 to 14 (inverse of map_r_to_l)" rotor_III 'O' 17 14;
  ]

let () = run_test_tt_main suite
