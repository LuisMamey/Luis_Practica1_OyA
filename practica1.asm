.text
main:
    auipc s1,0xfc10  		#Direccion de datos para primera torre   
    addi  s2, s1, 0x4       	#Direccion de datos para segunda torre
    addi  s3, s1, 0x8   	#Direccion de datos para tercera torre
    #Copias dinamicas de las direcciones de las torres
    addi  s4, s1, 0x0         
    addi  s5, s1, 0x4    
    addi  s6, s1, 0x8
    addi  s0, zero, 15   	#Numero de discos        
    add   a1,zero,s0    	#Copia el numero de discos en a1 (torre 1)          
    add   t0, zero, s1      	#Guarda el valor de la direccion de datos de la primera torre   
    addi  t1, zero, 1           #t1 se inicializa en 1 (caso base recursion)
    addi  a6,zero,1 		#Se inicializa en 1, ya que se usara por el flujo al inicio
    blt   s0,t1,fin		#Evalua si s0 es menor que 1, si lo es salta a fin porque no hay nada que hacer

for_torre:
    #Se llena la torre origen con el valor de cada disco
    beq   a0, s0, for_torre_final 	#Si a0 es igual a el numero de discos, salta a torre_final
    addi  t2, a0, 1		#Suma a0 mas 1 y guarda en t2 (Numero del disco)  
    sw    t2, (t0)           	#Guarda el numero del disco en la primera torre
    addi  t0, t0, 0x20         	#Brinca al siguiente espacio de la torre sumando 0x20
    addi  a0, a0 , 1         	#Suma 1 a a0
    jal   ra, for_torre         #Salta a torre
for_torre_final:
    jal   ra, hanoi            #Salta a hanoi          
#fin:
    jal zero, fin     

#Termina el programa*********************************************************************************************************      

#Funciones del programa
hanoi:
    bne   a0, t1, recursividad #Si a0 es diferente de t1 salta a recursividad
    jal   zero, mover

recursividad:
#Ciclo recursivo del algoritmo de las torres de hanoi
    #Reserva y guarda los datos en el stack
    addi  sp, sp, -0x14		#Reserva memoria en el stack para 5 datos
    sw    a0, 0(sp)             #Guarda el valor de a0 (Posicion de disco)
    sw    s4, 4(sp)             #Guarda el valor de la torre en s4
    sw    s5, 8(sp)             #Guarda el valor de la torre en s5
    sw    s6, 12(sp)            #Guarda el valor de la torre en s6
    sw    ra, 16(sp)            #Guarda el valor de retorno

    addi  a0, a0, -1            #Decrementa el valor de a0 en 1
    #Intercambia torre en s5 con la torre en s6
    add   t2, s5, zero          
    add   s5, s6, zero          
    add   s6, t2, zero           

    jal   ra, hanoi              #Salta a hanoi y guarda en ra

    #Recupera los datos del stack y libera la memoria
    lw    ra, 16(sp)             #Recupera la direccion de retorno en el stack
    lw    s6, 12(sp)             #Recupera la direccion de la torre del stack y la pone en s6
    lw    s5, 8(sp)              #Recupera la direccion de la torre del stack y la pone en s5
    lw    s4, 4(sp)              #Recupera la direccion de la torre del stack y la pone en s4
    lw    a0, 0(sp)              #Recupera la cantidad de discos en el stack y la pone en a0
    #Limpiamos el stack
    sw    zero, 16(sp)
    sw    zero, 12(sp)
    sw    zero, 8(sp)
    sw    zero, 4(sp)
    sw    zero, 0(sp)
    addi  sp, sp, 20		 #Liberamos la memoria para los 5 valores
    
    addi  a6,zero,0		 #Avisa a la funcion que fue llamada la funcion
    jal   s8, mover		 #Salta a iniciar_movimiento y guarda retorno en s8
    addi  a6,zero,1		 #Regresa el valor al predeterminado

    #Reserva memoria y guarda en el stack
    addi  sp, sp, -20		#Reserva para cinco datos
    sw    a0, 0(sp)             #Guarda la cantidad de discos
    sw    s4, 4(sp)             #Guarda la direccion de la torre en s4
    sw    s5, 8(sp)             #Guarda la direccion de la torre en s5
    sw    s6, 12(sp)            #Guarda la direccion de la torre en s6
    sw    ra, 16(sp)            #Guarda la direccion de retorno actual

    addi  a0, a0, -1            #Decrementa la cantidad de discos en a0
    #Intercambia s4 y s5
    add   t2, s4, zero          
    add   s4, s5, zero           
    add   s5, t2, zero           
    jal   ra, hanoi         	#Salta a hanoi         

    #Carga la informacion desde el stack
    lw    ra, 16(sp)  		#Recupera ra          
    lw    s6, 12(sp)           	#Recupera la direccion de la torre en s6  
    lw    s5, 8(sp)             #Recupera la direccion de la torre en s5
    lw    s4, 4(sp)             #Recupera la direccion de la torre en s4
    lw    a0, 0(sp)   		#Recupera el valor de los discos en a0
    #Limpiamos el stack
    sw    zero, 16(sp)
    sw    zero, 12(sp)
    sw    zero, 8(sp)
    sw    zero, 4(sp)
    sw    zero, 0(sp)   
            
    addi  sp, sp, 20		#Libera el espacio del stack
    jalr  zero,0(ra)            #Salta a ra sin guardar retorno      

