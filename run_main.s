#318528171 Itay Shwartz






.section    .rodata
format_scanf_char:   .string " %c\n"
format_scanf_str:   .string " %s\n"
format_scanf_int:   .string " %d\n"

.text
.globl main
.type main, @function 
main:
    movq %rsp, %rbp #for correct debugging
    #setup
    push    %rbp           
    movq    %rsp, %rbp 
    subq $528, %rsp
    
    #get n_1
    movq $format_scanf_int, %rdi
    leaq -528(%rbp), %rsi
    xorq %rax, %rax
    call scanf
    #!!!!!!!!!!!!!!!!!!!
    call printf
    #!!!!!!!!!!!!!!!!!!!
    #get s_1
    movq $format_scanf_str, %rdi
    leaq -527(%rbp), %rsi
    xorq %rax, %rax
    call scanf
    #!!!!!!!!!!!!!!!!!!!
    movq $format_scanf_str, %rdi
    leaq -527(%rbp), %rsi
    xorq %rax, %rax
    call printf
    #!!!!!!!!!!!!!!!!!!!
    
    #get n_2
    movq $format_scanf_int, %rdi
    leaq -271(%rbp), %rsi
    xorq %rax, %rax
    call scanf
    #!!!!!!!!!!!!!!!!!!!
    call printf
    #!!!!!!!!!!!!!!!!!!!
    #get s_2
    movq $format_scanf_str, %rdi
    leaq -270(%rbp), %rsi
    xorq %rax, %rax
    call scanf
    #!!!!!!!!!!!!!!!!!!!
    movq $format_scanf_str, %rdi
    leaq -270(%rbp), %rsi
    xorq %rax, %rax
    call printf
    #!!!!!!!!!!!!!!!!!!!
    

    movq    %rbp, %rsp
    pop     %rbp
    ret
      