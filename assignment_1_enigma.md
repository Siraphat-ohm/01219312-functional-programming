# งานเขียนโปรแกรม: Enigma

## ภาพรวม

ในงานนี้ นักศึกษาจะสร้างโปรแกรมจำลอง **เครื่องเข้ารหัส Enigma** ด้วยภาษา OCaml

Enigma เป็นเครื่องเข้ารหัสแบบ electromechanical ที่เยอรมนีใช้กันอย่างแพร่หลายในช่วงสงครามโลกครั้งที่สอง การถอดรหัสข้อความที่ถูกเข้ารหัสด้วย Enigma มีบทบาทสำคัญต่อฝ่ายสัมพันธมิตร และยังมีส่วนต่อพัฒนาการของเครื่องคอมพิวเตอร์ยุคแรกที่ Bletchley Park

อย่างไรก็ตาม เป้าหมายของงานนี้ไม่ได้อยู่ที่เรื่อง cryptography เพียงอย่างเดียว แต่ต้องการให้นักศึกษาได้ฝึก:

* การใช้ data type ของ OCaml

* list และ pattern matching

* recursion

* การแบ่งปัญหาออกเป็นฟังก์ชันย่อย

* immutable data

* การจำลองการเปลี่ยนแปลงของ state แบบ functional

* การเขียน unit test ด้วย OUnit2

* Test-Driven Development หรือ TDD

* การใช้ Git สำหรับ version control

* การแบ่งระบบจริงที่มีความซับซ้อนออกเป็นส่วนย่อยที่จัดการได้

งานนี้มีขนาดใหญ่กว่าแบบฝึกหัด OCaml เบื้องต้นทั่วไปอย่างมาก ดังนั้นควรพัฒนาโปรแกรมทีละส่วน ไม่ควรพยายามทำทั้งหมดให้เสร็จในครั้งเดียว

ในรายวิชาของ Cornell ที่ใช้งานลักษณะเดียวกัน นักศึกษาใช้เวลาทำงานโดยเฉลี่ยประมาณ 10 ชั่วโมง

---

# 1\. วัตถุประสงค์การเรียนรู้

หลังจากทำงานนี้เสร็จ นักศึกษาควรสามารถ:

1. แทนระบบที่มีความซับซ้อนพอสมควรด้วย OCaml records, lists, tuples, characters, strings และ functions

2. แบ่งปัญหาขนาดใหญ่ออกเป็นฟังก์ชันขนาดเล็กที่มี contract ชัดเจน

3. เดินผ่าน list ด้วย recursion และ pattern matching

4. จำลอง state ที่เปลี่ยนแปลงได้โดยไม่ใช้ mutation

5. สร้างชุดทดสอบอย่างเป็นระบบด้วย OUnit2

6. ฝึกวงจรของ Test-Driven Development:

   * เขียน test

   * รันแล้วเห็นว่า test fail

   * implement feature

   * รันแล้วเห็นว่า test pass

   * refactor

7. จัดการเวอร์ชันของงานด้วย Git

---

# 2\. กฎและข้อจำกัด

ให้นักศึกษาทำงานนี้เป็นรายบุคคล เว้นแต่ผู้สอนจะระบุเป็นอย่างอื่น

สามารถใช้ฟังก์ชันทั่วไปจาก OCaml standard library ได้ เช่นฟังก์ชันใน module:

* Char

* String

* List

อย่างไรก็ตาม จุดประสงค์ของงานนี้คือการฝึก **functional programming style**

ดังนั้น ห้ามใช้:

* ref

* arrays

* mutable record fields

* Bytes

* Hashtbl

* mutable data structures อื่น ๆ

สำหรับงานนี้ ให้หลีกเลี่ยง:

List.hd  
List.tl  
List.nth

และใช้ pattern matching แทน

ตัวอย่างที่ควรใช้:

**match** lst **with**  
| \[\] \-\> ...  
| h :: t \-\> ...

แทนการเขียน:

List.hd lst

---

# 3\. Development Environment

นักศึกษาต้องมี:

* OCaml

* opam

* Dune

* OUnit2

* Git

* editor เช่น VS Code พร้อม OCaml Platform extension

ติดตั้ง package ที่ต้องใช้:

opam install dune ounit2

ถ้าจำเป็นให้รัน:

eval \$(opam env)

สามารถทำงานบน:

* Linux

* macOS

* Windows

* Windows \+ WSL

---

# 4\. Starter Project

ดาวน์โหลดและแตกไฟล์ starter project ที่ผู้สอนจัดเตรียมไว้

โครงสร้างของ project คือ:

enigma\_assignment\_starter/  
├── dune-project  
├── dune  
├── enigma.ml  
├── enigma.mli  
├── enigma\_test.ml  
├── README.md  
└── .gitignore

ไฟล์สำคัญมีดังนี้

## enigma.ml

ใช้สำหรับเขียน implementation ของนักศึกษา

## enigma.mli

กำหนด public types และ function signatures ที่ต้องใช้

ห้ามเปลี่ยน function signatures ที่กำหนดไว้

## enigma\_test.ml

ใช้เขียนชุดทดสอบ OUnit2

---

# 5\. ตรวจสอบ Starter Project

