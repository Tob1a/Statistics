library(base)

# Definisci l'angolo in gradi
angolo_in_gradi <- 20

# Converte l'angolo in radianti
angolo_in_radianti <- deg2rad(angolo_in_gradi)

# Calcola il seno dell'angolo in radianti
seno_in_radianti <- sin(angolo_in_radianti)

# Stampa il risultato
cat("Seno in radianti:", seno_in_radianti, "\n")


#oppure c'è anche lo script 

# Definisci l'angolo in gradi
angolo_in_gradi <- 20

# Converte l'angolo in radianti
angolo_in_radianti <- (angolo_in_gradi / 180) * pi

# Calcola il seno dell'angolo in radianti
seno_in_radianti <- sin(angolo_in_radianti)

# Stampa il risultato
cat("Seno in radianti:", seno_in_radianti, "\n")