#318528171 Itay Shwartz
.section    .rodata
format_char:  .string   " %c"
format_str:   .string   " %s"
format_int:   .string   " %d"
pstrlen_sentence: .string "first pstring length: %d, second pstring length: %d\n"

#jump table:
.align 8        #align address to multiple of 8

.JUMP_TABLE:
    .quad .L_pstrlen      #case 50
    .quad .L_default      #case 51
    .quad .L_replaceChar  #case 52
    .quad .L_pstrijcpy    #case 53
    .quad .L_swapCase     #case 54
    .quad .L_pstrijcmp    #case 55
    .quad .L_default      #case 56
    .quad .L_default      #case 57
    .quad .L_default      #case 58
    .quad .L_default      #case 59
    .quad .L_pstrlen      #case 60
    .quad .L_default      #default

.text

.globl pstrlen
.type pstrlen, @function
pstrlen:
    xorq    %rax, %rax  #we make sure that %rax is 0
    movb    (%rdi), %al #return the size of 
    ret
    
.globl replaceChar
.type replaceChar, @function
replaceChar:
    xorq %rax, %rax
    ret

  
    



.globl run_func
.type run_func, @function
run_func:
    subq    $50, %rdx                   # we arrange the input so that for 52 for example we get 2
    cmpq    $10, %rdx                   #we check if the choice is outside the range
    ja      .L_default                  #if it outside the range we jump to default
    jmp     *.JUMP_TABLE(,%rdx,8)       #else we go to the jump tanle and jump to the relevant label
    
.finished:                              #we return from the function                                                         
    ret
    
.L_pstrlen:
    call    pstrlen                     #calculate the len of pstring 1
    movq    %rax, %r8                   #save the size of pstring1 in %r8
    movq    %rsi, %rdi                  #swap that now %rdi point to pstring2
    call    pstrlen                     #calculate the len of pstring 2
    movq    %rax, %r9                   #save the size of pstring1 in %r9
    
    #printing
    movq $pstrlen_sentence, %rdi        #we put the format in the first argument (%rdi) for printing
    movq %r8, %rsi                      
    movq %r9, %rdx
    xorq %rax, %rax
    call printf
    ret
    jmp .finished
    
    
.L_replaceChar:
    push    %rbp            #save %rbp       
    movq    %rsp, %rbp      #bring rbp to the start of this frame
    sub     $16, %rsp       #make space to the letters that we scan in the stack
    
    movq    %rdi, %r8       #save the pointer to pstring1 in %r8
    movq    %rdi, %r9       #save the pointer to pstring2 in %r9
    
    #get the first letter 
    movq     $format_char, %rdi #give the format to scanf on first argument
    leaq    -16(%rbp), %rsi     #give to scanf the adreess thet he save in the letter
    xorq    %rax, %rax          #put 0 in %rax
    call    scanf
    
    #get the second letter 
    movq     $format_char, %rdi #give the format to scanf on first argument
    leaq    -8(%rbp), %rsi      #give to scanf the adreess thet he save in the letter
    xorq    %rax, %rax          #put 0 in %rax
    call    scanf
    
    movq      %r8, %rdi         # the first argument to replaceChar is *pstring1
    movzbq    -16(%rbp), %rsi   #the second is the first letter
    movzbq    -8(%rbp), %rdx    #the third is the second letter
    call replaceChar #call replaceChar
    
    popq %r8
    popq %r8
    movq    %rbp, %rsp      #return #rsp to the start of the frame
    pop     %rbp            #retun the %rbp to the address that he was before
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
    subq    $528, %rsp                  #we make space for all the data that we can get
    
    #get n1
    movq    $format_int, %rdi           #we give to %rdi the formar of the scanning
    leaq    -528(%rbp), %rsi            #we give to %rsi the addres to save the data in the stack         
    xorq    %rax, %rax                  #make %rax to 0
    call    scanf

    #get s1
    movq    $format_str, %rdi           #we give to %rdi the formar of the scanning
    leaq    -527(%rbp), %rsi            #we give to %rsi the addres to save the data in the stack         
    xorq    %rax, %rax                  #make %rax to 0
    call    scanf
    
    #put '\0' in the end of s1
    xorq    %rcx, %rcx                  #put 0 in %rcx
    movb    -528(%rbp), %cl             #take n1 to %cl
    leaq    -527(%rbp, %rcx), %rcx      #add the the start address of s1 to n1 - we get the end address of the string
    movb    $0, (%rcx)

    #get n2
    movq    $format_int, %rdi           #we give to %rdi the formar of the scanning
    leaq    -271(%rbp), %rsi            #we give to %rsi the addres to save the data in the stack         
    xorq    %rax, %rax                  #make %rax to 0
    call    scanf
    
    #get s2
    movq    $format_str, %rdi           #we give to %rdi the formar of the scanning
    leaq    -270(%rbp), %rsi            #we give to %rsi the addres to save the data in the stack         
    xorq    %rax, %rax                  #make %rax to 0
    call    scanf
    
    #put '\0' in the end of s1
    xorq    %rcx, %rcx                  #put 0 in %rcx
    movb    -271(%rbp), %cl             #take n1 to %cl
    leaq    -270(%rbp, %rcx), %rcx      #add the the start address of s1 to n1 - we get the end address of the string
    movb    $0, (%rcx)

    #get the choice
    movq    $format_int, %rdi           #we give to %rdi the formar of the scanning
    leaq    -8(%rbp), %rsi              #we give to %rsi the addres to save the data in the stack         
    xorq    %rax, %rax                  #make %rax to 0
    call    scanf   
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  
    #movl -8(%rbp), %r13d
    
    #prepere the argument to func_run
    xorq %rdx, %rdx
    movb -8(%rbp), %dl                 # %rdx = choice
    leaq -528(%rbp), %rdi               # %rdi = pstring1
    leaq -271(%rbp), %rsi               # %rsi = pstring2
    call run_func
    
    xorq    %rax, %rax                  #make %rax to 0 before the return
    movq    %rbp, %rsp
    pop     %rbp
    ret