จาก project directory ให้รัน:

dune build

โปรแกรมควร compile ผ่าน ถึงแม้ฟังก์ชันส่วนใหญ่ยังไม่ได้ implement

จากนั้นรัน:

dune test

test แรกควร fail เพราะฟังก์ชัน index ยังไม่ได้ implement

การ fail ในขั้นนี้เป็นสิ่งที่ตั้งใจไว้

ระหว่างทำงาน นักศึกษาจะใช้คำสั่งเหล่านี้บ่อย ๆ:

dune build

และ:

dune test

หากต้องการลบไฟล์ build ที่สร้างขึ้น:

dune clean

---

# 6\. เริ่มใช้ Git ตั้งแต่ต้น

สร้าง Git repository ก่อนแก้ไข starter code

ตัวอย่าง:

git init  
git add .  
git commit \-m "Import Enigma starter code"

หากใช้ GitHub, GitLab หรือบริการ Git อื่น ให้สร้าง repository แบบ **private**

อย่าเผยแพร่ solution เป็น public repository ขณะที่นักศึกษาคนอื่นยังทำ assignment อยู่

เมื่อทำแต่ละส่วนสำคัญเสร็จ ให้ commit งาน

ตัวอย่าง:

git add enigma.ml enigma\_test.ml  
git commit \-m "Implement rotor mapping"  
git push

ตัวอย่าง commit history ที่เหมาะสม:

Import Enigma starter code  
Implement index  
Implement right-to-left rotor mapping  
Implement reverse rotor mapping  
Implement reflector  
Implement plugboard  
Implement cipher\_char  
Implement rotor stepping  
Implement full cipher  
Improve Enigma tests

---

# 7\. Data Types ที่ต้องใช้

configuration ของ Enigma แทนด้วย type ต่อไปนี้:

**type** rotor \= {  
  wiring : string;  
  turnover : char;  
}

**type** oriented\_rotor \= {  
  rotor : rotor;  
  top\_letter : char;  
}

**type** config \= {  
  refl : string;  
  rotors : oriented\_rotor list;  
  plugboard : (char \* char) list;  
}

rotor แทนคุณสมบัติถาวรของ rotor

oriented\_rotor แทน rotor พร้อมตำแหน่งการหมุนในขณะนั้น

config แทน state ปัจจุบันของเครื่อง Enigma

---

# 8\. ฟังก์ชันที่ต้อง Implement

ต้อง implement ฟังก์ชันต่อไปนี้:

index : char \-\> int

map\_r\_to\_l : string \-\> char \-\> int \-\> int

map\_l\_to\_r : string \-\> char \-\> int \-\> int

map\_refl : string \-\> int \-\> int

map\_plug : (char \* char) list \-\> char \-\> char

cipher\_char : config \-\> char \-\> char

step : config \-\> config

cipher : config \-\> string \-\> string

---

# 9\. วิธีการพัฒนา: Test-Driven Development

สำหรับทุกฟังก์ชัน ให้ใช้วงจรต่อไปนี้

## ขั้นที่ A — เขียน Test

เพิ่ม test ที่แสดง behavior ที่ต้องการ

## ขั้นที่ B — รัน Test

dune test

ตรวจสอบว่า test fail

## ขั้นที่ C — Implement

แก้ไข enigma.ml ให้เพียงพอที่จะทำให้ test ผ่าน

## ขั้นที่ D — รัน Test อีกครั้ง

dune test

## ขั้นที่ E — Refactor

ลด code duplication ปรับชื่อ ปรับโครงสร้าง โดยไม่เปลี่ยน behavior

จากนั้นทำซ้ำวงจรเดิม

เป้าหมายไม่ใช่เพียงแค่มี test ตอนจบ แต่ต้องการให้นักศึกษาใช้ test เป็นเครื่องมือในการสร้างโปรแกรม

---

# 10\. Part 1 — Alphabet Indices

Implement:

index : char \-\> int

index c ให้คืนตำแหน่งของตัวอักษร uppercase c ใน alphabet โดยเริ่มนับจาก 0

ตัวอย่าง:

A \-\> 0  
B \-\> 1  
C \-\> 2  
...  
Z \-\> 25

สมมติได้ว่า argument เป็นตัวอักษรภาษาอังกฤษ uppercase

ตัวอย่าง:

index 'A' \= 0  
index 'Z' \= 25

ลองดูฟังก์ชัน:

Char.code

ฟังก์ชันนี้ควรสามารถ implement ได้อย่างสั้นมาก

---

## แบบฝึก TDD

starter test มี:

index\_test "index of A is 0" 'A' 0

ก่อน implement index ให้เพิ่ม test อีกหนึ่งกรณี เช่น:

Z \-\> 25

รัน:

dune test

ทั้งสอง test ควร fail

จากนั้น implement index

แล้วรัน:

dune test

ทั้งสอง test ควร pass

จากนั้น commit งาน

---

# 11\. พื้นฐานเกี่ยวกับ Enigma

ก่อน implement ส่วนที่เหลือ จำเป็นต้องเข้าใจเครื่องที่กำลังจำลอง

Enigma ทำงานโดยใช้ substitution cipher ที่ซับซ้อน

