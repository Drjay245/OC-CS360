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
# $s1         - Player number
# $s0         - User number


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
	li		$v0,5				# Get the number from the user 
	syscall					
	move	$s1, $v0				#Move $v0 into $s1

	
	jal get_random
	
	move 	$s0, $v0				# $s0= $v0
	li		$t0,3				#t0=3
	divu		$s0,$t0				#s0/t0 or s0 /3
	mfhi		$s0
	addi		$s0,$s0,1			#Adjusts range to 1-3
	
	li 		$v0, 1
	move	$a0, $s0
	syscall
	
	beq		$s1, 10, exit			# If user enters 10, exit.
	beq		$s1,$s0,tie			# If user enters the same call as the computer. the system will go to a tie and loop


	beq		$s0, 1, rock			# If computer gets a 1, rock
	beq		$s0, 2, paper			# If computer gets a 2, paper
	beq		$s0, 3, scissors		# If computer gets a 3, scissors


	## COMPUTER SELECTS ROCK

rock:


	la		$a0, rock_msg			#Displays the message that computer chose rock
	li 		$v0,4
	syscall
	beq		$s1, 2, win			# player chose paper and won
	beq		$s1, 3, lost			# player chose SCISSORS and lost

	
								#s0 = random number for computer put into a4.
								#s0-  1 = Rock
								#s0-  2 = Paper
								#s0-  3 = Scissors
										
								#if random = rock user jumps to tie
								#if random = paper user jumps to lost
								#if random = scissors user jumps to win



	## COMPUTER SELECTS PAPER
paper:

	la		$a0, paper_msg		#Displays the message that computer chose paper
	li 		$v0,4
	syscall
	beq		$s1, 1, lost			# player chose rock and lost
	beq		$s1, 3, win			# computer chose paper and won
	
								#s0 = random number for computer put into a4.
								#s0-  1 = Rock
								#s0-  2 = Paper
								#s0-  3 = Scissors
								
								#if random = rock user jumps to win
								#if random = paper user jumps to tie
								#if random = scissors user jumps to lost



	## COMPUTER SELECTS SCISSORS
scissors:

	la		$a0, scissors_msg		#Displays the message that computer chose scissors
	li 		$v0,4
	syscall
	beq		$s1, 1, win			# player chose rock and won
	beq		$s1, 2, lost			# player chose paper and lost

	
								#s0 = random number for computer put into a4
								#s0-  1 = Rock
								#s0-  2 = Paper
								#s0-  3 = Scissors
						
								#if random = rock user jumps to lost
								#if random = paper user jumps to win
								#if random = scissors user jumps to tie							
	

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
	mflo	        $t0					# t0 = low half 
	addu        $t2, $t0, $t3			# m_z = t2
	sw		$t2, m_z


	##   m_w = 18000 * (m_w & 65535) + (m_w>>16);
 
	srl    	$t3, $t1, 0x10			# t3 = m_w >> 16. shifting right appropriately
	and         $t4, $t1, 0xFFFF	  	# t4 = m_w & 1111 1111 or 65535
	li    	        $t0, 18000			# $t0 = 18000
	multu       $t4, $t0	      			# t4 * 18000
	mflo        $t0					# t0 = low half 
	addu        $t1, $t0, $t3     		# m_w = t1
	sw		$t1, m_w

								## (m_z <<16) + m_w

	sll    		$t0, $t2, 0x10			# t0 = m_z << 16 shift left by 16
	addu        $v0,$t0, $t1			# t0 = t0 + m_w

	
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

welcome_msg:		.asciiz	"Welcome to Rock, Paper, Scissors.\n"
inst_msg:			.asciiz	"Enter a 1 for ROCK, a 2 for PAPER, or a 3 for SCISSORS. Enter a 10 to QUIT.\n"
rock_msg:		.asciiz	"The Computer chose Rock.\n"
paper_msg:		.asciiz	"The Computer chose Paper.\n"
scissors_msg:		.asciiz	"The Computer chose Scissors.\n"
win_msg:			.asciiz	"Congrats, you beat the computer\n"
loss_msg:			.asciiz	"Sorry, the computer just stomped you.\n"
tie_msg:			.asciiz	"You and the computer chose the same call. TIE\n"
quit_msg:			.asciiz	"Thanks for playing. Hope you had fun.\n"



	## NOTES
	#move        $t5,$v0				# Move number read into $t5
	#move        $a1,$t5				# Move number into an address
	#li 		$v0,5				# load syscall print int into $v0
	#syscall

	# divide digit by 10, 7-9 rock. 4-6 paper, 1-3 scissors
	#put in register and then divide 
	
	
## End of rps.asm
