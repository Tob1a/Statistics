function queue_over_time = simulate_queue_queue_length(lambda, mu, N, T)
% SIMULATE_QUEUE_QUEUE_LENGTH Traccia la lunghezza della coda nel tempo
%
% Restituisce una matrice Mx2: [tempo, lunghezza_coda]
% Utile per visualizzare la crescita (o stabilità) della coda.
%
% INPUT:
%   lambda - tasso di arrivo
%   mu     - tasso di servizio per server
%   N      - numero di server
%   T      - durata simulazione
%
% OUTPUT:
%   queue_over_time - matrice [t, queue_len] campionata ad ogni evento

server_free_at = zeros(1, N);
current_time   = -log(rand) / lambda;

times      = [];
queue_lens = [];

while current_time < T
    % Calcola quanti server sono occupati in questo istante
    n_busy = sum(server_free_at > current_time);
    q_len  = max(0, n_busy - N);   % richieste in coda (in questa implementazione è 0 o il surplus)

    % In realtà il numero in coda non si calcola così direttamente nell'approccio
    % event-based semplificato. Lo approssimamo così:
    % - se tutti i server sono occupati E il server più libero si libera dopo current_time
    %   significa che quella richiesta è andata in coda
    [min_free, ~] = min(server_free_at);
    if min_free > current_time
        % calcola quante richieste sono "accumulate" nel futuro dei server
        future_load = sum(max(0, server_free_at - current_time));
        approx_queue = max(0, round(future_load * mu) - N);
    else
        approx_queue = 0;
    end

    times(end+1)      = current_time;      %#ok<AGROW>
    queue_lens(end+1) = approx_queue;      %#ok<AGROW>

    % Gestione arrivo
    [min_free_time, server_idx] = min(server_free_at);
    service_time = -log(rand) / mu;
    if min_free_time <= current_time
        server_free_at(server_idx) = current_time + service_time;
    else
        server_free_at(server_idx) = min_free_time + service_time;
    end

    current_time = current_time + (-log(rand) / lambda);
end

queue_over_time = [times', queue_lens'];
end
