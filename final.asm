.data  
#Arrays To Sotre Data

         Buffer1: .space 10000                        # The buffer that holds the string of the file 
         Buffer2: .space 10000                        # The buffer that holds the string of the file 
         codes: .space 10000
         codes1: .space 10000 
         words: .space 10000 
        CompressedData:   .space 1024 
         CompressedData1:   .space 1024  # to write it to file 
        DecompressedData:   .space 1024   
         DecompressedData1:   .space 1024     # to write it to file     
          Chooseuser1 : .asciiz ""                     # store the Y or N
	Chooseuser4: .asciiz ""                     # store the C or D OR Q
	Dfile : .asciiz ""	                    # store the file name
	theFile : .asciiz ""	
	CompFile: .asciiz ""
	DecompFile:  .asciiz ""              
	WrongKeyword: .asciiz "\nPlease enter a valid character"
	Message: .asciiz "\n Finished..."
        Message1: .asciiz "\nError: File Not Found\n "   
 	Message2: .asciiz "\n Finished..."  
        newline:  .asciiz "\n"
 	char1: .byte 'y'                          	
	char2: .byte 'n'
	char3: .byte 'c'
	char4: .byte 'd'
	char5: .byte 'q'
	codefile: .asciiz "C:\\Users\\97056\\Desktop\\5-2\\arc\\project1\\code.txt"
	Createdfile: .asciiz "C:\\Users\\DELL\\Desktop\\Diana\\Arch\\dictionary.txt"
	CompressedFile:.asciiz "C:\\Users\\97056\\Desktop\\5-2\\arc\\project1\\compressed.txt"
	DecompressedFile:.asciiz "C:\\Users\\97056\\Desktop\\5-2\\arc\\project1\\decompressed.txt"
#Messagessciiz

        uncompressedFileSize: .asciiz "\n The uncompressed file size = Number of characters x 16 = "
        compressedFileSize: .asciiz "\n The compressed file size = Number of binary codes x 16 = "
        fileCompRatio: .asciiz "\n File Compression Ratio = uncompressed file size / compressed file size = "
        charMsg: .asciiz " \n Number of characters : "
        wordMsg: .asciiz "\n Number of binary codes: "
	doneWrite: .asciiz "\n Done Write to The Text File"          
	dictionaryNotExist:    .asciiz "\n Sorry There is no dictionary to Decompress Your File..\n Good Bye :) ! \n "     
	Welcome:.asciiz "\t\t\t\t\tFirst Project || A Simple Dictionary-based Compression and Decompression"
	Names: .asciiz "\t\t\t\t\tDiana Allan 1180665 | Bara'a Fatoony 1180556"
	One:.asciiz " If the dictionary.txt file exist enter [Y] If Not enter [N]"
	Five: .asciiz " Enter the path of the file to be compressed \n"  
	Two: .asciiz "Enter the path of dictionary.txt"
	Four: .asciiz "\n If you want to compression enter [c] \n If you want to decompression enter [d] \n If you want to quit the program enter [q]"
	CompRatio: .asciiz "\n compression ratio = "
	Six: .asciiz " Enter the path of the file to be decompressed\n"  
	NotExist: .asciiz "\n Error! There is a code in the file that do not exist in the dictionary"
        word: .space 60
        code: .space 20
        space: .asciiz " "
        point: .asciiz "."
        comma: .asciiz ","
        slash: .asciiz "/"
        linee: .asciiz "\n"
        null: .asciiz ""
        result: .float 0.0
   
	
         
.text 

#------------------------------------------------------------------------------------------------------#

menu:

	.macro new_line
	li $v0 11 	 			    # syscall 11: print a character based on its ASCII value
     	li $a0 10 	 			    # ASCII value of a new line is "10"
     	syscall
 	.end_macro 

