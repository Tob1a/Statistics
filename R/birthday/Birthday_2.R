#Calcoliamo la probabilità che in un gruppo di N persone non ci sia nemmeno una coppia che condivide lo stesso giorno

rm(list=ls())
Nvector=1 :100 #numero di persone all'interno del gruppo
days=365
nexp = 200 #numero di esperiemnti che volgio fare
fr = rep(0,length(Nvector))
p_no= rep(0, length(Nvector)) #inizializza un vettore di tanti 0 quanti sono i valori di N che considero
p_almeno2=rep(0, length(Nvector)) #Inizializzo un vettore di tanti 0 quanti sono i valori di N che considero
#factorial(N) crea il fattoriale di N quindi N! quindi N*(N-1)*...*1
#choose(52, 2) è il coeficiente binomiale di 52 su 2 -> 52! / (2! * (52-2)!) = 52! / (2! * 50!) = (52*51) / 2 = 1326.  formula -> n! / (k! * (n-k)!)
for(i in 1 : length(Nvector))
{
  N= Nvector[i]
  numero_esiti_possibili= days^N
  numero_esiti_favorevoli=factorial(N)*choose(days, N)
  #Probabilità che non ci siano due persone che condividano lo stesso compleanno lo stesos giorno
  p_no[i]=numero_esiti_favorevoli/numero_esiti_possibili
  #Probabilità che ci siano due persone che condividono lo stesso giorno per il compleanno
  p_almeno2[i]=1-p_no[i]
  conta=vector()
  for(j in 1 :nexp){
    y=sample(1:days, N, replace = TRUE)
    print(y)
    conta[j] = anyDuplicated(y)
  }
  fr[i]=sum(conta>0)/nexp #fa la frequenza relativa
}
#plot e line vengono eseguite prima 
#plot(Nvector, p_no, type="l")

#line(Nvector, p_no, type="l", col="red")

plot(Nvector, p_almeno2, type="l", col="blue")

line(Nvector, fr, type="p", col="green")

NN=13
y=sample(1:days, NN, replace=TRUE)
