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

let reflector_B = "YRUHQSLDPXNGOKMIEBFZCWVJAT"
let reflector_C = "FVPJIAOYEDRZXWGCTKUQSBNMHL"

let map_refl_test name wiring input_pos expected =
  name >:: fun _ ->
    assert_equal ~printer:string_of_int expected (map_refl wiring input_pos)

let map_plug_test name plugs input expected =
  name >:: fun _ ->
    assert_equal ~printer:(String.make 1) expected (map_plug plugs input)

let hist_I = { wiring = rotor_I; turnover = 'Q' }
let hist_II = { wiring = "AJDKSIRUXBLHWTMCQGZNPYFVOE"; turnover = 'E' }
let hist_III = { wiring = rotor_III; turnover = 'V' }

let oriented rotor top_letter = { rotor; top_letter }

(** [machine refl tops plugboard] has rotors I, II, III from left to right,
    showing the top letters [tops]. *)
let machine refl (left, middle, right) plugboard =
  { refl;
    rotors = [oriented hist_I left; oriented hist_II middle; oriented hist_III right];
    plugboard }

let bare_machine = { refl = identity; rotors = []; plugboard = [] }
let reflector_B_AAA = machine reflector_B ('A', 'A', 'A') []
let reflector_B_AAA_AZ = machine reflector_B ('A', 'A', 'A') [('A', 'Z')]
let reflector_B_FUN_AZ = machine reflector_B ('F', 'U', 'N') [('A', 'Z')]

let cipher_char_test name config input expected =
  name >:: fun _ ->
    assert_equal ~printer:(String.make 1) expected (cipher_char config input)

let alphabet = List.init 26 (fun i -> Char.chr (Char.code 'A' + i))