# Open the file for reading
    li $v0, 13          # System call code for open
    la $a0, codefile   # Load the address of the filename string
    li $a1, 0           # Flag: read-only mode
    li $a2, 0           # File permissions (ignored)
    syscall             # Invoke the system call

    move $s0, $v0       # Store the file descriptor in $s0

    # Read the file
    li $v0, 14          # System call code for read
    move $a0, $s0       # Move the file descriptor to $a0
    la $a1, codes     # Load the address of the buffer
    li $a2, 2000        # Maximum number of bytes to read
    syscall             # Invoke the system call

    
    # Close the file
    li $v0, 16          # System call code for close
    move $a0, $s0       # Move the file descriptor to $a0
    syscall 	 		 	

		
#Dispaly message name and the project

#print new line
     new_line	

#print welcome message  	
	li $v0,4                  		    # code call print string message 
   	la $a0, Welcome		 	            # Welcome message
   	syscall
   	
#print new line
     new_line	

#print our names
   	li $v0,4                 		    # code call print string message 
   	la $a0, Names		  		    # message print names
   	syscall	

#print new line
     new_line	
  	
#------------------------------------------------------------------------------------------------------#


one:
  	li   $v0,4 				    # code call print string 
  	la   $a0, One 	
 	syscall

#Getting user 's input text
	li   $v0,8  				    # tell the system to prepare to get text
	la   $a0,Chooseuser1                          # store the y or n 				
	li   $a1,80				    # tell the system the maximum length 80 char
	syscall 

#To make The options case-insensitive     
         
toLowerCase:

	lb   $t2, Chooseuser1                    # $t2 = content of the plain file loaded byte by byte 
	blt  $t2, 'A', case                          # if the character less than A or greater than Z then ignore it
	bgt  $t2, 'Z', case
	add  $t2, $t2, 32                            # else it will be converted to lower case by add 32 to it
	sb   $t2, Chooseuser1                                        # store the bytes in t2

case:
       sb   $t2, Chooseuser1 

	lb   $t1,0($a0)                             # t1 = user 's input 	      
        lb   $s1,char1                              # char1 = y
        lb   $s2,char2                              # char2=  n
        
        beq  $t1,$s1,Read_dictionary              # if user input = y
        beq  $t1,$s2,Creat_dictionary 	            # if user input = n
       
     
        la   $a0,WrongKeyword
        li   $v0,4
        syscall

#Terminated Program if a wrong key word is entered
        j one
	
Read_dictionary:  

    add    $s5, $zero, $zero
    add    $s6, $zero, $zero
    la $s5, Buffer1  # Load the address of the buffer into $t0
    la $s6, Buffer2  # Load the address of the buffer into $t0  

    
#Display message of plain text file :
  	li   $v0,4 				    # code call print string 
  	la   $a0, Two  	 		           # message to enter the name of the file 
 	syscall
   	new_line

# Getting user 's inpout text
	li   $v0,8  				    # tell the system to prepare to get text
	la   $a0,Dfile 		            # store the name of file
	li   $a1,80 				    # tell the system the maximum length 80 char 
	syscall 
	
	move $t1, $a0
	
#remove \n from file name
	li $s0,0			# Set index to 0
	removeW1:
	lb $a3,Dfile($s0)		# Load character at index
	addi $s0,$s0,1			# Increment index
	bnez $a3,removeW1		# Loop until the end of string is reached
	subiu $s0,$s0,2			# If above not true, Backtrack index to '\n'
	sb $0, Dfile($s0)		# Add the terminating character in its place
	
#Open file to read and store						
        li   $v0,13           	                    # open_file syscall code = 13
    	la   $a0,Dfile     	                    # get the file name
    	li   $a1,0           	                    # file flag = read (0)
    	syscall
    	move $s0,$v0        	                    # save the file descriptor. $s0 = file
		
#read the file
	li   $v0, 14		                    # read_file syscall code = 14
	move $a0,$s0		                    # file descriptor
	la   $a1,Buffer1  	                    # The buffer that holds the string of the Whole file
	la   $a2,1024		                    # hardcoded buffer length
	syscall	
	
	
