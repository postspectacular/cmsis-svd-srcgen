* cmsis-svd-gen

Convert ARM CMSIS SVD specs (processor peripherals, register &
bitfields) into source code for different languages.

Currently supported target languages are: Asm (GAS flavor), C and
Clojure. Other languages can be easily supported by defining a new
XSLT stub file with language specific configuration/formatting.

** Usage

#+BEGIN_SRC shell
./convert asm|c|clj svd-file > output-file

# filtered output via "only" and "excl" params
# only includes given peripheral IDs or excludes these
./convert lang svd only=PERIPH1,PERIPH2... > output
./convert lang svd excl=PERIPH1,PERIPH2... > output
#+END_SRC

** Requirements

- [[http://www.saxonica.com/download/opensource.xml][SAXON-HE 9.7+]] (or another XSLT2.0 capable processor)
- Java 7+

You'll also need to download an SVD file for your CPU, e.g. STM32 CPU
specs can be found here (requires registration):

https://cmsis.arm.com/vendor/stmicroelectronics/

SVD list for all manufacturers (under CMSIS-SVD tab on that page):
http://www.arm.com/products/processors/cortex-m/cortex-microcontroller-software-interface-standard.php

** Output format

Depending on included details in SVD file, the following definitions
are generated:

- peripheral base registers
- peripheral sub-registers
- register bitfield offsets & masks

Some SVD specs define derived periphals. The extractor supports this
feature and generates a replicated register set (with correct address
offsets) for each derived definition.

*** Naming convention

The overall generate symbol formats follow these patterns:

#+BEGIN_SRC
PERIPHERAL baseaddress
PERIPHERAL_REGISTER baseaddress + registeroffset
PERIPHERAL_REGISTER_FIELD_SHIFT xx (bit position)
PERIPHERAL_REGISTER_FIELD_MASK xx (absolute bit mask, e.g. "0xf << 24")
PERIPHERAL_REGISTER_FIELD_RMASK xx (raw unshifted bit mask, zero-based)
#+END_SRC

Because three different symbols are defined for each bitfield item,
the generated files can become quite large (10k+ lines).

*** Example output
**** Assembly

 #+BEGIN_SRC asm
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 @
 @ STM32F401x SVD peripherals & registers
 @

 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 @
 @ General-purpose I/Os (derived from GPIOH)
 @

 .equ GPIOD 0x40020c00
 .equ GPIOD_MODER GPIOD + 0x0 @ GPIO port mode register
 .equ GPIOD_MODER_MODER15_SHIFT 30
 .equ GPIOD_MODER_MODER15_RMASK 0x3
 .equ GPIOD_MODER_MODER15_MASK 0x3 << 30
 .equ GPIOD_MODER_MODER14_SHIFT 28
 .equ GPIOD_MODER_MODER14_RMASK 0x3
 .equ GPIOD_MODER_MODER14_MASK 0x3 << 28
 .equ GPIOD_MODER_MODER13_SHIFT 26
 .equ GPIOD_MODER_MODER13_RMASK 0x3
 .equ GPIOD_MODER_MODER13_MASK 0x3 << 26
 .equ GPIOD_MODER_MODER12_SHIFT 24
 .equ GPIOD_MODER_MODER12_RMASK 0x3
 .equ GPIOD_MODER_MODER12_MASK 0x3 << 24
 .equ GPIOD_MODER_MODER11_SHIFT 22
 .equ GPIOD_MODER_MODER11_RMASK 0x3
 .equ GPIOD_MODER_MODER11_MASK 0x3 << 22
 .equ GPIOD_MODER_MODER10_SHIFT 20
 .equ GPIOD_MODER_MODER10_RMASK 0x3
 .equ GPIOD_MODER_MODER10_MASK 0x3 << 20
 .equ GPIOD_MODER_MODER9_SHIFT 18
 .equ GPIOD_MODER_MODER9_RMASK 0x3
 .equ GPIOD_MODER_MODER9_MASK 0x3 << 18
 .equ GPIOD_MODER_MODER8_SHIFT 16
 .equ GPIOD_MODER_MODER8_RMASK 0x3
 .equ GPIOD_MODER_MODER8_MASK 0x3 << 16
 .equ GPIOD_MODER_MODER7_SHIFT 14
 .equ GPIOD_MODER_MODER7_RMASK 0x3
 ...
 #+END_SRC

**** C

 #+BEGIN_SRC c
 /****************************************************************
  * STM32F40x SVD peripherals & registers
  ****************************************************************/

 /****************************************************************
  * General-purpose I/Os (derived from GPIOI)
  ****************************************************************/
 #define GPIOD 0x40020c00
 #define GPIOD_MODER GPIOD + 0x0 // GPIO port mode register
 #define GPIOD_MODER_MODER15_SHIFT 30
 #define GPIOD_MODER_MODER15_RMASK 0x3
 #define GPIOD_MODER_MODER15_MASK 0x3 << 30
 #define GPIOD_MODER_MODER14_SHIFT 28
 #define GPIOD_MODER_MODER14_RMASK 0x3
 #define GPIOD_MODER_MODER14_MASK 0x3 << 28
 #define GPIOD_MODER_MODER13_SHIFT 26
 #define GPIOD_MODER_MODER13_RMASK 0x3
 #define GPIOD_MODER_MODER13_MASK 0x3 << 26
 #define GPIOD_MODER_MODER12_SHIFT 24
 #define GPIOD_MODER_MODER12_RMASK 0x3
 #define GPIOD_MODER_MODER12_MASK 0x3 << 24
 #define GPIOD_MODER_MODER11_SHIFT 22
 #define GPIOD_MODER_MODER11_RMASK 0x3
 #define GPIOD_MODER_MODER11_MASK 0x3 << 22
 #define GPIOD_MODER_MODER10_SHIFT 20
 #define GPIOD_MODER_MODER10_RMASK 0x3
 #define GPIOD_MODER_MODER10_MASK 0x3 << 20
 #define GPIOD_MODER_MODER9_SHIFT 18
 #define GPIOD_MODER_MODER9_RMASK 0x3
 #define GPIOD_MODER_MODER9_MASK 0x3 << 18
 #define GPIOD_MODER_MODER8_SHIFT 16
 #define GPIOD_MODER_MODER8_RMASK 0x3
 #define GPIOD_MODER_MODER8_MASK 0x3 << 16
 #define GPIOD_MODER_MODER7_SHIFT 14
 #define GPIOD_MODER_MODER7_RMASK 0x3
 ...
 #+END_SRC

** License

(c) 2015 Karsten Schmidt
