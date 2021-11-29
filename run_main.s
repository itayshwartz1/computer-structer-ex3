#318528171 Itay Shwartz
.section    .rodata

format_char:            .string     " %c"
format_str:             .string     " %s"
format_int:             .string     " %d"
pstrlen_sentence:       .string     "first pstring length: %d, second pstring length: %d\n"
replaceChar_sentence:   .string     "old char: %c, new char: %c, first string: %s, second string: %s\n"


#jump table:
.align 8                    # align address to multiple of 8
.JUMP_TABLE:
    .quad .L_pstrlen        # case 50
    .quad .L_default        # case 51
    .quad .L_replaceChar    # case 52
    .quad .L_pstrijcpy      # case 53
    .quad .L_swapCase       # case 54
    .quad .L_pstrijcmp      # case 55
    .quad .L_default        # case 56
    .quad .L_default        # case 57
    .quad .L_default        # case 58
    .quad .L_default        # case 59
    .quad .L_pstrlen        # case 60
    .quad .L_default        # default

.text

.globl pstrlen
.type pstrlen, @function
pstrlen:
    xorq    %rax, %rax          # we make sure that %rax is 0
    movb    (%rdi), %al         # return the size of 
    ret
    
.globl replaceChar
.type replaceChar, @function
# get *pstring %rdi, char1 (old) is in %rsi, char2 (new) in %rdx
replaceChar:  
    pushq   %rbp                # prepere the scope to this function
    movq    %rsp, %rbp
    movq    %rdi, %rcx          # save the first address of %rdi in %rcx
    
.loop_replaceChar: 
    incq    %rdi                # now we point to the start of the string
    cmpb    $0, (%rdi)          # compare if we reach to the rnd of the string
    je      .finish_replaceChar # if so we jump outside the loop and return
    cmpb    %sil, (%rdi)        # we check if the char in the string is equal to char1
    jne     .loop_replaceChar   # if not we continue in the loop
    movb    %dl, (%rdi)         # if yes, we move the char to the location in the string
    jmp     .loop_replaceChar   # we continue in the loop
    
.finish_replaceChar:
    movq    %rcx, %rax
    movq    %rbp, %rsp          # return #rsp to the start of the frame
    pop     %rbp                # retun the %rbp to the address that he was before
    ret


.globl run_func
.type run_func, @function
run_func:
    subq    $50, %rdx                   # we arrange the input so that for 52 for example we get 2
    cmpq    $10, %rdx                   # we check if the choice is outside the range
    ja      .L_default                  # if it outside the range we jump to default
    jmp     *.JUMP_TABLE(,%rdx,8)       # else we go to the jump tanle and jump to the relevant label
.finished:                              # we return from the function                                                         
    ret
    
    
.L_pstrlen:
    call    pstrlen                     # calculate the len of pstring 1
    movq    %rax, %r8                   # save the size of pstring1 in %r8
    movq    %rsi, %rdi                  # swap that now %rdi point to pstring2
    call    pstrlen                     # calculate the len of pstring 2
    movq    %rax, %r9                   # save the size of pstring2 in %r9
    
    #printing
    movq $pstrlen_sentence, %rdi        # we put the format in the first argument (%rdi) for printing
    movq %r8, %rsi                      # we put the size of pstring1 in the second argument (%rdi) for printing
    movq %r9, %rdx                      # we put the size of pstring2 in the third argument (%rdx) for printing
    xorq %rax, %rax                     # make %rax 0
    call printf                         # print
    jmp .finished
    
    