#print content of array 	
	li $v0 , 4
	la $a0 , Buffer1
	syscall 
	li $s3 , 0	
	addi $t1, $zero,0
	addi $t2, $zero,2000
	split_dic:
	bge $t1, $t2 , exit_split
	lb $t0 , ($s5)
	beq $t0 , '\0' , print
	beq  $t0,' ', newElement
	#addi $s6 , $s6 , 15
	addi $s5 , $s5 , 1
	addi $t1 , $t1 , 1 
	j split_dic
	add_new_line:
	sb $t0, ($s6)
	addi $s6 , $s6 , 1
	j add_space
	newElement:
	addi $s5 , $s5 , 1
	addi $t1 , $t1 , 1 
	bge $t1, $t2 , exit_split
	lb $t0 , ($s5)
	beq  $t0,'\n', add_space
	sb $t0, ($s6)
	addi $s6 , $s6 , 1
	j newElement
	
	
	add_space:
	li $t5, 0x2F
	sb $t5, ($s6)
	addi $s6 , $s6 , 1
	addi $s3,$s3,1
	j split_dic
	exit_split:
	
	
#print new line
     new_line

print:	
#print content of array 	
	li $v0 , 4
	la $a0 , Buffer2
	syscall 
	
	
#Close the file
    	li   $v0, 16         		            # close_file syscall code
    	move $a0,$s0      		            # file descriptor to close
    	syscall	        
       
       
       new_line
       
 

Fourr1:
#asks the user whether he or she wants to do compression or decompression
      	li   $v0,4 				    # code call print string 
  	la   $a0, Four  	 		           # message to choose
 	syscall
   	new_line     
          
            
#Getting user 's input text
	li   $v0,8  				    # tell the system to prepare to get text
	la   $a0,Chooseuser4                         # store the y or n 				
	li   $a1,80				    # tell the system the maximum length 80 char
	syscall 

#To make The options case-insensitive             
toLowerCase41:

	lb   $t2, Chooseuser4                  # $t2 = content of the plain file loaded byte by byte 
	blt  $t2, 'A', case41                       # if the character less than A or greater than Z then ignore it
	bgt  $t2, 'Z', case41
	add  $t2, $t2, 32                            # else it will be converted to lower case by add 32 to it
	sb   $t2, Chooseuser4                                   # store the bytes in t2

case41:
       sb   $t2, Chooseuser4

	lb   $t1,0($a0)                             # t1 = user 's input 	      
        lb   $s1,char3                             # char= c
        lb   $s2,char4                              # char=  d
        lb   $s3,char5                              #char=q
        
        beq  $t1,$s1,Compression1                   # if user input = c
        beq  $t1,$s2,Decompression1 	            # if user input = d
        beq  $t1,$s3,End_Programe                 # if user input = q
     
        la   $a0,WrongKeyword
        li   $v0,4
        syscall

        j Fourr1   
          
Compression1: #*******************************************************************************************	

#asks the user to enter the path of the file to be compressed

        li   $v0,4 				    # code call print string 
  	la   $a0, Five  	 		           # message to choose
 	syscall

#Getting user 's input text
	li   $v0,8  				    # tell the system to prepare to get text
	la   $a0,CompFile                          # store the input			
	li   $a1,80				    # tell the system the maximum length 80 char
	syscall 

#remove \n from file name
	li $s0,0			# Set index to 0
	removeW1C:
	lb $a3,CompFile($s0)		# Load character at index
	addi $s0,$s0,1			# Increment index
	bnez $a3,removeW1C		# Loop until the end of string is reached
	subiu $s0,$s0,2			# If above not true, Backtrack index to '\n'
	sb $0, CompFile($s0)		# Add the terminating character in its place
		
##Open file to read and store						
        li   $v0,13           	                    # open_file syscall code = 13
    	la   $a0,CompFile     	                    # get the file name
    	li   $a1,0           	                    # file flag = read (0)
    	syscall
    	move $s0,$v0        	                    # save the file descriptor. $s0 = file
		
#read the file
	li   $v0, 14		                    # read_file syscall code = 14
	move $a0,$s0		                    # file descriptor
	la   $a1,CompressedData  	                    # The buffer that holds the string of the Whole file
	la   $a2,1024		                    # hardcoded buffer length
	syscall	
	
