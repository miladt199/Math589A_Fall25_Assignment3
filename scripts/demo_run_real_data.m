% scripts/demo_run_real_data.m
addpath(fullfile('..','src'));
tbl = readtable('../data/tucsonAZ.csv');
%y = tbl.wateruse;
y = tbl.elecuse;
s = 12; Ngrid = 0:8; Kgrid = 0:3; criterion = 'bic';
best = select_model(y, s, Ngrid, Kgrid, criterion);
yhat = predict_in_sample(y, s, best.coef);
H = 12; yF = forecast(y, s, best.coef, H);
fprintf('BEST N=%d, K=%d, score=%.3f\n', best.N, best.K, best.score);
fprintf('MSE=%.6f\n', mean((y(best.N+1:end)-yhat).^2));
disp('First 3 forecasts:');
disp(yF(1:3).');
%%
% ---- Plot real vs predicted (in-sample) ----
T = numel(y);
N = best.N;

t_real = (N+1:T)';   % time indices for predictions

figure;
plot(t_real, y(N+1:end), 'b.-', 'LineWidth', 1.2); hold on;
plot(t_real, yhat, 'r--', 'LineWidth', 1.2);
grid on;

xlabel('Time (months)');
ylabel('Electricity use');
title('Electric use – Tucson (real vs predicted)');
legend('Real data','Predicted','Location','best');
