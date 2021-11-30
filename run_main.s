    #318528171 Itay Shwartz
.section    .rodata

format_char:            .string     " %c"
format_str:             .string     " %s"
format_int:             .string     " %d"
pstrlen_sentence:       .string     "first pstring length: %d, second pstring length: %d\n"
replaceChar_sentence:   .string     "old char: %c, new char: %c, first string: %s, second string: %s\n"
pstrijcpy_sentence:     .string     "length: %d, string: %s\n"
swapCase_sentence:      .string     "length: %d, string: %s\n"
pstrijcmp_sentence:     .string     "compare result: %d\n"
invalid_input_sentence: .string     "invalid input!\n"
default_sentence:       .string     "invalid option!\n"

#jump table:
.align 8                                    # align address to multiple of 8
.JUMP_TABLE:
    .quad .L_pstrlen                        # case 50
    .quad .L_default                        # case 51
    .quad .L_replaceChar                    # case 52
    .quad .L_pstrijcpy                      # case 53
    .quad .L_swapCase                       # case 54
    .quad .L_pstrijcmp                      # case 55
    .quad .L_default                        # case 56
    .quad .L_default                        # case 57
    .quad .L_default                        # case 58
    .quad .L_default                        # case 59
    .quad .L_pstrlen                        # case 60
    .quad .L_default                        # default

.text
.globl pstrlen
.type pstrlen, @function
pstrlen:
    pushq   %rbp                            # prepere the scope to this function
    movq    %rsp, %rbp
    
    xorq    %rax, %rax                      # we make sure that %rax is 0
    movb    (%rdi), %al                     # return the size of 
    
    movq    %rbp, %rsp                      # return #rsp to the start of the frame
    pop     %rbp                            # retun the %rbp to the address that he was before
    ret
    
.globl replaceChar
.type replaceChar, @function
# get *pstring %rdi, char1 (old) is in %rsi, char2 (new) in %rdx
replaceChar:  
    pushq   %rbp                            # prepere the scope to this function
    movq    %rsp, %rbp
    movq    %rdi, %rcx                      # save the first address of %rdi in %rcx

.loop_replaceChar: 
    incq    %rdi                            # now we point to the start of the string
    cmpb    $0, (%rdi)                      # compare if we reach to the rnd of the string
    je      .finish_replaceChar             # if so we jump outside the loop and return
    cmpb    %sil, (%rdi)                    # we check if the char in the string is equal to char1
    jne     .loop_replaceChar               # if not we continue in the loop
    movb    %dl, (%rdi)                     # if yes, we move the char to the location in the string
    jmp     .loop_replaceChar               # we continue in the loop
    
.finish_replaceChar:
    movq    %rcx, %rax
    movq    %rbp, %rsp                      # return #rsp to the start of the frame
    pop     %rbp                            # retun the %rbp to the address that he was before
    ret
  
  
.globl  pstrijcpy
.type   pstrijcpy, @function
# dest - pstring1 in %rdi, src - pstring2 in %rsi, i - in %rdx, j - %rcx
pstrijcpy:
    pushq   %rbp                            # prepere the scope to this function
    movq    %rsp, %rbp                  
    pushq   %rdi                            # save *pstring1 in the stack
    
    movzbq  (%rdi), %r8                     # we get the size of pstring1 to %r8
    movzbq  (%rsi), %r9                     # we get the size of pstring2 to %r9
    
    # checking if the arguments are valid
    cmpq    %rdx, %rcx                      # we check that i <= j
    jl      .print_error_pstrijcpy  
    cmpq    %r8, %rdx                       # we check if i is bigger then the length of string1
    jge      .print_error_pstrijcpy  
    cmpq    %r9, %rdx                       # we check if i is bigger then the length of string2
    jge      .print_error_pstrijcpy  
    cmpq    %r8, %rcx                       # we check if j is bigger then the length of string1
    jge      .print_error_pstrijcpy  
    cmpq    %r9, %rcx                       # we check if j is bigger then the length of string2
    jge      .print_error_pstrijcpy  
    cmpq    $0, %rdx                        # we check of i is smaller than 0
    jl       .print_error_pstrijcpy  
    cmpq    $0, %rcx                        # we check of j is smaller than 0
    jl       .print_error_pstrijcpy  

    leaq    1(%rdi, %rdx), %rdi             # go to pstring1[i] (add 1 to skip the length of the pstring1)
    leaq    1(%rsi, %rdx), %rsi             # go to pstring2[i] (add 1 to skip the length of the pstring2)
    
    # loop to copy pstring1[i] to pstring2[i] while i<=j