.L_replaceChar:
    push    %rbp                        # save %rbp       
    movq    %rsp, %rbp                  # bring rbp to the start of this frame
    pushq   %r13
    pushq   %r12
    sub     $16, %rsp                   # make space to the letters that we scan in the stack
    
    leaq    (%rdi), %r12                # save the pointer to pstring1 in %r12
    leaq    (%rsi), %r13                # save the pointer to pstring2 in %r13
    
    #get the first letter 
    movq    $format_char, %rdi          # give the format to scanf on first argument
    leaq    -32(%rbp), %rsi             # give to scanf the adreess thet he save in the letter
    xorq    %rax, %rax                  # put 0 in %rax
    call    scanf
    
    #get the second letter 
    movq     $format_char, %rdi         # give the format to scanf on first argument
    leaq    -24(%rbp), %rsi              # give to scanf the adreess thet he save in the letter
    xorq    %rax, %rax                  # put 0 in %rax
    call    scanf
    
    #preper the argument to the first call
    leaq      (%r12), %rdi              # the first argument to replaceChar is *pstring1
    movzbq    -32(%rbp), %rsi           # the second is the first letter
    movzbq    -24(%rbp), %rdx            # the third is the second letter
    call replaceChar                    # call replaceChar
    
    #preper the argument to the second call
    leaq      (%r13), %rdi              # the first argument to replaceChar is *pstring2
    movzbq    -32(%rbp), %rsi           # the second is the first letter
    movzbq    -24(%rbp), %rdx            # the third is the second letter
    call replaceChar                    # call replaceChar
    
    #printing
    movq $replaceChar_sentence, %rdi    # the format to print
    movzbq    -32(%rbp), %rsi           # first letter
    movzbq    -24(%rbp), %rdx           # second letter
    
    incq    %r12                        #increase *pstring1 to point to the start of the string1
    incq    %r13                        #increase *pstring2 to point to the start of the string2
    
    movq    %r12, %rcx                  #move *pstring1 to third argumrnt
    movq    %r13, %r8                   #move *pstring2 to fourth argumrnt
    
    xorq    %rax, %rax                  # put 0 in %rax
    call    printf

    addq    $16, %rsp                   # return the %rsp to the start of the frame
    pop     %r12                        # return the value of %r12, %rcx to the value that 
    pop     %r13
    xorq    %rax, %rax                  # put 0 in %rax - the return value
    movq    %rbp, %rsp                  # return #rsp to the start of the frame
    pop     %rbp                        # retun the %rbp to the address that he was before
    jmp .finished



.L_pstrijcpy:
    movq %rdi, %rsi
    jmp .finished
    
.L_swapCase:
    movq %rdi, %rsi
    jmp .finished

.L_pstrijcmp:
    movq %rdi, %rsi
    jmp .finished

.L_default:
    movq %rdi, %rsi
    jmp .finished



.globl  main
.type   main,   @function 
main:
    #setup the function
    movq    %rsp, %rbp 
    push    %rbp           
    movq    %rsp, %rbp 
    subq    $528, %rsp                  # we make space for all the data that we can get
    
    #get n1
    movq    $format_int, %rdi           # we give to %rdi the formar of the scanning
    leaq    -528(%rbp), %rsi            # we give to %rsi the addres to save the data in the stack         
    xorq    %rax, %rax                  # make %rax to 0
    call    scanf

    #get s1
    movq    $format_str, %rdi           # we give to %rdi the formar of the scanning
    leaq    -527(%rbp), %rsi            # we give to %rsi the addres to save the data in the stack         
    xorq    %rax, %rax                  # make %rax to 0
    call    scanf
    
    #put '\0' in the end of s1
    xorq    %rcx, %rcx                  # put 0 in %rcx
    movb    -528(%rbp), %cl             # take n1 to %cl
    leaq    -527(%rbp, %rcx), %rcx      # add the the start address of s1 to n1 - we get the end address of the string
    movb    $0, (%rcx)

    #get n2
    movq    $format_int, %rdi           # we give to %rdi the formar of the scanning
    leaq    -271(%rbp), %rsi            # we give to %rsi the addres to save the data in the stack         
    xorq    %rax, %rax                  # make %rax to 0
    call    scanf
    
    #get s2
    movq    $format_str, %rdi           # we give to %rdi the formar of the scanning
    leaq    -270(%rbp), %rsi            # we give to %rsi the addres to save the data in the stack         
    xorq    %rax, %rax                  # make %rax to 0
    call    scanf
    
    #put '\0' in the end of s1
    xorq    %rcx, %rcx                  # put 0 in %rcx
    movb    -271(%rbp), %cl             # take n1 to %cl
    leaq    -270(%rbp, %rcx), %rcx      # add the the start address of s1 to n1 - we get the end address of the string
    movb    $0, (%rcx)

    #get the choice
    movq    $format_int, %rdi           # we give to %rdi the formar of the scanning
    leaq    -8(%rbp), %rsi              # we give to %rsi the addres to save the data in the stack         
    xorq    %rax, %rax                  # make %rax to 0
    call    scanf   
    
    #prepere the argument to func_run
    xorq %rdx, %rdx
    movb -8(%rbp), %dl                  # %rdx = choice
    leaq -528(%rbp), %rdi               # %rdi = pstring1
    leaq -271(%rbp), %rsi               # %rsi = pstring2
    call run_func
    
    xorq    %rax, %rax                  #make %rax to 0 before the return
    movq    %rbp, %rsp
    pop     %rbp
    ret
