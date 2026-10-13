type rotor = {
  wiring : string;
  turnover : char;
}

type oriented_rotor = {
  rotor : rotor;
  top_letter : char;
}

type config = {
  refl : string;
  rotors : oriented_rotor list;
  plugboard : (char * char) list;
}

let index (c : char) : int = Char.code c - Char.code 'A'

let wrap n = ( ( n mod 26) + 26  ) mod 26

let map_r_to_l wiring top_letter input_pos =
  let offset = index top_letter in
    wrap ( input_pos + offset )
    |> String.get wiring
    |> index
    |> fun contact -> wrap ( contact - offset )

(** [char_of_index i] is the uppercase letter at alphabet position [i].
    Requires: [i] is in 0..25. *)
let char_of_index i = Char.chr (i + Char.code 'A')

(** [map_l_to_r wiring top_letter input_pos] is the output position when
    current enters a rotor from the left at [input_pos]. This is the inverse
    of [map_r_to_l]. Requires: [wiring] is valid and [input_pos] is in 0..25. *)
let map_l_to_r wiring top_letter input_pos =
  let offset = index top_letter in
  wrap (input_pos + offset)
  |> char_of_index
  |> String.index wiring
  |> fun contact -> wrap (contact - offset)

(** [map_refl wiring input_pos] is the position a reflector with [wiring]
    sends [input_pos] to. A reflector never rotates, so it behaves like a
    rotor with top letter ['A']. Requires: [wiring] is a valid reflector
    wiring and [input_pos] is in 0..25. *)
let map_refl wiring input_pos = map_r_to_l wiring 'A' input_pos

let rec  map_plug plugs c = match plugs with
  | [] -> c
  | (a, b) :: rest -> if c = a then b else if c = b then a else map_plug rest c

(** [through_rotors map rotors pos] sends [pos] through [rotors] in the order
    given, applying [map wiring top_letter pos] at each one. *)
let through_rotors map rotors pos =
  List.fold_left
    (fun pos { rotor; top_letter } -> map rotor.wiring top_letter pos)
    pos rotors

(** [map_rotors_r_to_l rotors pos] is where current entering at [pos] on the
    right leaves the stack on the left. [rotors] are listed left to right. *)
let map_rotors_r_to_l rotors pos = through_rotors map_r_to_l (List.rev rotors) pos

(** [map_rotors_l_to_r rotors pos] is where current entering at [pos] on the
    left leaves the stack on the right. [rotors] are listed left to right. *)
let map_rotors_l_to_r rotors pos = through_rotors map_l_to_r rotors pos

let cipher_char config c =
  c
  |> map_plug config.plugboard
  |> index
  |> map_rotors_r_to_l config.rotors
  |> map_refl config.refl
  |> map_rotors_l_to_r config.rotors
  |> char_of_index
  |> map_plug config.plugboard

(** [at_turnover r] is whether [r] currently shows its turnover letter. *)
let at_turnover r = r.top_letter = r.rotor.turnover

(** [advance r] is [r] turned forward by one letter, wrapping Z to A. *)
let advance r =
  { r with top_letter = char_of_index (wrap (index r.top_letter + 1)) }

(** [step config] is [config] after one key press. Rotor [i] (counting from
    the left) steps if it is the rightmost, if the rotor to its right shows its
    turnover letter, or if it is a non-leftmost rotor showing its own turnover
    letter (the double step). Each rotor steps at most once. *)
let step config =
  let rotors = Array.of_list config.rotors in
  let last = Array.length rotors - 1 in
  let steps i =
    i = last || at_turnover rotors.(i + 1) || (i > 0 && at_turnover rotors.(i))
  in
  { config with
    rotors = List.mapi (fun i r -> if steps i then advance r else r) config.rotors }

(** [cipher config s] is [s] run through the machine, one letter at a time.
    The rotors step before each letter, and each step starts from the
    configuration the previous letter left behind. Requires: [s] is uppercase
    letters only. *)
let cipher config s =
  let _, rev_chars =
    String.fold_left
      (fun (config, acc) c ->
        let config = step config in
        (config, cipher_char config c :: acc))
      (config, []) s
  in
  rev_chars |> List.rev |> List.to_seq |> String.of_seq

let hours_worked = 10
