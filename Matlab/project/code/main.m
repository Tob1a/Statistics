%% =========================================================
%  SISTEMA DI CODE M/M/N - Esercitazione di Statistica
%  =========================================================
%  Struttura:
%   Sezione 1 - Parametri globali
%   Sezione 2 - Simulazione base e statistiche
%   Sezione 3 - Analisi al variare di N, lambda, mu
%   Sezione 4 - Ottimizzazione: N ottimale e instabilità
%   Sezione 5 - Analisi statistica (K ripetizioni, IC, TLC, regressione)
% =========================================================

clear; clc; close all;
rng(42);  % seed per riproducibilità (opzionale, rimuovere per risultati casuali)

%% =========================================================
%  SEZIONE 1 - PARAMETRI GLOBALI
%% =========================================================
lambda   = 5;      % tasso di arrivo [richieste/secondo]
mu       = 2;      % tasso di servizio per server [richieste/secondo]
N        = 4;      % numero di server
T        = 5000;   % durata simulazione [secondi] - abbastanza lungo per regime stazionario
K        = 200;    % numero di ripetizioni per analisi statistica
soglia   = 1.0;    % soglia massima accettabile per il tempo medio di attesa [secondi]

fprintf('==============================================\n');
fprintf('  SISTEMA DI CODE M/M/N\n');
fprintf('  lambda=%.1f, mu=%.1f, N=%d, T=%d, K=%d\n', lambda, mu, N, T, K);
fprintf('  rho = lambda/(N*mu) = %.3f\n', lambda / (N * mu));
fprintf('==============================================\n\n');

%% =========================================================
%  SEZIONE 2 - SIMULAZIONE BASE E STATISTICHE
%% =========================================================
fprintf('--- SEZIONE 2: Simulazione base ---\n');

[avg_wait, p_imm, util, all_waits] = simulate_queue(lambda, mu, N, T);

fprintf('Tempo medio di attesa in coda:    %.4f s\n', avg_wait);
fprintf('Prob. di servizio immediato:      %.2f%%\n',  p_imm * 100);
fprintf('Utilizzo dei server:\n');
for i = 1:N
    fprintf('  Server %d: %.2f%%\n', i, util(i) * 100);
end
fprintf('\n');

% Istogramma dei tempi di attesa individuali
figure('Name', 'Distribuzione tempi di attesa');
histogram(all_waits, 50, 'Normalization', 'pdf', 'FaceColor', [0.2 0.5 0.8]);
xlabel('Tempo di attesa (s)');
ylabel('Densità di probabilità');
title(sprintf('Distribuzione tempi di attesa (\\lambda=%.1f, \\mu=%.1f, N=%d)', lambda, mu, N));
grid on;

%% =========================================================
%  SEZIONE 3 - ANALISI AL VARIARE DI N, lambda, mu
%% =========================================================
fprintf('--- SEZIONE 3: Analisi delle prestazioni ---\n');

%% 3a - Variare N
N_values = 1:10;
wait_vs_N    = zeros(size(N_values));
pimm_vs_N    = zeros(size(N_values));

for i = 1:length(N_values)
    n = N_values(i);
    rho = lambda / (n * mu);
    if rho >= 1
        % Sistema instabile: la coda cresce all'infinito
        % Simuliamo comunque ma il risultato non è a regime
        wait_vs_N(i) = NaN;
        pimm_vs_N(i) = NaN;
    else
        [wait_vs_N(i), pimm_vs_N(i), ~, ~] = simulate_queue(lambda, mu, n, T);
    end
end

figure('Name', 'Prestazioni vs N');
subplot(2,1,1);
plot(N_values, wait_vs_N, 'o-', 'LineWidth', 2, 'MarkerSize', 7, 'Color', [0.8 0.2 0.2]);
xlabel('Numero di server N');
ylabel('Tempo medio attesa (s)');
title('Tempo medio di attesa al variare di N');
grid on;

