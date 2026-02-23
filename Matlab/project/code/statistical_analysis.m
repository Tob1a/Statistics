function [mu_est, var_est, ci_95] = statistical_analysis(data, K)
% STATISTICAL_ANALYSIS Stima media, varianza e intervallo di confidenza 95%
%
% INPUT:
%   data - vettore di K osservazioni (es. tempi medi di attesa)
%   K    - numero di ripetizioni (per chiarezza, anche se ricavabile da data)
%
% OUTPUT:
%   mu_est  - media campionaria
%   var_est - varianza campionaria
%   ci_95   - [lower, upper] intervallo di confidenza al 95%

mu_est  = mean(data);
var_est = var(data);   % varianza con correzione di Bessel (N-1)

% Errore standard della media
se = std(data) / sqrt(K);

% Per K >= 30 usiamo z=1.96 (normale); per K < 30 sarebbe più corretto t di Student
% Usiamo sempre t per essere rigorosi
t_crit = tinv(0.975, K - 1);  % percentile 97.5% della t con K-1 gradi di libertà
ci_95  = [mu_est - t_crit * se, mu_est + t_crit * se];

end
