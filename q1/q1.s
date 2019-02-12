				AREA question1, CODE, READWRITE
				ENTRY										;program that will copy a string, after removing all occurences of the word "the" from it. Preserves spaces and null char. 
				
				LDR	r0, =STRING1							;makes r0 point to STRING1 - this will allow us to read the null terminated string		
				LDR	r1, =STRING2							;makes r1 point	to STRING2 - this will allow us to write to the string. will be null terminated

															;THECHECK checks for the existence of the string "the". Put before LOOP to handle the case that the string starts with "the"
THECHECK		LDRB r5, [r0]								;loads char at current index into r5
				CMP r5,#0x74								;Check if char is 't'
				BNE LOOP									;if its not, continue adding chars as usual
				
				LDRB r5, [r0, #1]							;if char is t, continue checking for existence of "the"
				CMP r5,#0x68								;check if char after t is h
				BNE LOOP									;if its not, go to current index and add chars as usual
				
				LDRB r5, [r0, #2]							;if char is h, continue checking for existence of "the"
				CMP r5,#0x65								;check if char after h is e
				BNE LOOP									;if its not, go to current index and add chars as usual
				
				LDRB r5, [r0, #3]							;if char is e, continue checking for existence of "the"
				CMP r5,#0x20								;check if char after e is space
				ADDEQ r0, #3								;if it is, add 3 to the current index to skip over "the", before going back to adding chars. this also keeps all spaces
				CMP r5,#0x00								;check if char after e is NULL. this handles the case when "the" is at the end of a string
				ADDEQ r0, #3								;if char after e is null, end program without adding "the"
				
				B LOOP										;go back to adding chars. back to original index if "the" wasnt found, or original index + 3 if "the" was found.

															
															;LOOP iterates through string1 and adds the correct chars into string2
LOOP			LDRB r2, [r0], #1 							;puts value that index is pointing to into r2, then increments it by one. This allows us to iterate over the string, one char at a time.
				CMP r2, #0x00								;check if char is null
				STRB r2, [r1], #1							;add char to string2 and increment string2 index. this will add all chars (including null and space), except the word "the". The word the will never be pointed to by r2, bc program skips over it.
				BEQ ENDLOOP									;if null then end of string, end program
				CMP r2, #0x20								;checks if current char is a space
				BEQ THECHECK								;if it is, check for occurance of "the" by checking if char after the space is a t
				BNE LOOP									;if its not, continue adding chars to string2 as usual.

				
ENDLOOP			B ENDLOOP									;end of program
				
				
				AREA question1, DATA, READWRITE
STRING1			DCB "and the man said they must go"			;String1
EoS				DCB	0x00									;end of string1
STRING2			space 0xFF									;just allocating 255 bytes
				END