#A Program that asks for your input then outputs what you said.
#Author: Philip Matuskiewicz
#Mips Code

.data #let processor know we will be submitting data to program now

insert_into:
	.word 4 #make a 4 byte (32 bit) space in memory for a word with address insert_into

Ask_Input:
	.asciiz "\Please Enter a String to Print\n" #in unused memory store this string with address Ask_Input

Tell_Output:
	.asciiz "\You typed in: " #in unused memory store this string with address Tell_Output

.text #enables text input / output, kind of like String.h in C++
	

main: #main function is always called in any mips program, so the program will start here with actual assembly code

	la $a0, Ask_Input #load address Ask_Input from memory and store it into arguement register 0
	li $v0, 4 #loads the value 4 into register $v0 which is the op code for print string
	syscall #reads register $v0 for op code, sees 4 and prints the string located in $a0

	la $a0, insert_into #sets $a0 to point to the space allocated for writing a word
	la $a1, insert_into #gets the length of the space in $a1 so we can't go over the memory limit
	li $v0, 8 #load op code for getting a string from the user into register $v0
	syscall #reads register $v0 for op code, sees 8 and asks user to input a string, places string in reference to $a0

	la $a0, Tell_Output #load address Tell_Output from memory and store it into arguement register 0
	li $v0, 4 #loads the value 4 into register $v0 which is the op code for print string
	syscall #reads register $v0 for op code, sees 4 and prints the string located in $a0

	la $a0, insert_into #load address insert_into from memory and store it into arguement register 0
	li $v0, 4 #loads the value 4 into register $v0 which is the op code for print string
	syscall #reads register $v0 for op code, sees 4 and prints the string located in $a0

	li $v0, 10 #loads op code into $v0 to exit program
	syscall #reads $v0 and exits program