function [avg_wait, p_immediate, server_utilization, all_waits] = simulate_queue(lambda, mu, N, T)
% SIMULATE_QUEUE Simula un sistema di code M/M/N con eventi discreti
%
% INPUT:
%   lambda  - tasso di arrivo (richieste/secondo)
%   mu      - tasso di servizio per server (richieste/secondo)
%   N       - numero di server
%   T       - durata simulazione (secondi)
%
% OUTPUT:
%   avg_wait          - tempo medio di attesa in coda
%   p_immediate       - probabilità di servizio immediato
%   server_utilization - vettore (1xN) con % occupazione di ciascun server
%   all_waits         - vettore di tutti i tempi di attesa individuali

% server_free_at(i) = istante in cui il server i si libera
% Se server_free_at(i) <= current_time, il server è libero
server_free_at = zeros(1, N);

% Tempo totale di lavoro per ciascun server (per calcolare l'utilizzo)
server_busy_time = zeros(1, N);

all_waits  = [];
n_immediate = 0;
n_total     = 0;

% Genera il tempo del primo arrivo (distribuzione esponenziale via metodo inverso)
current_time = -log(rand) / lambda;

while current_time < T
    n_total = n_total + 1;

    % --- Trova il server ottimale ---
    % Il server con il minore server_free_at è quello che si libera prima
    [min_free_time, server_idx] = min(server_free_at);

    if min_free_time <= current_time
        % Almeno un server è libero: servizio immediato
        wait = 0;
        n_immediate = n_immediate + 1;
        service_time = -log(rand) / mu;
        server_busy_time(server_idx) = server_busy_time(server_idx) + service_time;
        server_free_at(server_idx)   = current_time + service_time;
    else
        % Tutti i server sono occupati: la richiesta va in coda
        % Viene presa in carico dal primo server che si libera (min_free_time)
        wait = min_free_time - current_time;
        service_time = -log(rand) / mu;
        server_busy_time(server_idx) = server_busy_time(server_idx) + service_time;
        server_free_at(server_idx)   = min_free_time + service_time;
    end

    all_waits(end+1) = wait; %#ok<AGROW>

    % Genera il prossimo arrivo (inter-arrivo esponenziale)
    current_time = current_time + (-log(rand) / lambda);
end

% --- Calcolo statistiche finali ---
if isempty(all_waits)
    avg_wait    = 0;
    p_immediate = 1;
    server_utilization = zeros(1, N);
    return;
end

avg_wait    = mean(all_waits);
p_immediate = n_immediate / n_total;

% Utilizzo: frazione del tempo totale T in cui ciascun server era occupato
% Viene limitato a 1 (può superarlo lievemente per richieste iniziate vicino a T)
server_utilization = min(server_busy_time / T, 1);

end
