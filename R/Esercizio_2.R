#Esercizio 2
NOME = c("Stati Uniti","Sud America", "Messico", "Canada")
CONNESSIONI = c(387.4,506.3,318.0,200.8)
Dati = data.frame(NOME,CONNESSIONI)
pie(CONNESSIONI, labels = NOME)