.while_loop_pstrijcpy:  
    movb    (%rsi), %r11b                   # take pstring2[i] to %r11b
    movb    %r11b, (%rdi)                   # put in the value to pstring1[i]
    
    inc     %rdi                            # increase the point to pstring1
    inc     %rsi                            # increase the point to pstring2
    inc     %rdx                            # increase i
    
    cmpq    %rdx, %rcx                      # we continue the loop while i <= j
    jge     .while_loop_pstrijcpy 
    
    pop     %rax                            # move the result from the stack to the return value
    movq    %rbp, %rsp                      # return #rsp to the start of the frame
    pop     %rbp                            # retun the %rbp to the address that he was before
    ret
    
.print_error_pstrijcpy:
    movq    $invalid_input_sentence, %rdi   # give the format to print to %rdi
    xorq    %rax, %rax                      # make %rax to 0
    call    printf
    pop     %rax                            # move the result to the return value
    movq    %rbp, %rsp                      # return #rsp to the start of the frame
    pop     %rbp                            # retun the %rbp to the address that he was before
    ret
    
.globl  swapCase
.type   swapCase, @function
# get *pstring in %rdi
swapCase:
    pushq   %rbp                            # prepere the scope to this function
    movq    %rsp, %rbp  
    
    leaq    (%rdi), %r8                     # save pointer to the start of the pstring
    
.while_loop_swapCase:
    inc     %rdi                            # in the first time we skip on the len. next we move to the next char
    cmpb    $0, (%rdi)                      # we looping until we reach to the end of the string - to '\0'
    je      .finish_swapCase                # if so we finish the function
    
    # checking if is big char
    cmpb    $65, (%rdi)                     # check if the char is smaller then 'A' = 65
    jl      .while_loop_swapCase            # if is 
    cmpb    $90, (%rdi)                     # check if the char is bigger then 'Z' = 90
    jle     .change_big_char_to_small_char  # if the char is between 65 to 90 - we change it to small
    
    # checking if is small char
    cmpb    $97, (%rdi)                     # check if the char is smaller then 'a' = 97
    jl      .while_loop_swapCase
    cmpb    $122, (%rdi)                    # check if the char is bigger then 'z' = 122
    jle     .change_small_char_to_big_char  # if the char is between 97 to 122 - we change it to big
    
    jmp     .while_loop_swapCase            # if we reach here then the char is not in the correct value to letters, so we continue with the loop
    
.change_big_char_to_small_char:  
    add     $32, (%rdi)                     # to covert big char to small we need to add 32
    jmp     .while_loop_swapCase            # return to continue the loop

.change_small_char_to_big_char:
    sub     $32, (%rdi)                     # to covert big char to small we need to sub 32
    jmp     .while_loop_swapCase            # return to continue the loop

.finish_swapCase:
    leaq    (%r8), %rax                     # in %r8 there is pointer to the start of the pstring. so we return it
    movq    %rbp, %rsp                      # return #rsp to the start of the frame
    pop     %rbp                            # retun the %rbp to the address that he was before
    ret
    
.globl  pstrijcmp
.type   pstrijcmp, @function
# pstring1 in %rdi, pstring2 in %rsi, i - in %rdx, j - %rcx
pstrijcmp:
    pushq   %rbp                            # prepere the scope to this function
    movq    %rsp, %rbp      
    
    movzbq  (%rdi), %r8                     # we get the size of pstring1 to %r8
    movzbq  (%rsi), %r9                     # we get the size of pstring2 to %r9
    
    # checking if the arguments are valid
    cmpq    %rdx, %rcx                      # we check that i <= j
    jl      .print_error_pstrijcmp  
    cmpq    %r8, %rcx                       # we check if i is bigger then the length of string1
    jge      .print_error_pstrijcmp  
    cmpq    %r9, %rcx                       # we check if i is bigger then the length of string2
    jge      .print_error_pstrijcmp  
    cmpq    %r8, %rdx                       # we check if j is bigger then the length of string1
    jge      .print_error_pstrijcmp  
    cmpq    %r9, %rdx                       # we check if j is bigger then the length of string2
    jge      .print_error_pstrijcmp  
    cmpq    $0, %rcx                        # we check of i is smaller than 0
    jl      .print_error_pstrijcmp  
    cmpq    $0, %rdx                        # we check of j is smaller than 0
    jl      .print_error_pstrijcmp  
    
    leaq    (%rdi, %rdx), %rdi              # go to pstring1[i-1]
    leaq    (%rsi, %rdx), %rsi              # go to pstring2[i-1]
    
    xorq    %rax, %rax                      # we make %rax 0 - its the defoult result. if there is some changes - we change it
    movl    $1, %r8d                        # we put the result 1 in %r8d
    movl    $-1, %r9d                       # we put the result -1 in %r9d
    
    # looping on the strings while i <=j
