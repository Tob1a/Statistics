# Sistema di Code M/M/N — Guida al Codice

## File del progetto

| File | Descrizione |
|------|-------------|
| `main.m` | Script principale — esegue tutte le sezioni dell'esercitazione |
| `simulate_queue.m` | Funzione core della simulazione M/M/N |
| `simulate_queue_queue_length.m` | Variante che traccia la lunghezza della coda nel tempo |
| `statistical_analysis.m` | Calcola media, varianza e IC al 95% |

---

## Come eseguire

Aprire MATLAB, navigare nella cartella del progetto ed eseguire:

```matlab
main
```

Tutti i grafici e i risultati vengono generati automaticamente.

---

## Parametri modificabili (inizio di main.m)

```matlab
lambda = 5;     % tasso di arrivo [richieste/secondo]
mu     = 2;     % tasso di servizio per server [richieste/secondo]
N      = 4;     % numero di server
T      = 5000;  % durata simulazione [secondi]
K      = 200;   % ripetizioni per analisi statistica
soglia = 1.0;   % soglia massima accettabile per l'attesa [secondi]
```

---

## Generazione delle distribuzioni casuali

Il codice usa **solo** `rand()` (uniforme in [0,1]), come richiesto dal testo.

Le distribuzioni esponenziali vengono generate con il **metodo dell'inversa**:

```
Se U ~ Uniform(0,1), allora X = -ln(U)/lambda ~ Exponential(lambda)
```

Dimostrazione: la CDF dell'esponenziale è F(x) = 1 - e^(-λx).
Invertendola: F⁻¹(u) = -ln(1-u)/λ. Poiché (1-U) ~ U(0,1), si usa direttamente -ln(U)/λ.

---

## Struttura della simulazione (event-driven)

La simulazione avanza **evento per evento** (non a passi di tempo fissi):

1. Genera il tempo del prossimo arrivo (esponenziale)
2. Trova il server con il minore tempo di liberazione
3. Se libero → servizio immediato; se occupato → la richiesta aspetta
4. Aggiorna il tempo di liberazione del server assegnato
5. Ripeti finché `current_time < T`

---

## Contenuto delle sezioni di main.m

- **Sezione 2** — Singola simulazione: media attesa, prob. immediata, utilizzo server
- **Sezione 3** — Loop su N, λ, μ: grafici delle prestazioni
- **Sezione 4** — N ottimale (soglia attesa), dimostrazione instabilità (ρ ≥ 1)
- **Sezione 5a** — K=200 ripetizioni: media e varianza
- **Sezione 5b** — IC 95% per K=50,100,200,2000
- **Sezione 5c** — Teorema del Limite Centrale (50 medie per n=10,30,50,100)
- **Sezione 5d** — Regressione lineare attesa ~ N, attesa ~ λ, attesa ~ μ

---

## Condizione di stabilità

Il sistema M/M/N è stabile se e solo se:

```
ρ = λ / (N · μ) < 1
```

Se ρ ≥ 1, la coda cresce senza limite. Il codice rileva automaticamente questa condizione.