#Close the file
    	li   $v0, 16         		            # close_file syscall code
    	move $a0,$s0      		            # file descriptor to close
    	syscall	        

#print content of array 
   	move $s4,$0 	 			    # clear
   	addi $t0,$0,13   			    # store the size of array
   	

#computes the compression ratio and prints it on the screen
   
   
    # Load the address of the StringBuffer into $a0
    la $a0, CompressedData
    
    # Count the number of characters without spaces
    li $t0, 0
    # Count the number of words
    li $t3, 49
    
    count_chars:
        lb $t1, ($a0)
        beq $t1, '\0', print_results# check if the character is greater than 'z' (not_alpha)
        addi $t0, $t0, 1 # Increment the character counter
        addi $a0, $a0, 1 # Increment the character counter
        j count_chars
     # Print out the results
    print_results:
    subu $t0,$t0,1
     move $t6,$t0
        # Print the number of characters without spaces
        
        
         li $v0, 4 # System call to print string
        la $a0, charMsg
        syscall
        
         li $v0, 1 # System call to print integer
        move $a0, $t0
        syscall
         
         li $v0, 4 # System call to print string
        la $a0, wordMsg
        syscall
        
        
        li $v0, 1 # System call to print integer
        move $a0, $t3
        syscall
        

        li $v0, 4 # System call to print string
        la $a0,uncompressedFileSize
        syscall
        
        mul $t0, $t0, 2
        
        li $v0, 1 # System call to print integer
        move $a0, $t0
        syscall
        
         li $v0, 4 # System call to print string
        la $a0, compressedFileSize
        syscall
        
        mul $t3, $t3, 2
        
        li $v0, 1 # System call to print integer
        move $a0, $t3
        syscall
        
        
    # Convert dividend and divisor to floating-point values
    mtc1 $t0, $f0
    cvt.s.w $f0, $f0
    mtc1 $t3, $f2
    cvt.s.w $f2, $f2
        
        # Perform the division
    div.s $f4, $f0, $f2
    # Store the result in memory
    swc1 $f4, result
        
         li $v0, 4 # System call to print string
        la $a0, fileCompRatio
        syscall
        
         
    lwc1 $f12, result
    li $v0, 2
    syscall


#print new line
     new_line

#search
        la $v1 , codes1
    
        li $v0 , 4
	la $a0 , CompressedData
	syscall 
	
	#print new line
     new_line
     
     
   addu $s7 , $zero , 0	
   la $s4 , CompressedData
   la $s3 , word
   move_word_to_buffer:
   lb $t1, ($s4)     # Load byte from buffer into $t1
   beq $t1 , '.' ,pointt
   beq $t1 , ',' ,commaa
   beq $t1 , ' ' ,spacee
   beq $t1 , '\n' ,line
   beq $t1 , '\0',end_of_file
   sb $t1, ($s3)
   addiu $s3, $s3, 1
   addiu $s4, $s4, 1
   j move_word_to_buffer
   
   
line:
    la $s0, Buffer2    # Load address of buffer into $s0
    la $s1, word      # Load address of word into $s1
    li $s2 , 0
    li $t3 , 0
    la $t0,null
    lb $t4, ($t0)
    jal search
    
    jal clear_buffer
    
    la $s1, linee 
    lb $t0 , ($s1)
    la $s5 , word
    sb $t0 , ($s5)
    la $s0, Buffer2    # Load address of buffer into $s0
    la $s1, word     # Load address of word into $s1
    li $s2 , 0
    li $t3 , 0
    la $t0,null
    lb $t4, ($t0)
    jal search
    jal clear_buffer
    addiu $s4, $s4, 1
    j move_word_to_buffer   