ลองเริ่มจาก cipher ที่ง่ายกว่า

## Caesar Cipher

สมมติว่าเราเลื่อนทุกตัวอักษรไปสามตำแหน่ง:

Plaintext:  ABCDEFGHIJKLMNOPQRSTUVWXYZ  
Ciphertext: DEFGHIJKLMNOPQRSTUVWXYZABC

จึงได้:

A \-\> D  
B \-\> E  
C \-\> F  
...  
X \-\> A  
Y \-\> B  
Z \-\> C

Enigma ก็ใช้ substitution เช่นกัน แต่ substitution จะเปลี่ยนไปตลอดระหว่างการทำงาน

องค์ประกอบหลักของ Enigma ที่ใช้ใน assignment นี้คือ:

1. plugboard

2. rotors

3. reflector

4. rotor stepping mechanism

เส้นทางของสัญญาณไฟฟ้าโดยแนวคิดคือ:

keyboard  
   |  
   v  
plugboard  
   |  
   v  
rightmost rotor  
   |  
   v  
...  
   |  
   v  
leftmost rotor  
   |  
   v  
reflector  
   |  
   v  
leftmost rotor  
   |  
   v  
...  
   |  
   v  
rightmost rotor  
   |  
   v  
plugboard  
   |  
   v  
lampboard

reflector ทำให้สัญญาณวิ่งย้อนกลับผ่าน rotors อีกครั้ง

ด้วยเหตุนี้ เครื่อง Enigma ที่ตั้งค่าเหมือนกันจึงสามารถใช้ทั้งเข้ารหัสและถอดรหัสได้

เพื่อให้งานง่ายขึ้น assignment นี้ไม่จำลอง historical **ring setting**

---

# 12\. Part 2 — Rotor Wiring

rotor มี electrical contact 26 จุดในแต่ละด้าน

สายไฟภายใน rotor ทำหน้าที่ permute การเชื่อมต่อ 26 ตำแหน่งเหล่านี้

แทนที่จะวาดสายไฟ 26 เส้น เราจะแทน wiring ด้วย string ความยาว 26 ตัวอักษร

Historical Rotor I:

EKMFLGDQVZNTOWYHXUSPAIBRCJ

Rotor II:

AJDKSIRUXBLHWTMCQGZNPYFVOE

Rotor III:

BDFHJLCPRTXVZNYEIWGAKMUSQO

wiring ที่ valid:

* ยาว 26 characters

* ประกอบด้วย A ถึง Z เท่านั้น

* แต่ละตัวอักษรปรากฏเพียงครั้งเดียว

สามารถสมมติได้ว่า wiring ที่ถูกส่งเข้าฟังก์ชันทุกครั้งเป็น valid wiring

---

# 13\. ทำความเข้าใจ Rotor Wiring

พิจารณา Rotor I:

EKMFLGDQVZNTOWYHXUSPAIBRCJ

ตำแหน่งเริ่มจาก 0

ตำแหน่งแรก ๆ คือ:

position     letter     alphabet index  
0            E          4  
1            K          10  
2            M          12  
3            F          5  
4            L          11  
...

ดังนั้นเมื่อ rotor อยู่ใน orientation เริ่มต้น:

input position 0 \-\> output position 4  
input position 1 \-\> output position 10  
input position 2 \-\> output position 12

นี่คือกรณีที่กระแสไฟฟ้าไหล **จากขวาไปซ้าย**

---

# 14\. Rotor Orientation

rotor สามารถหมุนได้

ผู้ใช้เครื่องจะเห็นตัวอักษรหนึ่งตัวอยู่ด้านบนของ rotor

เราเรียกตัวอักษรนี้ว่า:

top letter

ถ้า top letter เป็น:

A

rotor มี rotational offset เท่ากับ 0

ถ้า top letter เป็น:

B

rotor หมุนไป 1 ตำแหน่ง

ถ้า top letter เป็น:

C

rotor หมุนไป 2 ตำแหน่ง

ดังนั้น rotor mapping ขึ้นอยู่กับทั้ง:

wiring

และ:

top\_letter

---

# 15\. Part 2A — Right-to-Left Rotor Mapping

Implement:

map\_r\_to\_l : string \-\> char \-\> int \-\> int

โดยแนวคิด:

map\_r\_to\_l wiring top\_letter input\_pos

ต้องคำนวณว่า ถ้ากระแสไฟฟ้าเข้า rotor ทางด้านขวาที่ตำแหน่ง input\_pos จะออกด้านซ้ายที่ตำแหน่งใด

สมมติได้ว่า:

input\_pos อยู่ระหว่าง 0 ถึง 25  
top\_letter อยู่ระหว่าง A ถึง Z  
wiring เป็น valid wiring

---

## ตัวอย่างที่ 1

ใช้ Rotor I:

EKMFLGDQVZNTOWYHXUSPAIBRCJ

Top letter:

A

Input:

0

เพราะ rotor ไม่มี rotational offset:

position 0 \-\> contact 0

wiring ส่ง contact 0 ไป alphabet index 4

ดังนั้น:

output \= 4

---

## ตัวอย่างที่ 2

ใช้ rotor เดิม แต่ top letter เป็น:

B

