.data
prompt: .asciz "Enter Two Integers: "
intOne: .space 4
intTwo: .space 4
user_specifier: .asciz "%d %d"
int_specifier: .asciz "%d"
newline: .asciz "\n"


.global main
.text


main:
//take in the two integer values
ldr x0, =prompt
bl printf
ldr x0, =user_specifier
ldr x1, =intOne
ldr x2, =intTwo
bl scanf

ldr w1, =intOne
ldr w1, [x1]

ldr w2, =intTwo
ldr w2, [x2]

//load both integers into the x19-x27 regestries
ldr w20, =intOne
ldr w20, [x20]
ldr w21, =intTwo
ldr w21, [x21]

//check if the values inputed are negative, if they are branch to the negation function
cmp w20, wzr
b.lt positiveOne

cmp w21, wzr
b.lt positiveTwo
//If none of the values are negative skip over the negation functions
b recursion

positiveOne:
//negate the register to get the absolute value
neg x20, x20
//check the second integer and branch if it is negative otherwise move to the recursion
cmp w21, wzr
b.lt positiveTwo
b recursion

positiveTwo:
//negate the second integer
neg x21, x21
b recursion


recursion:
//branch to switch and begin the recursion
bl switch
//get the value back and print out the value
ldr x0, =int_specifier
mov x1, x20
bl printf
ldr x0, =newline
bl printf

b exit

switch:
//make room on the stack
sub sp, sp, #16
str x30,[sp, #0]
//if (m < n) then gcd(n, m)
cmp w20, w21
b.gt gcd
//switch the values of x20 and x21 for gcd(n, m)
    mov w23,w20
    mov w20, w21
    mov w21,w23

gcd:
//if m or n is 0
cbz w20, m
cbz w21, m
//calculate the modulo m%n
udiv w1, w20, w21
mul w2, w21, w1
sub w3, w20, w2
//if the remainder is zero then print the value of n
cbz w3, n
//put the value of n into x20
mov w20, w21
//put the value of m % n into x21
mov w21, w3
//recurse
bl gcd

n:
//restore the stack and print the value in main
ldr x30,[sp, #0]
add sp, sp, #16
mov x20,x21
br x30

m:
//restore the stack and print the value in main
ldr x30,[sp, #0]
add sp, sp, #16
br x30


exit:
  	# Exit from the program
  	mov x0, #0
  	mov x8, #93
  	svc #0