pointt:
    la $s0, Buffer2    # Load address of buffer into $s0
    la $s1, word      # Load address of word into $s1
    li $s2 , 0
    li $t3 , 0
    la $t0,null
    lb $t4, ($t0)
    jal search
    
    jal clear_buffer
    
    la $s1, point 
    lb $t0 , ($s1)
    la $s5 , word
    sb $t0 , ($s5)
    la $s0, Buffer2    # Load address of buffer into $s0
    la $s1, word     # Load address of word into $s1
    li $s2 , 0
    li $t3 , 0
    la $t0,null
    lb $t4, ($t0)
    jal search
    jal clear_buffer
    
    la $s1, space 
    lb $t0 , ($s1)
    la $s5 , word
    sb $t0 , ($s5)
    la $s0, Buffer2    # Load address of buffer into $s0
    la $s1, word     # Load address of word into $s1
    li $s2 , 0
    li $t3 , 0
    la $t0,null
    lb $t4, ($t0)
    jal search
    jal clear_buffer
    addiu $s4, $s4, 1
    j move_word_to_buffer
commaa:
    la $s0, Buffer2    # Load address of buffer into $s0
    la $s1, word      # Load address of word into $s1
    li $s2 , 0
    li $t3 , 0
    la $t0,null
    lb $t4, ($t0)
    jal search
    
    jal clear_buffer
    
    la $s1, comma
    lb $t0 , ($s1)
    la $s5 , word
    sb $t0 , ($s5)
    la $s0, Buffer2    # Load address of buffer into $s0
    la $s1, word     # Load address of word into $s1
    li $s2 , 0
    li $t3 , 0
    la $t0,null
    lb $t4, ($t0)
    jal search
    jal clear_buffer
    
    la $s1, space
    lb $t0 , ($s1)
    la $s5 , word
    sb $t0 , ($s5)
    la $s0, Buffer2    # Load address of buffer into $s0
    la $s1, word     # Load address of word into $s1
    li $s2 , 0
    li $t3 , 0
    la $t0,null
    lb $t4, ($t0)
    jal search
    jal clear_buffer
    addiu $s4, $s4, 1
    j move_word_to_buffer
spacee:
   la $s0, Buffer2    # Load address of buffer into $s0
    la $s1, word      # Load address of word into $s1
    li $s2 , 0
    li $t3 , 0
    la $t0,null
    lb $t4, ($t0)
    
    jal search
    
    jal clear_buffer
    
    la $s1, space
    lb $t0 , ($s1)
    la $s5 , word
    sb $t0 , ($s5)
    
    la $s0, Buffer2    # Load address of buffer into $s0
    la $s1, word     # Load address of word into $s1
    li $s2 , 0
    li $t3 , 0
    la $t0,null
    lb $t4, ($t0)
    jal search
    jal clear_buffer
    addiu $s4, $s4, 1
    j move_word_to_buffer
    
clear_buffer :
   la $s3 , word	  
   la $a0, word   # Load buffer address
    li $a1, 0         # Set value 0
    li $t0, 60       # Set buffer size
    
    clear_loop:
    sb $a1, ($a0)     # Store zero in the buffer byte
    addiu $a0, $a0, 1 # Increment buffer address
    addiu $t0, $t0, -1  # Decrement buffer size
    bnez $t0, clear_loop  # Branch if buffer size is not zero  
    li $a0 , 0
    jr $ra


search:

    lb $t1, ($s0)     # Load byte from buffer into $t1
    lb $t2, ($s1)     # Load byte from word into $t2    
    beq $t2,$t4 ,match
    beq $t1,$t4 , not_match
    beq $t1, '/', find_code # End of buffer reached, word not found
    bne $t1, $t2, mismatch
    addiu $s0, $s0, 1           # Bytes match, check next byte in buffer
    addiu $s1, $s1, 1           # Check next byte in word
    addiu $t3, $t3, 1           # Check next byte in word
    j search 
    
    mismatch:
    addiu $s0, $s0, 1
    la $s1, word
    li $t3 , 0
    j search                                     # Repeat loop
    find_code:
    addu $s7 , $s7 , 1
    addiu $s2,$s2,1
    addiu $s0, $s0, 1
    la $s1, word
    li $t3 , 0
    j search
    

match:
    addiu $s0, $s0, 1
    lb $t1, ($s0)  
    la $s1, word
    beq $t2 , $t4 , for_code
    bne $t1, '/', search
    for_code:
    la $t8 , codes
    la $t7 , code
    mul $s7 ,$s7 , 7
    li $t6 , 0
    li $t5 , 6
    li $t4 , 6
    addu $t8 , $t8,$s7