rotational offset จึงเท่ากับ 1

กระแสที่เข้า external position 0 จะไปสัมผัส internal rotor contact คนละจุดกับกรณีก่อน

เมื่อผ่าน wiring แล้ว ต้องแปลงผลลัพธ์กลับจาก coordinate ภายใน rotor ไปยัง external coordinate ของเครื่อง

สำหรับตัวอย่างนี้ ผลลัพธ์สุดท้ายคือ:

9

ควรคิดเป็นสามขั้น:

1. external input position → rotor contact

2. ผ่าน rotor wiring

3. rotor contact → external output position

จะต้องใช้ modulo 26

ระวังว่า mod ของ OCaml อาจให้ค่าที่ไม่สะดวกเมื่อ operand เป็นค่าติดลบ

อาจสร้าง helper function ที่รับประกันว่าผลลัพธ์อยู่ระหว่าง 0 ถึง 25

---

# 16\. Test ที่แนะนำสำหรับ map\_r\_to\_l

เริ่มจาก identity wiring:

ABCDEFGHIJKLMNOPQRSTUVWXYZ

เมื่อ top letter เป็น A:

0 \-\> 0

เพราะทุก contact ต่อกับตำแหน่งเดิม

จากนั้นทดลอง:

BACDEFGHIJKLMNOPQRSTUVWXYZ

กับ top letters เช่น:

A  
B  
C

สุดท้ายจึงทดลอง historical rotors

ตัวอย่าง:

**let** rotor\_III \=  
  "BDFHJLCPRTXVZNYEIWGAKMUSQO"

ใช้ test:

map\_r\_to\_l rotor\_III 'O' 14 \= 17

ห้าม hard-code historical rotors ลงใน algorithm

implementation ต้องทำงานได้กับ **valid wiring permutation ใด ๆ**

---

# 17\. Part 2B — Left-to-Right Rotor Mapping

เมื่อกระแสไฟฟ้าไปถึง reflector แล้ว จะเดินทางย้อนกลับผ่าน rotors

จึงต้อง implement reverse mapping:

map\_l\_to\_r : string \-\> char \-\> int \-\> int

mapping นี้ไม่เหมือนกับ map\_r\_to\_l

จริง ๆ แล้วกำลังใช้ **inverse** ของ rotor wiring

พิจารณา Rotor I:

EKMFLGDQVZNTOWYHXUSPAIBRCJ

เมื่อ top letter เป็น:

A

ถ้ากระแสเข้า rotor จากด้านซ้ายที่ position:

0

ต้องหา contact ด้านขวาว่า contact ใดเชื่อมกับ alphabet position 0

ใน Rotor I ตัวอักษร A อยู่ที่ index 20

ดังนั้น:

0 \-\> 20

---

## Test ที่แนะนำ

**let** rotor\_I \=  
  "EKMFLGDQVZNTOWYHXUSPAIBRCJ"

และ:

map\_l\_to\_r rotor\_I 'F' 10 \= 14

อาจสร้าง helper function ที่ทำงานตรงข้ามกับ index

กล่าวคือ รับ integer 0 ถึง 25 แล้วคืนตัวอักษร uppercase ที่ตรงกัน

เมื่อ rotor functions ทั้งสองผ่าน test แล้ว ให้ commit

---

# 18\. Part 3 — Reflector

reflector มี wiring ซึ่งแทนด้วย string ความยาว 26 characters เช่นเดียวกัน

แต่ reflector:

* ไม่หมุน

* ต้องการ mapping เพียงทิศทางเดียว

* wiring มีสมมาตร

reflector ที่ valid มีคุณสมบัติ:

ถ้า i maps to j  
แล้ว j ต้อง maps to i

Historical reflector B:

YRUHQSLDPXNGOKMIEBFZCWVJAT

Historical reflector C:

FVPJIAOYEDRZXWGCTKUQSBNMHL

Implement:

map\_refl : string \-\> int \-\> int

test แรกที่ง่ายคือ identity reflector:

ABCDEFGHIJKLMNOPQRSTUVWXYZ

ตัวอย่าง:

0 \-\> 0  
1 \-\> 1  
25 \-\> 25

ลองพิจารณาว่าสามารถ reuse ฟังก์ชัน rotor ที่เขียนไว้แล้วได้หรือไม่

จากนั้น commit

---

# 19\. Part 4 — Plugboard

ก่อนเข้าสู่ rotors สัญญาณต้องผ่าน plugboard

plugboard ทำหน้าที่ swap ตัวอักษรเป็นคู่ ๆ

แทนด้วย:

(char \* char) list

ตัวอย่าง:

\[('A', 'Z'); ('X', 'Y')\]

หมายถึง:

A \<-\> Z  
X \<-\> Y

ดังนั้น:

A maps to Z  
Z maps to A

X maps to Y  
Y maps to X

ตัวอักษรอื่นคงเดิม

plugboard ต่อไปนี้มีความหมายเหมือนกัน:

\[('Y', 'X'); ('Z', 'A')\]

ลำดับของ pair ไม่มีความสำคัญ และลำดับของตัวอักษรภายใน pair ก็ไม่มีความสำคัญเช่นกัน

---

## Valid Plugboard

