#318528171 Itay Shwartz
.section    .rodata
format_char:  .string   " %c"
format_str:   .string   " %s"
format_int:   .string   " %d"

#jump table:
.align 8        #align address to multiple of 8

.JUMP_TABLE:
    .quad .pstrlen      #case 50
    .quad .default      #case 51
    .quad .replaceChar  #case 52
    .quad .pstrijcpy    #case 53
    .quad .swapCase     #case 54
    .quad .pstrijcmp    #case 55
    .quad .default      #case 56
    .quad .default      #case 57
    .quad .default      #case 58
    .quad .default      #case 59
    .quad .pstrlen      #case 60
    .quad .default      #default

.text


.globl run_func
.type run_func, @function
run_func:
    #setup the function
    movq    %rsp, %rbp 
    push    %rbp   
     
    subq    $50, %rdx
    cmpq    $10, %rdx
    ja .default
    jmp *.JUMP_TABLE(,%rdx,8)
    
.finished:                                                         
    movq    %rbp, %rsp
    pop     %rbp
    ret
    
.pstrlen:
    movq %rdi, %rsi
    .finished
.replaceChar:
    movq %rdi, %rsi
    .finished

.pstrijcpy:
    movq %rdi, %rsi
    .finished
    
.swapCase:
    movq %rdi, %rsi
    .finished

.pstrijcmp:
    movq %rdi, %rsi
    .finished

.default:
    movq %rdi, %rsi
    .finished



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