loop_code:
    beq $t6 , $t5 , continue
    lb $t0 , ($t8)
    sb $t0 , ($t7)
    addu $t8 , $t8 , 1
    addu $t7 , $t7 , 1
    addu $t6 , $t6 , 1
    
    j loop_code
    
    
continue: 
    la $t1 , newline
    lb $t0 , ($t1)
    sb $t0 , ($t7)
    

    li $v0, 4         # Print "Word found at index x."
    la $a0, code
    move $a1, $t0     # Move index to $a1 for printing
    syscall
    li $s7, 0
    
    li $a1,6
    la $a2 ,code
    li $t0 , 0 
    j compress_code
    back:
    jr $ra
compress_code:
   beq $a1 ,$t0 , addline
   lb $t1 , ($a2)
   sb $t1 ,($v1)
   
   addu  $t0 ,$t0 , 1
   addu  $a2 ,$a2 , 1
   addu  $v1 ,$v1 , 1
   j compress_code
addline:
la $t1 , newline
lb $t2 , ($t1)
sb $t2 , ($v1)
addu  $v1 ,$v1 , 1
j back
not_match:
    la $s0, Buffer2    # Load address of buffer into $s0
    la $s1, word      # Load address of word into $s14
    find_end_of_dictionary:
    lb $t0 , ($s0)
    beq $t0 , '\0' , add_word_to_dic
    addu $s0 , $s0 , 1
    j find_end_of_dictionary
    add_word_to_dic:
    lb $t0 , ($s1)
    beq $t0 , '\0' , end_word
    sb $t0 ,($s0) 
    addu $s1,$s1,1
    addu $s0,$s0,1
    j add_word_to_dic
    end_word:
    la $t1,slash
    lb $t0 , ($t1)
    sb $t0 ,($s0)
   
     subu $s7 ,$s7 , 1
    
     j for_code
    
end_of_file:
    la $s0, Buffer2    # Load address of buffer into $s0
    la $s1, word      # Load address of word into $s1
    li $s2 , 0
    li $t3 , 0
    li $t4, 0x00
    #jal search
    jal clear_buffer

#Exit  
    j End_Programe_c 
       
       
Decompression1: #*******************************************************************************************

#asks the user to enter the path of the file to be decompressed

        li   $v0,4 				    # code call print string 
  	la   $a0, Six  	 		           # message to choose
 	syscall 

#Getting user 's input text
	li   $v0,8  				    # tell the system to prepare to get text
	la   $a0,DecompFile                          # store the input			
	li   $a1,80				    # tell the system the maximum length 80 char
	syscall 

#remove \n from file name
	li $s0,0			# Set index to 0
	removeW1D:
	lb $a3,DecompFile($s0)		# Load character at index
	addi $s0,$s0,1			# Increment index
	bnez $a3,removeW1D		# Loop until the end of string is reached
	subiu $s0,$s0,2			# If above not true, Backtrack index to '\n'
	sb $0, DecompFile($s0)		# Add the terminating character in its place
		
##Open file to read and store						
        li   $v0,13           	                    # open_file syscall code = 13
    	la   $a0,DecompFile    	                    # get the file name
    	li   $a1,0           	                    # file flag = read (0)
    	syscall
    	move $s0,$v0        	                    # save the file descriptor. $s0 = file
		
#read the file
	li   $v0, 14		                    # read_file syscall code = 14
	move $a0,$s0		                    # file descriptor
	la   $a1,DecompressedData  	                    # The buffer that holds the string of the Whole file
	la   $a2,1024		                    # hardcoded buffer length
	syscall	
	
#Close the file
    	li   $v0, 16         		            # close_file syscall code
    	move $a0,$s0      		            # file descriptor to close
    	syscall	        

        li   $v0,4 				    # code call print string 
  	la   $a0, DecompressedData 	 		           # message to choose
 	syscall
 	
        
#print new line
     new_line