plugboard ที่ valid:

* มีเฉพาะ uppercase letters A ถึง Z

* ตัวอักษรหนึ่งตัวปรากฏได้ใน cable เดียวเท่านั้น

* มีตั้งแต่ 0 ถึง 13 pairs

plugboard ว่างคือ:

\[\]

และทำงานเหมือน identity function

---

# 20\. Implement map\_plug

Implement:

map\_plug : (char \* char) list \-\> char \-\> char

ฟังก์ชันนี้เหมาะกับ recursive pattern matching มาก

เริ่ม test จาก:

\[\]

จากนั้น:

\[('A', 'Z')\]

และ:

\[('A', 'Z'); ('X', 'Y')\]

ต้องทดสอบ:

A \-\> Z  
Z \-\> A  
X \-\> Y  
Y \-\> X

และทดสอบตัวอักษรที่ไม่ได้เชื่อมกับสายใด

ห้ามใช้ mutation

จากนั้น commit

---

# 21\. Part 5 — Cipher ตัวอักษรหนึ่งตัว

ตอนนี้มีองค์ประกอบเพียงพอที่จะจำลอง electrical path ของ Enigma

Implement:

cipher\_char : config \-\> char \-\> char

สำคัญมาก:

**cipher\_char ไม่ทำ rotor stepping**

ฟังก์ชันนี้คำนวณการเข้ารหัสจาก configuration ปัจจุบันเท่านั้น

---

# 22\. Signal Path

สมมติผู้ใช้กด:

X

เครื่องจะประมวลผลตามลำดับ:

X  
|  
v  
plugboard  
|  
v  
alphabet index  
|  
v  
rightmost rotor  
|  
v  
...  
|  
v  
leftmost rotor  
|  
v  
reflector  
|  
v  
leftmost rotor  
|  
v  
...  
|  
v  
rightmost rotor  
|  
v  
alphabet letter  
|  
v  
plugboard  
|  
v  
output

ต้องสังเกต representation สำคัญ:

rotors : oriented\_rotor list

เก็บ rotors **จากซ้ายไปขวา**

ตัวอย่าง:

\[r1; r2; r3\]

หมายถึง:

Reflector \-- r1 \-- r2 \-- r3 \-- Keyboard

ดังนั้นกระแสไฟฟ้าจะเข้า:

r3

ก่อน ไม่ใช่:

r1

---

# 23\. ตัวอย่าง cipher\_char

ใช้ configuration:

Reflector: B

Rotors จากซ้ายไปขวา:  
I  
II  
III

Top letters:  
A  
A  
A

Plugboard:  
empty

input:

G

alphabet index ของ G คือ:

6

signal เดินทางดังนี้:

Rotor III:  
6 \-\> 2

Rotor II:  
2 \-\> 3

Rotor I:  
3 \-\> 5

Reflector B:  
5 \-\> 18

Rotor I reverse:  
18 \-\> 18

Rotor II reverse:  
18 \-\> 4

Rotor III reverse:  
4 \-\> 15

alphabet index 15 คือ:

P

ดังนั้น:

G \-\> P

สำหรับ configuration คงที่นี้ mapping ทั้ง alphabet คือ:

input:  
ABCDEFGHIJKLMNOPQRSTUVWXYZ

output:  
UEJOBTPZWCNSRKDGVMLFAQIYXH

ข้อมูลนี้สามารถใช้สร้าง test ได้หลายกรณี

---

# 24\. Helper Functions ที่อาจมีประโยชน์

อาจสร้าง:

map\_rotors\_r\_to\_l :  
  oriented\_rotor list \-\> int \-\> int

และ:

map\_rotors\_l\_to\_r :  
  oriented\_rotor list \-\> int \-\> int

ทั้งสองฟังก์ชันควร process list ของ rotors แบบ recursive

ต้องระวัง traversal direction

ถามตัวเองว่า:

* rotor ใดรับสัญญาณก่อน?

* ตอนสัญญาณเดินทางกลับ rotor ใดรับก่อน?

* ใช้ List.rev ใน traversal หนึ่งได้หรือไม่?

* สามารถแยก common behavior เป็น helper แทนการ duplicate code ได้หรือไม่?

---

# 25\. Test อย่างง่ายสำหรับ cipher\_char

สร้างเครื่องที่มี:

ไม่มี plugboard swaps  
ไม่มี rotors  
identity reflector

ควรได้:

A \-\> A  
B \-\> B  
...  
Z \-\> Z

จากนั้นทดสอบ historical example:

G \-\> P

และเพิ่ม test อื่นจาก mapping 26 ตัวอักษรด้านบน

จากนั้น commit

ถึงจุดนี้ นักศึกษาได้สร้าง **static Enigma mapping system** ที่สมบูรณ์แล้ว

---

# 26\. Part 6 — Rotor Stepping

ที่ผ่านมา cipher\_char ใช้ fixed configuration

แต่ Enigma จริงจะเปลี่ยน configuration ก่อนเข้ารหัสทุกตัวอักษร

rotors จะหมุนตาม turnover positions

ส่วนนี้เป็นส่วนที่ยากที่สุดของ assignment ในเชิง algorithm

---

# 27\. Turnover