.while_loop_pstrijcmp:
    cmpq    %rdx,   %rcx                    # we check if i > j. if so we go to .finish_pstrijcmp
    jl      .finish_pstrijcmp
    incq    %rdi                            # increase pstring1 and pstring2 to fo to the next char
    incq    %rsi
    incq    %rdx                            # increase i by 1
    movzbq  (%rdi), %r10                    # get pstring1[i] to %r10d
    cmpb    (%rsi), %r10b                   # compare between pstring1[i] to pstring2[i]
    je      .while_loop_pstrijcmp           # if thier equal - we continue the loop
    cmovg   %r8, %rax                       # if i > j we put 1 in the result
    cmovl   %r9, %rax                       # if i < j we put -1 in the result

.finish_pstrijcmp:
    movq    %rbp, %rsp                      # return #rsp to the start of the frame
    pop     %rbp                            # retun the %rbp to the address that he was before
    ret
    
.print_error_pstrijcmp:
    movq    $invalid_input_sentence, %rdi   # give the format to print to %rdi
    xorq    %rax, %rax                      # make %rax to 0
    call    printf
    movq    $-2, %rax                       # if we reach here - i or j invalid - so we return -2
    movq    %rbp, %rsp                      # return #rsp to the start of the frame
    pop     %rbp                            # retun the %rbp to the address that he was before
    ret
    

.globl run_func
.type run_func, @function
run_func:
    subq    $50, %rdx                       # we arrange the input so that for 52 for example we get 2
    cmpq    $10, %rdx                       # we check if the choice is outside the range
    ja      .L_default                      # if it outside the range we jump to default
    jmp     *.JUMP_TABLE(,%rdx,8)           # else we go to the jump tanle and jump to the relevant label
.finished:                                  # we return from the function                                                         
    ret
    
    
.L_pstrlen:
    call    pstrlen                         # calculate the len of pstring 1
    movq    %rax, %r8                       # savfirste the size of pstring1 in %r8
    movq    %rsi, %rdi                      # swap that now %rdi point to pstring2
    call    pstrlen                         # calculate the len of pstring 2
    movq    %rax, %r9                       # save the size of pstring2 in %r9
    
    #printing
    movq    $pstrlen_sentence, %rdi         # we put the format in the first argument (%rdi) for printing
    movq    %r8, %rsi                       # we put the size of pstring1 in the second argument (%rdi) for printing
    movq    %r9, %rdx                       # we put the size of pstring2 in the third argument (%rdx) for printing
    xorq    %rax, %rax                      # make %rax 0
    call    printf                          # print
    jmp     .finished
    
    
.L_replaceChar:
    push    %rbp                            # save %rbp       
    movq    %rsp, %rbp                      # bring rbp to the start of this frame
    pushq   %r13
    pushq   %r12
    sub     $16, %rsp                       # make space to the letters that we scan in the stack
    
    leaq    (%rdi), %r12                    # save the pointer to pstring1 in %r12
    leaq    (%rsi), %r13                    # save the pointer to pstring2 in %r13
    
    #get the first letter 
    movq    $format_char, %rdi              # give the format to scanf on first argument
    leaq    -32(%rbp), %rsi                 # give to scanf the adreess thet he save in the letter
    xorq    %rax, %rax                      # put 0 in %rax
    call    scanf
    
    #get the second letter 
    movq     $format_char, %rdi             # give the format to scanf on first argument
    leaq    -24(%rbp), %rsi                 # give to scanf the adreess thet he save in the letter
    xorq    %rax, %rax                      # put 0 in %rax
    call    scanf
    
    #preper the argument to the first call
    leaq      (%r12), %rdi                  # the first argument to replaceChar is *pstring1
    movzbq    -32(%rbp), %rsi               # the second is the first letter
    movzbq    -24(%rbp), %rdx               # the third is the second letter
    call replaceChar                        # call replaceChar
    
    #preper the argument to the second call
    leaq    (%r13), %rdi                    # the first argument to replaceChar is *pstring2
    movzbq  -32(%rbp), %rsi                 # the second is the first letter
    movzbq  -24(%rbp), %rdx                 # the third is the second letter
    call    replaceChar                     # call replaceChar
    
    #printing
    movq    $replaceChar_sentence, %rdi     # the format to print
    movzbq  -32(%rbp), %rsi                 # first letter
    movzbq  -24(%rbp), %rdx                 # second letter
    
    incq    %r12                            # increase *pstring1 to point to the start of the string1
    incq    %r13                            # increase *pstring2 to point to the start of the string2
    
    movq    %r12, %rcx                      # move *pstring1 to third argumrnt
    movq    %r13, %r8                       # move *pstring2 to fourth argumrnt
    
    xorq    %rax, %rax                      # put 0 in %rax
    call    printf

    addq    $16, %rsp                       # return the %rsp to the start of the frame
    pop     %r12                            # return the value of %r12, %rcx to the value that 
    pop     %r13
    xorq    %rax, %rax                      # put 0 in %rax - the return value
    movq    %rbp, %rsp                      # return #rsp to the start of the frame
    pop     %rbp                            # retun the %rbp to the address that he was before
    jmp     .finished