subplot(2,1,2);
plot(N_values, pimm_vs_N * 100, 's-', 'LineWidth', 2, 'MarkerSize', 7, 'Color', [0.2 0.7 0.3]);
xlabel('Numero di server N');
ylabel('Prob. servizio immediato (%)');
title('Probabilità di servizio immediato al variare di N');
grid on;

%% 3b - Variare lambda
lambda_values = 0.5:0.5:9;
wait_vs_lambda = zeros(size(lambda_values));
for i = 1:length(lambda_values)
    lam = lambda_values(i);
    rho = lam / (N * mu);
    if rho >= 1
        wait_vs_lambda(i) = NaN;
    else
        [wait_vs_lambda(i), ~, ~, ~] = simulate_queue(lam, mu, N, T);
    end
end

figure('Name', 'Prestazioni vs lambda e mu');
subplot(2,1,1);
plot(lambda_values, wait_vs_lambda, 'o-', 'LineWidth', 2, 'Color', [0.7 0.3 0.8]);
xlabel('\lambda (richieste/s)');
ylabel('Tempo medio attesa (s)');
title('Tempo medio di attesa al variare di \lambda');
grid on;

%% 3b - Variare mu
mu_values = 0.5:0.5:5;
wait_vs_mu = zeros(size(mu_values));
for i = 1:length(mu_values)
    m = mu_values(i);
    rho = lambda / (N * m);
    if rho >= 1
        wait_vs_mu(i) = NaN;
    else
        [wait_vs_mu(i), ~, ~, ~] = simulate_queue(lambda, m, N, T);
    end
end

subplot(2,1,2);
plot(mu_values, wait_vs_mu, 's-', 'LineWidth', 2, 'Color', [0.9 0.5 0.1]);
xlabel('\mu (richieste/s per server)');
ylabel('Tempo medio attesa (s)');
title('Tempo medio di attesa al variare di \mu');
grid on;

fprintf('Grafici variazione N, lambda, mu generati.\n\n');

%% =========================================================
%  SEZIONE 4 - OTTIMIZZAZIONE: N OTTIMALE E INSTABILITÀ
%% =========================================================
fprintf('--- SEZIONE 4: Ottimizzazione ---\n');

% Trova il numero minimo di server N* tale che avg_wait < soglia
N_opt = NaN;
for n = 1:20
    rho = lambda / (n * mu);
    if rho >= 1
        continue;  % sistema instabile, prova con più server
    end
    [w, ~, ~, ~] = simulate_queue(lambda, mu, n, T);
    fprintf('  N=%d, rho=%.3f, avg_wait=%.4f s\n', n, rho, w);
    if w < soglia && isnan(N_opt)
        N_opt = n;
        fprintf('  --> N ottimale trovato: N=%d (attesa=%.4f < soglia=%.2f)\n', n, w, soglia);
    end
end

% Dimostrazione che sotto N_critico la coda cresce indefinitamente
% Il N critico minimo è ceil(lambda/mu) — il sistema deve avere rho < 1
N_critico = ceil(lambda / mu);
fprintf('\nN critico minimo per stabilità (rho<1): N=%d\n', N_critico);
fprintf('Con N=%d: rho=%.3f (instabile, coda → infinito)\n', N_critico-1, lambda/((N_critico-1)*mu));
fprintf('Con N=%d: rho=%.3f (stabile)\n', N_critico, lambda/(N_critico*mu));

% Simulazione visiva della crescita della coda con N instabile
figure('Name', 'Crescita della coda: sistema instabile vs stabile');
T_short = 500;

% Sistema instabile (N = N_critico - 1, se > 0)
N_instabile = max(1, N_critico - 1);
queue_length_instabile = simulate_queue_queue_length(lambda, mu, N_instabile, T_short);

% Sistema stabile (N = N_critico)
queue_length_stabile = simulate_queue_queue_length(lambda, mu, N_critico, T_short);

subplot(2,1,1);
plot(queue_length_instabile(:,1), queue_length_instabile(:,2), 'r-', 'LineWidth', 1.2);
xlabel('Tempo (s)'); ylabel('Richieste in coda');
title(sprintf('Sistema INSTABILE: N=%d, \\rho=%.2f \\geq 1', N_instabile, lambda/(N_instabile*mu)));
grid on;