(** [tops config] is the top letters of [config]'s rotors, left to right. *)
let tops config =
  String.concat "" (List.map (fun r -> String.make 1 r.top_letter) config.rotors)

let step_test name (l, m, r) expected =
  name >:: fun _ ->
    assert_equal ~printer:(fun s -> s) expected
      (tops (step (machine reflector_B (l, m, r) [])))

let cipher_test name config input expected =
  name >:: fun _ ->
    assert_equal ~printer:(fun s -> s) expected (cipher config input)

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

    map_refl_test "identity reflector maps 0 to 0" identity 0 0;
    map_refl_test "identity reflector maps 1 to 1" identity 1 1;
    map_refl_test "identity reflector maps 25 to 25" identity 25 25;
    map_refl_test "swap AB reflector maps 0 to 1" swap_ab 0 1;
    map_refl_test "swap AB reflector maps 1 to 0" swap_ab 1 0;
    map_refl_test "reflector B maps 0 to 24" reflector_B 0 24;
    map_refl_test "reflector B maps 24 to 0 (symmetric)" reflector_B 24 0;
    map_refl_test "reflector B maps 5 to 18" reflector_B 5 18;
    map_refl_test "reflector B maps 25 to 19" reflector_B 25 19;
    map_refl_test "reflector C maps 0 to 5" reflector_C 0 5;

    map_plug_test "empty plugboard leaves M unchanged" [] 'M' 'M';
    map_plug_test "plugboard AZ maps A to Z" [('A', 'Z')] 'A' 'Z';
    map_plug_test "plugboard AZ maps Z to A" [('A', 'Z')] 'Z' 'A';
    map_plug_test "plugboard AZ leaves M unchanged" [('A', 'Z')] 'M' 'M';
    map_plug_test "plugboard AZ XY maps X to Y" [('A', 'Z'); ('X', 'Y')] 'X' 'Y';
    map_plug_test "plugboard AZ XY maps Y to X" [('A', 'Z'); ('X', 'Y')] 'Y' 'X';
    map_plug_test "plugboard AZ XY maps A to Z" [('A', 'Z'); ('X', 'Y')] 'A' 'Z';
    map_plug_test "plugboard AZ XY leaves G unchanged" [('A', 'Z'); ('X', 'Y')] 'G' 'G';
    map_plug_test "pair order within a cable does not matter" [('Z', 'A')] 'A' 'Z';
    map_plug_test "order of cables does not matter" [('Y', 'X'); ('Z', 'A')] 'Z' 'A';

    cipher_char_test "no rotors, identity reflector maps A to A" bare_machine 'A' 'A';
    cipher_char_test "no rotors, identity reflector maps Z to Z" bare_machine 'Z' 'Z';
    cipher_char_test "plugboard AZ swaps A on the way in and back on the way out"
      { bare_machine with plugboard = [('A', 'Z')] } 'A' 'A';
    cipher_char_test "rotors I II III at AAA, reflector B map G to P" reflector_B_AAA 'G' 'P';
    cipher_char_test "rotors I II III at AAA, reflector B map A to U" reflector_B_AAA 'A' 'U';
    cipher_char_test "rotors I II III at AAA, reflector B map Z to H" reflector_B_AAA 'Z' 'H';
    cipher_char_test "plugboard AZ turns A into Z before the rotors" reflector_B_AAA_AZ 'A' 'H';
    cipher_char_test "plugboard AZ turns the rotor output Z into A" reflector_B_AAA_AZ 'H' 'A';
    cipher_char_test "rotors at FUN with plugboard AZ map G to D" reflector_B_FUN_AZ 'G' 'D';
    cipher_char_test "rotors at FUN with plugboard AZ map A to E" reflector_B_FUN_AZ 'A' 'E';
    "cipher_char is its own inverse for every letter at FUN with plugboard AZ" >:: (fun _ ->
      assert_bool "some letter did not round trip"
        (List.for_all
           (fun c -> cipher_char reflector_B_FUN_AZ (cipher_char reflector_B_FUN_AZ c) = c)
           alphabet));

    step_test "rule 1: right rotor steps AAA to AAB" ('A', 'A', 'A') "AAB";
    step_test "rule 1: right rotor wraps Z to A without a turnover" ('A', 'A', 'Z') "AAA";
    step_test "rule 2: right rotor at its turnover V carries the middle rotor" ('A', 'A', 'V') "ABW";
    step_test "rule 2: middle rotor at its turnover E carries the left rotor too" ('A', 'E', 'W') "BFX";
    step_test "double step: ADU to ADV" ('A', 'D', 'U') "ADV";
    step_test "double step: ADV to AEW" ('A', 'D', 'V') "AEW";
    step_test "double step: AEW to BFX" ('A', 'E', 'W') "BFX";
    step_test "rule 3: no rotor steps twice when both turnovers show" ('A', 'E', 'V') "BFW";
    step_test "left rotor at its own turnover Q does not step anything else" ('Q', 'A', 'A') "QAB";
    "step with no rotors changes nothing" >:: (fun _ ->
      assert_equal bare_machine (step bare_machine));
    "step keeps the reflector, wiring and plugboard" >:: (fun _ ->
      let before = machine reflector_B ('A', 'A', 'A') [('A', 'Z')] in
      let after = step before in
      assert_equal (before.refl, before.plugboard,
                    List.map (fun r -> r.rotor) before.rotors)
        (after.refl, after.plugboard, List.map (fun r -> r.rotor) after.rotors));

    cipher_test "empty string stays empty" reflector_B_AAA "" "";
    cipher_test "rotors step before the first letter, so A at AAA gives B" reflector_B_AAA "A" "B";
    cipher_test "the same letter changes as the rotors turn" reflector_B_AAA "AAAAA" "BDZGO";
    cipher_test "HELLO at AAA is ILBDA" reflector_B_AAA "HELLO" "ILBDA";
    cipher_test "rotors at FUN with plugboard AZ turn YNGXQ into OCAML" reflector_B_FUN_AZ "YNGXQ" "OCAML";
    cipher_test "plugboard AZ is applied on every letter" reflector_B_AAA_AZ "ENIGMA" "FQGZHG";
    cipher_test "stepping carries through a turnover while ciphering"
      (machine reflector_B ('A', 'E', 'V') []) "AB" "GW";
    "cipher with the same settings decrypts its own output" >:: (fun _ ->
      let msg = "THEQUICKBROWNFOXJUMPSOVERTHELAZYDOG" in
      assert_equal ~printer:(fun s -> s) msg
        (cipher reflector_B_FUN_AZ (cipher reflector_B_FUN_AZ msg)));
    "cipher never maps a letter to itself" >:: (fun _ ->
      let msg = String.make 60 'A' in
      assert_bool "a letter mapped to itself"
        (not (String.contains (cipher reflector_B_AAA msg) 'A')));
  ]

let () = run_test_tt_main suite