rotor แต่ละตัวมี notch

field turnover บอก top letter ที่สัมพันธ์กับ notch

historical values เช่น:

Rotor I:   Q  
Rotor II:  E  
Rotor III: V

---

# 28\. Stepping Rules

สำหรับงานนี้ ให้ใช้กฎต่อไปนี้ **อย่างเคร่งครัด**

## Rule 1

ก่อนเข้ารหัสทุก character:

**rightmost rotor ต้อง step หนึ่งครั้งเสมอ**

## Rule 2

หาก rotor ใดที่ไม่ใช่ leftmost rotor กำลังแสดง turnover letter ของตัวเอง:

* rotor นั้นต้อง step

* rotor ที่อยู่ทางซ้ายติดกันต้อง step ด้วย

## Rule 3

rotor แต่ละตัวห้าม step มากกว่าหนึ่งครั้งต่อ character

---

# 29\. ตัวอย่าง Stepping

สมมติ rotors เรียง:

III \- II \- I

จากซ้ายไปขวา

top letters เริ่มต้น:

KDO

state ต่อเนื่องจะเป็น:

KDO  
KDP  
KDQ  
KER  
LFS  
LFT  
LFU  
...

อีกตัวอย่าง เริ่มจาก:

VDP

ได้:

VDP  
VDQ  
VER  
WFS  
WFT  
...

ตัวอย่างเหล่านี้เหมาะมากสำหรับ test เพราะทดสอบ interaction ของ stepping rules หลายข้อพร้อมกัน

---

# 30\. Implement step

Implement:

step : config \-\> config

สิ่งสำคัญอยู่ที่ type:

config \-\> config

เรา **ไม่ได้แก้ไข configuration เดิม**

แต่สร้าง configuration ใหม่:

old configuration  
        |  
        v  
      step  
        |  
        v  
new configuration

นี่เป็นตัวอย่างสำคัญของการแทน state transition ด้วย functional programming

ห้ามใช้ mutable fields หรือ references

---

## วิธีทำที่แนะนำ

อย่าพยายาม implement stepping rules ทั้งหมดพร้อมกัน

เริ่มจาก:

### Rule 1

ให้ rightmost rotor หมุนก่อน

เขียน test ให้ครบ

จากนั้นเพิ่ม:

### Rule 2

turnover ทำให้ rotor ข้างเคียงหมุน

สุดท้ายตรวจ:

### Rule 3

ไม่มี rotor ใดถูก step สองครั้ง

เมื่อ stepping tests ผ่านแล้ว ให้ commit

---

# 31\. Part 7 — Cipher String ทั้งข้อความ

Implement:

cipher : config \-\> string \-\> string

การ process character หนึ่งตัวของ Enigma เกิดตามลำดับ:

1\. ผู้ใช้กด character  
2\. machine steps  
3\. character ถูกเข้ารหัสด้วย configuration ใหม่  
4\. output character ปรากฏ

จากนั้นทำซ้ำกับ character ถัดไป

ต้องจำให้ชัด:

STEP FIRST  
CIPHER SECOND

ห้ามเข้ารหัสด้วย configuration เก่าแล้วค่อย step

---

# 32\. Functional State Threading

สมมติ input คือ:

ABCDE

แนวคิดคือ:

config0  
   |  
 step  
   v  
config1 \--cipher A--\> output1  
   |  
 step  
   v  
config2 \--cipher B--\> output2  
   |  
 step  
   v  
config3 \--cipher C--\> output3  
...

นี่เป็นอีกตัวอย่างของ functional state modeling

configuration เป็น state ปัจจุบัน

recursive call แต่ละครั้งได้รับ configuration ใหม่

ไม่ต้องใช้ mutable variable

---

# 33\. Full-Cipher Test

ใช้:

Reflector B

rotors จากซ้ายไปขวา:

I  
II  
III

starting top letters:

F  
U  
N

plugboard:

A \<-\> Z

เข้ารหัส:

YNGXQ

ถ้า implementation ถูกต้อง ผลลัพธ์จะเป็นชื่อของ programming language หนึ่งภาษา

อย่าเปลี่ยน algorithm เพียงเพื่อให้ test นี้ผ่าน

implementation ต้องทำงานกับ:

* wiring อื่น ๆ

* จำนวน rotors อื่น ๆ

* rotor ordering อื่น ๆ

* top letters อื่น ๆ

* turnovers อื่น ๆ

* valid plugboard อื่น ๆ

---

# 34\. Property สำคัญที่ควร Test

เพราะมี reflector Enigma มี symmetry ที่มีประโยชน์

ถ้า configuration C เข้ารหัส:

HELLO

เป็น ciphertext บางชุด

เมื่อเริ่มใหม่ด้วย **initial configuration C เดิมทุกประการ** แล้วเข้ารหัส ciphertext นั้นอีกครั้ง จะต้องได้:

HELLO

นี่เป็น whole-system test ที่ดีมาก

คำสำคัญคือ:

same initial configuration

เพราะการเข้ารหัสทั้งสองครั้งต้องเริ่มจาก rotor positions เดียวกัน

---

# 35\. Testing Requirements

ต้องเขียนอย่างน้อย **5 tests ต่อ required function**

