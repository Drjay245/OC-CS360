

# readstr.asm
# Registers used:
# a0		- syscall argument for target read address
# a1		- syscall argument for read length
# v0		- syscall parameter
# t1		- pointer to user string
# t2		- current character
# t0		- userd to hold length of user string

	.text
main:						# Execution starts at main
	la  $a0, usrstr			# Load the destination address into a0
	li   $a1, 0x40			# Load the 64 byte limit into a1
	li   $v0, 8				#syscall parameter for read_string
	syscall				# execute syscall

	## Store the length of user string

	lw   $t0, $zero				# t0=0
l	la	$t1, usrstr	 			# Get a pointer to user string
	starlen_loop:
	## look at each character if new line, end loop, else t0++
	
	lb	$t2, 0($t1)			# Read what string pointer sees t2 = &t1
	beq  $12,10, pool_melrts		# If t2  = new line exit loop
	addi	$t0,1				# increment length
	addi $t1,1				# Increment the string pointer
	b	strlen_loop			# loop back to beginning
	


	pool_melrts:

## Echo the user string with a label from below	
	la $a0, restlbl	# get response message address
	li $v0, 4		# pring string syscall
	syscall		# execute syscall	

	la $a0, usrstr	# get the users entered value
	li $v0, 4		# pring string syscall
	syscall		# execute syscall


## Echo the string length with a label from below	
	move $a0, $t0        # move string length to syscall arg
	li $v0, 1		# pring int syscall
	syscall		# execute syscall	

	la $a0, lenlbl	# get the address of length label
	li $v0, 4		# pring string syscall
	syscall		# execute syscall


## Exit the program  
	li $v0, 10		# syscall code 10 is exit
	syscall		# Look in $v0 and execute the syscall

	ldata
usrstr: .space  0x40	# reserved 64 bytes of memory	
lenlbl: .asciiz * characters long.\m"
restlbl: .asciiz " You entered:  " 


	.text
main:					# execution starts at main
	la	$a0, hello		# load the address of hello string to $a0
	jal	print_string		# call print string function

	la	$a0, hello		# load the address of hello string to $a0
	jal	print_string		# call print string function

# Lets print some of our data segment as integers

	la	$t0, hello		# load the address of the beginning of data seg
	lb       $a0, 1($t0)    	#  load the value 1 after the beginning of data
	li	$v0,1			# Print int syscall
	syscall			#execution begins

	lw	$a0,hello		#load the address of beginning of data
	li 	$v0,1			#syscall print_int
	syscall			# print the word
	la	$a0, nline		#address of new line
	jal	print_string		#Call print_string function
	li	$v0,10		#syscall exit
	syscall			#be out

print_string:
	li	$v0,4			# print string syscall
	syscall			#execute
	jr $ra
