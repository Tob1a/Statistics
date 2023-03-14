#Calcoliamo la probabilità che in un gruppo di N persone non ci sia nemmeno una coppia che condivide lo stesso giorno

rm(list=ls())
N=13
days=365
#factorial(N) crea il fattoriale di N quindi N! quindi N*(N-1)*...*1
#choose(52, 2) è il coeficiente binomiale di 52 su 2 -> 52! / (2! * (52-2)!) = 52! / (2! * 50!) = (52*51) / 2 = 1326.  formula -> n! / (k! * (n-k)!)
numero_esiti_possibili= days^N
numero_esiti_favorevoli=factorial(N)*choose(365, N)
#Probabilità che non ci siano due persone che condividano lo stesso compleanno lo stesos giorno
print(numero_esiti_favorevoli/numero_esiti_possibili)
#Probabilità che ci siano due persone che condividono lo stesso giorno per il compleanno
print(1-numero_esiti_favorevoli/numero_esiti_possibili)
