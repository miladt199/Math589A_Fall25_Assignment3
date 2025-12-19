function yhat = predict_in_sample(y, s, coef)
%PREDICT_IN_SAMPLE  Predict y_t for t=N+1..T using observed lags (one-step fits).
% Must return length T-N so grade.m can do y(N+1:end)-yhat.

    y = y(:);
    T = numel(y);

    N = numel(coef.a);
    K = numel(coef.alpha);

    M = T - N;
    yhat = zeros(M,1);

    for krow = 1:M
        t = N + krow;  % actual time index

        sea = 0;
        for h = 1:K
            sea = sea + coef.alpha(h)*cos(2*pi*h*t/s) + coef.beta(h)*sin(2*pi*h*t/s);
        end

        % include trend
        acc = coef.c + coef.d*t + sea;

        for i = 1:N
            acc = acc + coef.a(i)*y(t-i);
        end

        yhat(krow) = acc;
    end
end