subplot(2,1,2);
plot(queue_length_stabile(:,1), queue_length_stabile(:,2), 'b-', 'LineWidth', 1.2);
xlabel('Tempo (s)'); ylabel('Richieste in coda');
title(sprintf('Sistema STABILE: N=%d, \\rho=%.2f < 1', N_critico, lambda/(N_critico*mu)));
grid on;

fprintf('\n');

%% =========================================================
%  SEZIONE 5 - ANALISI STATISTICA (K RIPETIZIONI)
%% =========================================================
fprintf('--- SEZIONE 5: Analisi statistica ---\n');

%% 5a - Stima media e varianza del tempo di attesa (K ripetizioni)
results_K = zeros(1, K);
for k = 1:K
    [results_K(k), ~, ~, ~] = simulate_queue(lambda, mu, N, T);
end

[mu_est, var_est, ci_200] = statistical_analysis(results_K, K);
fprintf('K=%d ripetizioni:\n', K);
fprintf('  Media stimata:    %.4f s\n', mu_est);
fprintf('  Varianza stimata: %.6f\n',   var_est);
fprintf('  IC 95%%:          [%.4f, %.4f]\n\n', ci_200(1), ci_200(2));

%% 5b - IC al 95% per K = 50, 100, 200, 2000
K_values = [50, 100, 200, 2000];
fprintf('Intervalli di confidenza al 95%% per diversi K:\n');
fprintf('  %-6s %-10s %-10s %-10s %-10s\n', 'K', 'Media', 'Std', 'IC lower', 'IC upper');

figure('Name', 'Intervalli di confidenza al variare di K');
ci_lowers = zeros(1, length(K_values));
ci_uppers = zeros(1, length(K_values));
means_K   = zeros(1, length(K_values));

for idx = 1:length(K_values)
    k = K_values(idx);
    data_k = zeros(1, k);
    for i = 1:k
        [data_k(i), ~, ~, ~] = simulate_queue(lambda, mu, N, T);
    end
    [m, v, ci] = statistical_analysis(data_k, k);
    means_K(idx)   = m;
    ci_lowers(idx) = ci(1);
    ci_uppers(idx) = ci(2);
    fprintf('  %-6d %-10.4f %-10.4f %-10.4f %-10.4f\n', k, m, sqrt(v), ci(1), ci(2));
end

% Grafico IC
errorbar(1:length(K_values), means_K, means_K - ci_lowers, ci_uppers - means_K, ...
    'o-', 'LineWidth', 2, 'MarkerSize', 8, 'CapSize', 10, 'Color', [0.2 0.4 0.8]);
xticks(1:length(K_values));
xticklabels(arrayfun(@num2str, K_values, 'UniformOutput', false));
xlabel('K (numero di ripetizioni)');
ylabel('Tempo medio di attesa (s)');
title('Intervalli di confidenza al 95% al variare di K');
grid on;
fprintf('\n');

%% 5c - Teorema del Limite Centrale
% Per ciascun campione di dimensione n, calcola 50 medie campionarie
fprintf('Calcolo TLC (50 medie campionarie per n=10,30,50,100)...\n');

sample_sizes = [10, 30, 50, 100];
n_means      = 50;

% Pool grande di simulazioni (evita di risimulaare troppe volte)
pool_size = max(sample_sizes) * n_means * 2;
pool = zeros(1, pool_size);
for i = 1:pool_size
    [pool(i), ~, ~, ~] = simulate_queue(lambda, mu, N, T);
end