มี required functions 8 ฟังก์ชัน:

index  
map\_r\_to\_l  
map\_l\_to\_r  
map\_refl  
map\_plug  
cipher\_char  
step  
cipher

ดังนั้น test suite ต้องมีอย่างน้อย:

8 × 5 \= 40 tests

test ไม่ควรทดสอบเพียงสถานการณ์คล้าย ๆ กันทั้งหมด

ควรมี:

* ordinary cases

* boundary cases

* identity mappings

* nontrivial mappings

* rotor positions หลายแบบ

* plugboard configurations หลายแบบ

* turnover cases

* multi-character encryption

---

# 36\. ตั้งชื่อ Test ให้สื่อความหมาย

ดี:

"index of Z is 25"

"empty plugboard leaves M unchanged"

"plugboard AZ maps A to Z"

"rightmost rotor steps every character"

ไม่ดี:

"test1"

"plugtest"

"step"

ชื่อ test ควรทำให้เข้าใจได้ทันทีว่า behavior ใดล้มเหลว

---

# 37\. ใช้ Test Helper Functions

ไม่ควรเขียนโครงสร้าง assert\_equal ซ้ำหลายสิบครั้ง

ตัวอย่าง:

**let** index\_test name input expected \=  
  name \>:: **fun** \_ \-\>  
    assert\_equal expected (index input)

จากนั้นเขียน test ได้เป็น:

index\_test "index of A is 0" 'A' 0

index\_test "index of Z is 25" 'Z' 25

สร้าง helper แบบเดียวกันสำหรับฟังก์ชันอื่นตามความเหมาะสม

---

# 38\. Code Quality Requirements

code ควรอ่านง่ายสำหรับ programmer คนอื่น

ให้ความสำคัญกับหัวข้อต่อไปนี้

## ใช้ชื่อตัวแปรที่สื่อความหมาย

ดี:

offset  
input\_pos  
top\_letter  
rotor  
rest

ควรหลีกเลี่ยง:

foo  
thing  
var1  
abc

ชื่อสั้นแบบ conventional เช่น:

h  
t  
lst

ใช้ได้หากความหมายชัดเจนจากบริบท

---

# 39\. ทำให้ฟังก์ชันมีขนาดเล็ก

แต่ละฟังก์ชันควรรับผิดชอบงานหนึ่งอย่าง

ถ้าฟังก์ชันยาวเกินไป ให้แยก helper functions

ตัวอย่าง:

cipher\_char

ไม่จำเป็นต้องมี logic ทั้งหมดของ rotor traversal อยู่ภายในฟังก์ชันเดียว

สามารถ delegate ให้ helper functions ได้

---

# 40\. ใช้ Pattern Matching

ควรใช้:

**match** lst **with**  
| \[\] \-\> ...  
| h :: t \-\> ...

แทน partial list operations

หลีกเลี่ยง:

List.hd  
List.tl  
List.nth

---

# 41\. หลีกเลี่ยง Expression ที่ซ้อนลึก

แทนการเขียน:

f4 (f3 (f2 (f1 x)))

อาจใช้ pipeline operator:

x  
|\> f1  
|\> f2  
|\> f3  
|\> f4

รูปแบบนี้อาจเหมาะมากกับการแสดง signal flow ของ Enigma

---

# 42\. Documentation สำหรับ Helper Functions

helper function ที่สำคัญควรมี specification สั้น ๆ

ตัวอย่าง:

*(\*\** \[next\_letter c\] *is the letter following* \[c\]*,*  
    *wrapping* \['Z'\] *around to* \['A'\]*. \*)*

ควรอธิบาย:

* ฟังก์ชันคืนค่าอะไร

* parameter มีความหมายอะไร

* มี precondition อะไร

---

# 43\. Compiler Warnings

โปรแกรม final ควร compile โดยไม่มี warning ที่เกี่ยวข้องกับ:

* incomplete pattern matching

* redundant patterns

* suspicious type behavior

โดยเฉพาะ warning เกี่ยวกับ non-exhaustive matches ไม่ควรถูกละเลย เพราะมักบ่งชี้ bug จริง

---

# 44\. ระดับของงาน

assignment นี้แบ่งระดับความสำเร็จได้เป็นสามระดับ

## Satisfactory Scope

ทำ:

index  
map\_r\_to\_l  
map\_l\_to\_r

ถึงจุดนี้ นักศึกษาได้จำลอง individual rotors สำเร็จ

---

## Good Scope

เพิ่ม:

map\_refl  
map\_plug  
cipher\_char

ถึงจุดนี้มี static Enigma machine ที่สมบูรณ์

สามารถเข้ารหัส character ได้ แต่ rotors ยังไม่หมุนเอง

---

## Excellent Scope

เพิ่ม:

step  
cipher

ตอนนี้สามารถจำลอง Enigma ที่มี state เปลี่ยนแปลงได้ครบถ้วน

---

# 45\. Grading Rubric

คะแนนเต็ม: **100 คะแนน**

## 25 คะแนน — Submission และ Compilation

project:

* มี required files ครบ

* compile ด้วย dune build

* function names และ types ตรงตามที่กำหนด

## 25 คะแนน — Satisfactory Scope