#search
        la $v1 , words
       
   addu $s7 , $zero , 0	
   la $s4 , DecompressedData 
   la $s3 , code    
   move_code_to_buffer:
   lb $t1, ($s4)     # Load byte from buffer into $t1
   beq $t1 , '\n',new_code
   beq $t1 , '\0',end_of_filed
   sb $t1, ($s3)
   addiu $s3, $s3, 1
   addiu $s4, $s4, 1
   j move_code_to_buffer
   
   
   new_code:
   la $s3 , code
    la $s0, codes     # Load address of buffer into $s0
    la $s1, code     # Load address of word into $s1
    li $s2 , 0
    li $t3 , 0
    la $t0,null
    lb $t4, ($t0)
    jal searchd
    for_word:
    jal clear_bufferd
    jal clear_word
    addiu $s4, $s4, 1
    j move_code_to_buffer
    
    clear_bufferd :
   la $s3 , code	  
   la $a0, code  # Load buffer address
    li $a1, 0         # Set value 0
    li $t0, 7       # Set buffer size
    
    clear_loopd:
    sb $a1, ($a0)     # Store zero in the buffer byte
    addiu $a0, $a0, 1 # Increment buffer address
    addiu $t0, $t0, -1  # Decrement buffer size
    bnez $t0, clear_loopd  # Branch if buffer size is not zero  
    li $a0 , 0
    jr $ra
    
    clear_word:	  
   la $a0, word # Load buffer address
    li $a1, 0         # Set value 0
    li $t0, 60       # Set buffer size
    
    clear_loopw:
    sb $a1, ($a0)     # Store zero in the buffer byte
    addiu $a0, $a0, 1 # Increment buffer address
    addiu $t0, $t0, -1  # Decrement buffer size
    bnez $t0, clear_loopw # Branch if buffer size is not zero  
    li $a0 , 0
    jr $ra


searchd:

    lb $t1, ($s0)     # Load byte from buffer into $t1
    lb $t2, ($s1)     # Load byte from word into $t2    
    beq $t3,6 ,matchd
    beq $t1,$t4 , not_matchd
    beq $t1, '/', find_word # End of buffer reached, word not found
    bne $t1, $t2, mismatchd
    addiu $s0, $s0, 1           # Bytes match, check next byte in buffer
    addiu $s1, $s1, 1           # Check next byte in word
    addiu $t3, $t3, 1           # Check next byte in word
    j searchd 
    
    mismatchd:
    addiu $s0, $s0, 1
    la $s1, code
    li $t3 , 0
    j searchd                                     # Repeat loop
    find_word:
    addu $s7 , $s7 , 1
    addiu $s2,$s2,1
    addiu $s0, $s0, 1
    la $s1, code
    li $t3 , 0
    j searchd
    

matchd:

    la $t7 , word
    la $a0 ,Buffer2 
    li $s6 , 0
    take_word:
    lb $t0 , ($a0)
    beq $t0 ,'/' , add_one
    beq $s6 , $s7 , save_word
    addu $a0 , $a0 ,1
    j take_word
    add_one:
    addu $s6 , $s6 , 1
    bgt  $s6, $s7, continued1
    addu $a0 , $a0 ,1
    j take_word
    save_word: 
    sb $t0 , ($t7)
    addu $t7 , $t7 ,1
    addu $a0 , $a0 ,1
    j take_word

    
    
continued1: 

    li $v0, 4         # Print "Word found at index x."
    la $a0, word
    move $a1, $t0     # Move index to $a1 for printing
    syscall
    li $s7, 0
    
    la $a2 ,word
    li $t0 , 0 
    j compress_word
    back1:
    jr $ra
compress_word:
   lb $t1 , ($a2)
   beq $t1 ,'\0' , newd
   beq $t1 ,'\r' , newd
   sb $t1 ,($v1)
   addu  $a2 ,$a2 , 1
   addu  $v1 ,$v1 , 1
   j compress_word
newd:
j back1
not_matchd:
 li   $v0,4 				    # code call print string 
  	la   $a0, NotExist 	 		           # message to choose
 	syscall  
 	j for_word 
    
