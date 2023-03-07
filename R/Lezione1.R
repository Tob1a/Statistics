x =(1,2,3,4)
#commento
#R è case sensitive
getwd()
[1] "/Users/tobiasacchetto"
setwd("/Users/tobiasacchetto/Documents/Statistics")
ls()
#dice tutti gli elementi 
rm()
#rimuove una variabile oppure uno spazio di lavoro
rm(x)
rm(list=ls())
plot() #serve per fare il grafico
# esempio di codice
ETA = c(19,22,21,23,22,20)
PESO = c(50,75,80,56,75,58)
ALTEZZA = c(1.65,1.70,1.91,2.23,2.45)
ALTOM = ALTEZZA * 100
SESSO = c("M","F")
#factor(sesso) mi stampa a video le variabili sesso
PESO[3]#prende il terzo elemento all'interno di peso
PESO(c(6,3)) #prende il seste e terzo elemento
PESO(6,3) #prende l'elemento nella riga 6 colonna 3
PESO(-5) #elemina elemento nella posizione 5
PESO(<79) #stampa a video elementi maggiori di 79
seq(from = 1, to= 15, by=3)
#crea una seguenza da 1 a 15 con passo 3
times = 5
x=c(1,2)
rep(x, times) #ripete x 5 volte 1212121212 bla bla bla
Dati = data.frame(ETA, PESO, SESSO,ALTEZZA)
#crea una tabella con i dati inseriti
Dati #mi stampa a video la tabella
Dati [1, c(1,4)] #mi stampa a video i dati nella prima riga numero 1 e numero 4
Dati [2,] #mi stampa a video i dati nella seconda colonna
Dati$ETA #mi estrapola tutti i dati di eta
list(Dati, x0)
#mette in una lista la tabella dati e la variabile x
read.table()
madian(ALTEZZA) #mediana campionaria
mean(ALTEZZA)#media campionaria
summary(ALTEZZA)#riporta il primo quartile ,il secondo,...
table(ALTEZZA)#frequenza assolute di altezza
prop.table(ALTEZZA)#frequenza relativa
boxplot()
pie() #diagramma di torta
barplot()#diagramma a barre