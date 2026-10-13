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

let cipher_char _config _c =
  failwith "Unimplemented"

let step _config =
  failwith "Unimplemented"

let cipher _config _s =
  failwith "Unimplemented"

let hours_worked = 0