figure('Name', 'Teorema del Limite Centrale');
for s = 1:length(sample_sizes)
    n = sample_sizes(s);
    sample_means = zeros(1, n_means);
    for i = 1:n_means
        % Estrae n elementi casuali dal pool
        idx = randperm(pool_size, n);
        sample_means(i) = mean(pool(idx));
    end

    subplot(2, 2, s);
    % Istogramma normalizzato
    histogram(sample_means, 12, 'Normalization', 'pdf', ...
              'FaceColor', [0.3 0.6 0.9], 'EdgeColor', 'white');
    hold on;

    % Sovrapposizione della curva normale teorica
    x_range = linspace(min(sample_means), max(sample_means), 100);
    mu_tlc  = mean(sample_means);
    sig_tlc = std(sample_means);
    y_norm  = (1 / (sig_tlc * sqrt(2*pi))) * exp(-0.5 * ((x_range - mu_tlc) / sig_tlc).^2);
    plot(x_range, y_norm, 'r-', 'LineWidth', 2);

    xlabel('Media campionaria (s)');
    ylabel('Densità');
    title(sprintf('n = %d campioni\n\\mu=%.3f, \\sigma=%.4f', n, mu_tlc, sig_tlc));
    legend('Empirica', 'Normale teorica', 'Location', 'best');
    hold off;
    grid on;
end
sgtitle('Teorema del Limite Centrale - Tempi di attesa');
fprintf('TLC completato.\n\n');

%% 5d - Regressione lineare: attesa vs N, lambda, mu
fprintf('--- Regressione lineare ---\n');

% Attesa vs N
N_reg     = (ceil(lambda/mu)):10;
wait_N_reg = zeros(size(N_reg));
for i = 1:length(N_reg)
    [wait_N_reg(i), ~, ~, ~] = simulate_queue(lambda, mu, N_reg(i), T);
end
p_N = polyfit(N_reg, wait_N_reg, 1);
fprintf('Regressione attesa ~ N:      y = %.4f*N + %.4f\n', p_N(1), p_N(2));

% Attesa vs lambda (solo valori stabili)
lam_reg  = 0.5:0.5:N*mu*0.95;
wait_lam = zeros(size(lam_reg));
for i = 1:length(lam_reg)
    [wait_lam(i), ~, ~, ~] = simulate_queue(lam_reg(i), mu, N, T);
end
p_lam = polyfit(lam_reg, wait_lam, 1);
fprintf('Regressione attesa ~ lambda: y = %.4f*lambda + %.4f\n', p_lam(1), p_lam(2));

% Attesa vs mu (solo valori stabili)
mu_reg   = (lambda/N + 0.1):0.2:5;
wait_mu  = zeros(size(mu_reg));
for i = 1:length(mu_reg)
    [wait_mu(i), ~, ~, ~] = simulate_queue(lambda, mu_reg(i), N, T);
end
p_mu = polyfit(mu_reg, wait_mu, 1);
fprintf('Regressione attesa ~ mu:     y = %.4f*mu + %.4f\n', p_mu(1), p_mu(2));

% Grafici di regressione
figure('Name', 'Regressione lineare');

subplot(1,3,1);
scatter(N_reg, wait_N_reg, 40, 'filled', 'MarkerFaceColor', [0.2 0.5 0.8]);
hold on;
plot(N_reg, polyval(p_N, N_reg), 'r-', 'LineWidth', 2);
xlabel('N'); ylabel('Attesa media (s)');
title('Attesa vs N'); grid on; legend('Dati', 'Regressione');

subplot(1,3,2);
scatter(lam_reg, wait_lam, 40, 'filled', 'MarkerFaceColor', [0.2 0.7 0.3]);
hold on;
plot(lam_reg, polyval(p_lam, lam_reg), 'r-', 'LineWidth', 2);
xlabel('\lambda'); ylabel('Attesa media (s)');
title('Attesa vs \lambda'); grid on; legend('Dati', 'Regressione');

subplot(1,3,3);
scatter(mu_reg, wait_mu, 40, 'filled', 'MarkerFaceColor', [0.8 0.4 0.1]);
hold on;
plot(mu_reg, polyval(p_mu, mu_reg), 'r-', 'LineWidth', 2);
xlabel('\mu'); ylabel('Attesa media (s)');
title('Attesa vs \mu'); grid on; legend('Dati', 'Regressione');

sgtitle('Analisi di regressione lineare');

fprintf('\n==============================================\n');
fprintf('  Simulazione completata.\n');
fprintf('==============================================\n');