end_of_filed:
   la $s0, codes     # Load address of buffer into $s0
    la $s1, code     # Load address of word into $s1
    li $s2 , 0
    li $t3 , 0
    la $t0,null
    lb $t4, ($t0)
    jal searchd
    jal clear_bufferd
    jal clear_word



#Exit  
    j End_Programe_d

#------------------------------------------------------------------------------------------------

Creat_dictionary:#***************************************************
     
Fourr:
#asks the user whether he or she wants to do compression or decompression
      	li   $v0,4 				    # code call print string 
  	la   $a0, Four  	 		           # message to choose
 	syscall
   	new_line     
          
            
#Getting user 's input text
	li   $v0,8  				    # tell the system to prepare to get text
	la   $a0,Chooseuser4                         # store the y or n 				
	li   $a1,80				    # tell the system the maximum length 80 char
	syscall 

#To make The options case-insensitive             
toLowerCase4:

	lb   $t2, Chooseuser4                  # $t2 = content of the plain file loaded byte by byte 
	blt  $t2, 'A', case4                       # if the character less than A or greater than Z then ignore it
	bgt  $t2, 'Z', case4
	add  $t2, $t2, 32                            # else it will be converted to lower case by add 32 to it
	sb   $t2, Chooseuser4                                      # store the bytes in t2

case4:
       sb   $t2, Chooseuser4

	lb   $t1,0($a0)                             # t1 = user 's input 	      
        lb   $s1,char3                             # char= c
        lb   $s2,char4                              # char=  d
        lb   $s3,char5                              #char=q
        
        beq  $t1,$s1,Compression                   # if user input = c
        beq  $t1,$s2,Decompression 	            # if user input = d
        beq  $t1,$s3,End_Programe                 # if user input = q
     
        la   $a0,WrongKeyword
        li   $v0,4
        syscall

        j Fourr   
          
#------------------------------------------------------------------------------------------------                  

Compression:
j Compression1
       
#------------------------------------------------------------------------------------------------------------------------------------------------                  

Decompression: 

#asks the user to enter the path of the file to be decompressed

        li   $v0,4 				    # code call print string 
  	la   $a0, dictionaryNotExist  	 	    # message to choose
 	syscall
   		

#------------------------------------------------------------------------------------------------------------------------------------------------                  

# exit from the program

End_Programe_c:
        # Open the file
        
    li $v0,4                 		    # code call print string message 
   	la $a0, Buffer2 		  		    # message print names
   	syscall	
   	    
    li $v0, 13                       # System call number for open
    la $a0, CompressedFile        # Load the file descriptor into $a0
    li $a1, 1                        # Open for write-only
    li $a2, 0                        # Default permission
    syscall

    move $s0, $v0                    # Save the file descriptor in $s0

    # Write the string to the file
    li $v0, 15
    move $a0, $s0                 # Load address of the string
    la $a1, codes1                    # Length of the string                    # System call number for write
    li $a2, 2000                   # Move the file descriptor to $a2
    syscall

    # Close the file
    li $v0, 16                       # System call number for close
    move $a0, $s0                    # Move the file descriptor to $a0
    syscall

        li   $v0, 10		
        syscall	

End_Programe_d:
    
    li $v0, 13                       # System call number for open
    la $a0, DecompressedFile         # Load the file descriptor into $a0
    li $a1, 1                        # Open for write-only
    li $a2, 0                        # Default permission
    syscall

    move $s0, $v0                    # Save the file descriptor in $s0

    # Write the string to the file
    li $v0, 15
    move $a0, $s0                 # Load address of the string
    la $a1, words                   # Length of the string                    # System call number for write
    li $a2, 2000                   # Move the file descriptor to $a2
    syscall

    # Close the file
    li $v0, 16                       # System call number for close
    move $a0, $s0                    # Move the file descriptor to $a0
    syscall
 
        li   $v0, 10		
        syscall	
End_Programe:
        # Open the file
    li $v0, 13                       # System call number for open
    la $a0, CompressedFile        # Load the file descriptor into $a0
    li $a1, 1                        # Open for write-only
    li $a2, 0                        # Default permission
    syscall