.L_pstrijcpy:
    push    %rbp                            # save %rbp       
    movq    %rsp, %rbp                      # bring rbp to the start of this frame
    pushq   %r13
    pushq   %r12
    sub     $16, %rsp                       # make space to the letters that we scan in the stack
    
    leaq    (%rdi), %r12                    # save the pointer to pstring1 in %r12
    leaq    (%rsi), %r13                    # save the pointer to pstring2 in %r13
    
    # get the first number
    movq    $format_int, %rdi               # give the format to scanf
    leaq    -16(%rbp), %rsi                 # the address to save the data from scanf
    xorq    %rax, %rax                      # make %rax 0
    call    scanf
    
    # get the second number
    movq    $format_int, %rdi               # give the format to scanf
    leaq    -8(%rbp), %rsi                  # the address to save the data from scanf
    xorq    %rax, %rax                      # make %rax 0
    call    scanf    
    
    leaq    (%r12), %rdi                    # give *pstrign1 as the first argument to pstrijcpy
    leaq    (%r13), %rsi                    # give *pstrign2 as the second argument to pstrijcpy
    movl    -16(%rbp), %edx                 # the first number to pstrijcpy as third argument
    movl    -8(%rbp), %ecx                  # the second number to pstrijcpy as fourth argument
    call    pstrijcpy                       # call the function 
    movq    %rax, %r10                      # take the pointer to the new pstring from %rax
    
    # print the new pstring1
    movq    $pstrijcpy_sentence, %rdi       # give to printf the format to print
    xorq    %rsi, %rsi                      # make sure that %rsi is 0
    movb    (%r10), %sil                    # thake thhe length of the pstring to %rsi 
    leaq    1(%r10),%rdx                    # give the address to %rdx, but jump 1 address to get the string (skip on the length)
    xorq    %rax, %rax                      # make %rax 0
    call    printf                          # print the data
    
    # print pstring2
    movq    $pstrijcpy_sentence, %rdi       # give to printf the format to print
    xorq    %rsi, %rsi                      # make sure that %rsi is 0
    movb    (%r13), %sil                    # thake thhe length of the pstring to %rsi 
    leaq    1(%r13),%rdx                    # give the address to %rdx, but jump 1 address to get the string (skip on the length)
    xorq    %rax, %rax                      # make %rax 0
    call    printf                          # print the data
       
    addq    $16, %rsp                       # return the %rsp to the start of the frame
    pop     %r12                            # return the value of %r12, %rcx to the value that 
    pop     %r13
    xorq    %rax, %rax                      # put 0 in %rax - the return value
    movq    %rbp, %rsp                      # return #rsp to the start of the frame
    pop     %rbp                            # retun the %rbp to the address that he was before
    jmp     .finished
    
.L_swapCase:
    pushq    %rbp                           # save %rbp       
    movq    %rsp, %rbp                      # bring rbp to the start of this frame
    
    push    %rsi                            # save the second argument in the stack
    call    swapCase                        # we call swapCase when *pstring1 in %rdi
    movq    $swapCase_sentence, %rdi        # give the format for printing
    xorq    %rsi, %rsi                      # make %rsi 0
    movb    (%rax), %sil                    # put the len in %sil
    leaq    1(%rax), %rdx                   # point to the stat of the string of pstring1
    xorq    %rax, %rax                      # make %rax 0
    call    printf                          # print
    
    popq     %rdi                           # pop *pstring2 to %rdi - the first argument to swapCase
    call    swapCase                        # we call swapCase when *pstring2 in %rdi 
    movq    $swapCase_sentence, %rdi        # give the format for printing
    xorq    %rsi, %rsi                      # make %rsi 0
    movb    (%rax), %sil                    # put the len in %sil
    leaq    1(%rax), %rdx                   # point to the stat of the string of pstring2
    xorq    %rax, %rax                      # make %rax 0
    call    printf                          # print
    
    movq    %rbp, %rsp                      # return #rsp to the start of the frame
    pop     %rbp                            # retun the %rbp to the address that he was before
    jmp     .finished

