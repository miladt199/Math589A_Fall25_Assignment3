function [A,b,meta] = build_design(y, s, N, K)
% BUILD_DESIGN  LS system for Nth-order difference eq + K harmonics + linear trend.
% Columns: [1, t, lags..., cos..., sin...]

    y = y(:); 
    T = numel(y);

    if N < 0 || K < 0 || N ~= floor(N) || K ~= floor(K)
        error('N and K must be nonnegative integers.');
    end
    if T <= N
        error('Need T > N.');
    end

    M = T - N;
    p = 2 + N + 2*K;   % IMPORTANT: include trend term

    if M <= p
        error('Underdetermined: T-N (= %d) must exceed p (= %d).', M, p);
    end

    t = (N+1:T).';
    b = y(N+1:T);

    A = zeros(M, p);
    A(:,1) = 1;        % constant c
    A(:,2) = t;        % trend d*t

    col = 2;

    % lag columns: y_{t-1},...,y_{t-N}
    for i = 1:N
        col = col + 1;
        A(:, col) = y(N+1-i : T-i);
    end

    % cosine columns
    for k = 1:K
        col = col + 1;
        A(:, col) = cos(2*pi*k*t/s);
    end

    % sine columns
    for k = 1:K
        col = col + 1;
        A(:, col) = sin(2*pi*k*t/s);
    end

    meta = struct('rows',M,'p',p,'t',t);
end