implementation ถูกต้องของ:

index  
map\_r\_to\_l  
map\_l\_to\_r

## 25 คะแนน — Good Scope

implementation ถูกต้องของ:

map\_refl  
map\_plug  
cipher\_char

## 10 คะแนน — Testing

มีอย่างน้อย:

40 meaningful OUnit2 tests

พร้อม:

* descriptive names

* appropriate helper functions

* test cases หลากหลาย

## 10 คะแนน — Code Quality

พิจารณา:

* functional programming style

* good naming

* appropriate decomposition

* readable formatting

* pattern matching

* helper documentation

* ไม่มี prohibited list operations

* ไม่มี mutation ที่ไม่จำเป็น

## 5 คะแนน — Excellent Scope

implementation ถูกต้องของ:

step  
cipher

---

# 46\. บันทึกเวลาที่ใช้ทำงาน

ด้านล่างของ enigma.ml มี:

**let** hours\_worked \= 0

ก่อน submit ให้เปลี่ยน 0 เป็นจำนวนชั่วโมงโดยประมาณที่ใช้ทำ assignment

ตัวอย่าง:

**let** hours\_worked \= 9

---

# 47\. Final Checks

ก่อน submit ให้รัน:

dune clean  
dune build  
dune test

ตรวจสอบว่า:

* dune build สำเร็จ

* tests รันได้

* required names และ types ตรงกับ enigma.mli

* อัปเดต hours\_worked

* ไม่มี solution code ที่ถูก comment ทิ้งไว้โดยไม่ตั้งใจ

* Git commit ล่าสุดมี final work

จากนั้นตรวจ:

git status

ควรได้สถานะว่าไม่มี uncommitted changes

---

# 48\. การ Submit

* ส่ง Github link ของ repo ของ project นี้มาที่ Google Classroom ของวิชา  
* ทำ repo ของ project นี้ให้เป็น public ได้

---

# 49\. Workflow ที่แนะนำ

ลำดับการทำงานที่เหมาะสม:

1\. Build starter project  
2\. เพิ่ม index test  
3\. Implement index  
4\. Commit  
5\. เพิ่ม rotor tests  
6\. Implement map\_r\_to\_l  
7\. Implement map\_l\_to\_r  
8\. Commit  
9\. Implement reflector  
10\. Commit  
11\. Implement plugboard  
12\. Commit  
13\. Implement cipher\_char  
14\. Commit  
15\. Implement simple stepping  
16\. Test stepping  
17\. Implement complete stepping  
18\. Commit  
19\. Implement cipher  
20\. เพิ่ม whole-machine tests  
21\. Refactor  
22\. Run final tests  
23\. Update hours\_worked  
24\. Commit final solution  
25\. Submit

อย่ารอเขียน tests หลังทำ code ทั้งหมดเสร็จ

test ควรเป็นเครื่องมือที่ช่วยสร้างโปรแกรมตั้งแต่ต้น

---

# 50\. Optional Challenges

เมื่อทำงานที่กำหนดเสร็จแล้ว สามารถลอง extension ต่อไปนี้

## A. Ring Settings

เพิ่ม historical ring setting ซึ่ง assignment หลักไม่ได้จำลอง

## B. Additional Historical Rotors

รองรับ rotors IV ถึง VIII และ Enigma variants อื่น

## C. Multiple Turnover Notches

naval rotors บางชนิดมี turnover มากกว่าหนึ่งตำแหน่ง

## D. Configuration Parser

ให้ผู้ใช้ป้อน configuration เช่น:

Reflector: B  
Rotors: I II III  
Positions: F U N  
Plugboard: AZ BY CX

แล้วแปลงเป็น OCaml config

## E. Interactive Enigma

สร้าง command-line program ที่ผู้ใช้สามารถ:

* เลือก rotors

* เลือก rotor positions

* ตั้งค่า plugboard

* ป้อน plaintext

* รับ ciphertext

## F. Codebreaking

ทดลองศึกษาวิธีใช้:

* known plaintext

* rotor enumeration

* brute force

เพื่อค้นหา Enigma configuration ที่ไม่ทราบค่า

---

# 51\. มุมมองสำคัญท้ายงาน

แม้งานนี้ถูกนำเสนอในรูปของ Enigma simulator แต่ปัญหา Computer Science ที่สำคัญกว่าคือ:

เราจะจำลอง physical machine ที่มี state เปลี่ยนแปลงอยู่ตลอด โดยใช้ immutable data และ pure functions ได้อย่างไร?

แนวคิดสำคัญคือเปลี่ยนจาก:

physical mutable machine  
        ↓  
immutable configuration value  
        ↓  
config \-\> config

ในลักษณะเดียวกัน behavior ทางไฟฟ้าที่ดูซับซ้อนสามารถแบ่งเป็น composition ของฟังก์ชันเล็ก ๆ:

plugboard  
   ↓  
rotor mappings  
   ↓  
reflector  
   ↓  
reverse rotor mappings  
   ↓  
plugboard

แนวคิดในการแบ่งระบบซับซ้อนออกเป็น **data \+ small transformations** เช่นนี้ ถือเป็นหนึ่งในแนวคิดสำคัญที่สุดของ functional programming