mover:
    #Realiza el movimiento del disco de una torre a otra
    jal   s7, switch_s4        #Salta a switch_s4 y guarda la direccion de retorno en s7      
    sub   t0, s0, a4           #Resta la cantidad de discos en s0 a la cantidad que existen en la torre, guarda en t0
    slli  t0, t0, 5            #Recorre el valor binario de t0 cinco lugares a la izquierda
    add   t0, s4, t0           #Le suma a t0 el valor de la torre en s4 para obtener la posicion del disco a cambiar
    lw    t2, (t0)             #Carga el valor t2 del disco en la direccion t0
    sw    zero, (t0)           #Borra el espacio donde estaba el disco
    sub   t0, s0, a5           #Resta la cantidad de discos en s0 a la cantidad que existe en la torre, guarda en t0
    addi  t0, t0, -1           #Decrementa el valor de t0 en 1
    slli  t0, t0, 5            #Recorre el valor cinco posiciones binarias a la izquierda
    add   t0, s6, t0           #Le suma a t0 el valor de la torre en s6 para obtener la posicion del disco destino en t0
    sw    t2, (t0)             #Guarda el valor de t2 del disco en la direccion t0
    beq   a6,zero,if	       #Revisa si iniciar_movimiento fue mandado a llamar o si fue por el flujo de programa
    jalr  ra,0(ra)             #Salta a ra y guarda la direccion de retorno en ra
if:
    jalr  zero,0(s8)	       #Salta a s8 y no guarda la direccion de retorno

switch_s4:
    #Switch para saber que torre hay en s4 y actuar en base a eso
    beq   s4, s1, caso_1      #Si el valor en s4 es el de la torre s1 salta a caso_1  
    beq   s4, s2, caso_2      #Si el valor en s4 es el de la torre s2 salta a caso_2
    beq   s4, s3, caso_3      #Si el valor en s4 es el de la torre s3 salta a caso_3

#Recibe el numero de discos en la torre y guarda en a4
caso_1:
    add   a4, zero, a1        #Se asigna la cantidad de discos en a1 a a4
    addi  a1, a1, -1          #Decrementa en 1 la cantidad de los discos en a1
    jal   zero, switch_s6     #Salta a switch_s6 sin guardar la direccion de retorno  
          
caso_2:
    add   a4, zero, a2       #Se asigna la cantidad de discos en a2 a a4       
    addi  a2, a2, -1         #Decrementa en 1 la cantidad de los discos en a2   
    jal   zero, switch_s6    #Salta a switch_s6 sin guardar la direccion de retorno
caso_3:
    add   a4, zero, a3       #Guarda la cantidad de discos en a3 en a4     
    addi  a3, a3, -1         #Decrementa el valor de a3   
    jal   zero, switch_s6    #Salta a switch_s6 sin guardar retorno  

switch_s6:
    #Switch para saber que torre hay en s6 y actuar en base a eso
    beq   s6, s1, final_1   #Si el valor de s6 es el de la torre 1  
    beq   s6, s2, final_2   #Si el valor de s6 es el de la torre 2
    beq   s6, s3, final_3   #Si el valor de s6 es el de la torre 3

#Recibe el numero de discos en la torre y guarda en a5
final_1:
    add   a5, zero, a1          #Le asigna la cantidad de discos en a1 a a5
    addi  a1, a1, 1             #Aumenta el valor de los discos en a1
    jalr  zero, 0(s7)          	#Salta a la direccion s7 sin guardar retorno
final_2:
    add   a5, zero, a2          #Le asigna la cantidad de discos en a2 a a5
    addi  a2, a2, 1             #Aumenta la cantidad de discos en a2
    jalr  zero, 0(s7)           #Salta a la direccion s7 sin guardar retorno
final_3:		
    add   a5, zero, a3          #Le asigna el valor de a3 a a5
    addi  a3, a3, 1             #Aumenta el valor de a3 en 1
    jalr  zero, 0(s7)           #Salta a la direccion en s7 sin guardar retorno
fin: