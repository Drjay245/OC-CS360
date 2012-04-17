#Justin Gaeta 2/20/12 
#rps.asm- Rock Paper Scissors Program
# Registers Used:
# $a0
# $a1
# $v0         - sys parameter
# $t0
# $t1
# $t2
# $t3
# $t4
# $t5  	   - used to hold the users number. this number will determin rock, paper, or scissor.



	.text
main:		
								# Execution Starts at Main
								# declaration for string variable
								# .asciiz directive makes string null terminated

	##WELCOME MESSAGE
	la		$a0, welcome_msg		# load address of welcome_msg to be printed into $a0
	li		$v0, 4				# 4 is the print_string syscall;
	syscall						# do syscall
	
	b loop						# Enters the loop for the program

loop:

	##INSTRUCTION MESSAGE
	la		$a0, inst_msg			# load address of inst_msg to be printed into $a0
	li		$v0, 4				# 4 is the print_string syscall;
	syscall						# do syscall

	##GET NUMBER FROM USER 
	li		$v0,5				# Get the number from the user and put it into $t5
	syscall							
	move	$s1, $v0				#Move $v0 into $t4
	
	

	beq		$s1, 1, rock			# If user enters a 1, rock
	beq		$s1, 2, paper			# If user enters a 2, paper
	beq		$s1, 3, scissors			# If user enters a 3, scissors
	beq		$s1, 10, exit			# If user enters 10, exit.


	## USER SELECTS ROCK

rock:


	jal get_random					# Calculates the random number
	move 	$s0, $v0				# $s0= $v0
	li		$t0,3				#ti=3
	divu		$s0,$t0				#s0/t0 or s0 /3
	mihi		$s0
	adddi	$s0,$s0,1			#Adjusts range to 1-3
	
	
								#a4 = random number for computer put into a4.
								#a4-  1 = Rock
								#a4-  2 = Paper
								#a4-  3 = Scissors
										
	beq		$s0,$s1,tie			#if random = rock user jumps to tie
								#if random = paper user jumps to lost
								#if random = scissors user jumps to win



	## USER SELECTS PAPER
paper:

	jal get_random					# Calculates the random number
	
								#a4 = random number for computer put into a4.
								#a4-  1 = Rock
								#a4-  2 = Paper
								#a4-  3 = Scissors
								
								#if random = rock user jumps to win
	beq		$s0,$s1,tie			#if random = paper user jumps to tie
								#if random = scissors user jumps to lost



	## USER SELECTS SCISSORS
scissors:

	jal get_random					# Calculates the random number
	
								#a4 = random number for computer put into a4
								#a4-  1 = Rock
								#a4-  2 = Paper
								#a4-  3 = Scissors
								
								#if random = rock user jumps to lost
								#if random = paper user jumps to win
	beq		$s0,$s1,tie			#if random = scissors user jumps to tie							
	

lost:
	##LOST MESSAGE
	la		$a0, loss_msg			# load address of inst_msg to be printed into $a0
	li		$v0, 4				# 4 is the print_string syscall;
	syscall						# do syscall
	
	b		loop					#Loops the Game

win:
	##WIN MESSAGE
	la		$a0, win_msg			# load address of inst_msg to be printed into $a0
	li		$v0, 4				# 4 is the print_string syscall;
	syscall						# do syscall
	
	b		loop					#Loops the Game
tie:
	##TIE MESSAGE
	la		$a0, tie_msg			# load address of inst_msg to be printed into $a0
	li		$v0, 4				# 4 is the print_string syscall;
	syscall						# do syscall
	
	b		loop					# Loops the Game
	

get_random:
	subu 	$sp,$sp,32        	  	# 32 byte stack frame
	
	sw   		$ra,20($sp)	                # save return address
	sw   		$fp,16($sp)	                # save frame pointer
	addu        $fp,$sp, 32	         	# set up a new frame pointer

	la  		$t0, m_w	              	 	# Get address of m_w seed
	lw	        $t1, 0($t0)                	# load m_w seed. Placed m_w into $t1
	lw 	        $t2, 4($t0)	                # load m_z seed. Placed m_z into $t2


	##   m_z = 36969 * (m_Z & 65536) + (m_z >>16);

	srl   	        $t3, $t2, 0x10			# t3 = m_z >> 16. shifting right appropriately
	and         $t4, $t2, 0xFFFF   		# t4 = m_z & 1111 1111 or 65535
	li              $t0, 36969			# $t0 = 36969
	multu       $t4, $t0	      			# t4 * 36969
	mflo         $t0					# t0 = low half 
	addu        $t2, $t0, $t3			# m_z = ….


	##   m_w = 18000 * (m_w & 65535) + (m_w>>16);
 
	srl    	$t3, $t1, 0x10			# t3 = m_w >> 16. shifting right appropriately
	and         $t4, $t1, 0xFFFF	  	# t4 = m_w & 1111 1111 or 65535
	fli    	        $t0, 18000			# $t0 = 18000
	multu       $t4, $t0	      			# t4 * 18000
	mflo         $t0					# t0 = low half 
	addu        $t1, $t0, $t3     		# m_w = ….

			## (m_z <<16) + m_w

	sll    		$t0, $t2, 0x10			# t0 = m_z << 16 shift left by 16
	addu        $t0,$t0, $t1			# t0 = t0 + m_w

	
	## Restore stack
	lw   	       $ra, 20 ($sp)			# restore return address from stack
	lw            $fp,16($sp)		     	# restore frame pointer from stacki
	addu       $sp, $sp, 32			# release stack frame reserved
	jr             $ra					# return from the function



exit:
	##EXIT MESSAGE
	la		$a0, quit_msg			# load address of inst_msg to be printed into $a0
	li		$v0, 4				# 4 is the print_string syscall;
	syscall						# do syscall
	li    		$v0, 10				#syscall code 10 is to exit
	syscall						#exits the program
	
	



	##DATA FOR PROGRAM
	.data
m_w:  .word 776410
m_z:  .word 469865

welcome_msg:		.asciiz	"Welcome to your first Rock, Paper, Scissors game completly done in MIPS.\n"
inst_msg:			.asciiz	"Enter a 1 for ROCK, a 2 for PAPER, or a 3 for SCISSORS. Enter a 10 to QUIT.\n"
rock_msg:		.asciiz	"The Computer chose Rock.\n"
paper_msg:		.asciiz	"The Computer chose Paper.\n"
scissors_msg:		.asciiz	"The Computer chose Scissors.\n"
win_msg:			.asciiz	"Congrats, you beat the computer\n"
loss_msg:			.asciiz	"Sorry, the computer just stomped you.\n"
tie_msg:			.asciiz	"You and the computer chose the same. TIE\n"
quit_msg:			.asciiz	"Thanks for playing. Hope you had fun.\n"



	## NOTES
	#move        $t5,$v0				# Move number read into $t5
	#move        $a1,$t5				# Move number into an address
	#li 		$v0,5				# load syscall print int into $v0
	#syscall

	# divide digit by 10, 7-9 rock. 4-6 paper, 1-3 scissors
	#put in register and then divide 
	
	
## End of rps.asm