.L_pstrijcmp:
    pushq   %rbp                            # save %rbp       
    movq    %rsp, %rbp                      # bring rbp to the start of this frame
    subq    $16, %rsp                       # make space to two int in the stack
    push    %rdi                            # save the second argument in the stack
    push    %rsi                            # save the second argument in the stack
    
    # get the first number
    movq    $format_int, %rdi               # give the format to scanf
    leaq    -16(%rbp), %rsi                 # the address to save the data from scanf
    xorq    %rax, %rax                      # make %rax 0
    call    scanf
    
    # get the second number
    movq    $format_int, %rdi               # give the format to scanf
    leaq    -8(%rbp), %rsi                  # the address to save the data from scanf
    xorq    %rax, %rax                      # make %rax 0
    call    scanf
    
    popq    %rsi
    popq    %rdi
    movl    -16(%rbp), %edx                 # the first number to pstrijcpy as third argument
    movl    -8(%rbp), %ecx                  # the second number to pstrijcpy as fourth argument
   
    call    pstrijcmp
    movq    $pstrijcmp_sentence, %rdi       # give the format to printing
    movq    %rax, %rsi                      # take the result that came out from pstrijcmp to %rsi
    xorq    %rax, %rax                      # make %rax 0
    call    printf                          # print

    movq    %rbp, %rsp                      # return #rsp to the start of the frame
    pop     %rbp                            # retun the %rbp to the address that he was before
    jmp     .finished

.L_default:
    movq    $default_sentence, %rdi         # give the format to print to %rdi
    xorq    %rax, %rax                      # make %rax to 0
    call    printf
    jmp     .finished                       # return to the finish of the function



.globl  main
.type   main,   @function 
main:
    #setup the function
    movq    %rsp, %rbp 
    push    %rbp           
    movq    %rsp, %rbp 
    subq    $528, %rsp                      # we make space for all the data that we can get
    
    #get n1
    movq    $format_int, %rdi               # we give to %rdi the formar of the scanning
    leaq    -528(%rbp), %rsi                # we give to %rsi the addres to save the data in the stack         
    xorq    %rax, %rax                      # make %rax to 0
    call    scanf

    #get s1
    movq    $format_str, %rdi               # we give to %rdi the formar of the scanning
    leaq    -527(%rbp), %rsi                # we give to %rsi the addres to save the data in the stack         
    xorq    %rax, %rax                      # make %rax to 0
    call    scanf
    
    #put '\0' in the end of s1
    xorq    %rcx, %rcx                      # put 0 in %rcx
    movb    -528(%rbp), %cl                 # take n1 to %cl
    leaq    -527(%rbp, %rcx), %rcx          # add the the start address of s1 to n1 - we get the end address of the string
    movb    $0, (%rcx)

    #get n2
    movq    $format_int, %rdi               # we give to %rdi the formar of the scanning
    leaq    -271(%rbp), %rsi                # we give to %rsi the addres to save the data in the stack         
    xorq    %rax, %rax                      # make %rax to 0
    call    scanf
    
    #get s2
    movq    $format_str, %rdi               # we give to %rdi the formar of the scanning
    leaq    -270(%rbp), %rsi                # we give to %rsi the addres to save the data in the stack         
    xorq    %rax, %rax                      # make %rax to 0
    call    scanf
    
    #put '\0' in the end of s1
    xorq    %rcx, %rcx                      # put 0 in %rcx
    movb    -271(%rbp), %cl                 # take n1 to %cl
    leaq    -270(%rbp, %rcx), %rcx          # add the the start address of s1 to n1 - we get the end address of the string
    movb    $0, (%rcx)

    #get the choice
    movq    $format_int, %rdi               # we give to %rdi the formar of the scanning
    leaq    -8(%rbp), %rsi                  # we give to %rsi the addres to save the data in the stack         
    xorq    %rax, %rax                      # make %rax to 0
    call    scanf   
    
    #prepere the argument to func_run
    xorq %rdx, %rdx
    movb -8(%rbp), %dl                      # %rdx = choice
    leaq -528(%rbp), %rdi                   # %rdi = pstring1
    leaq -271(%rbp), %rsi                   # %rsi = pstring2
    call run_func
    
    xorq    %rax, %rax                      # make %rax to 0 before the return
    movq    %rbp, %rsp
    pop     %rbp
    ret
