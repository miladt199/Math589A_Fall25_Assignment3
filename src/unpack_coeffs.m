function coef = unpack_coeffs(beta, N, K)
% beta = [c; d; a1..aN; alpha1..alphaK; beta1..betaK]

    coef.c = beta(1);
    coef.d = beta(2);

    if N > 0
        coef.a = beta(3:2+N);
    else
        coef.a = zeros(0,1);
    end

    if K > 0
        coef.alpha = beta(3+N : 2+N+K);
        coef.beta  = beta(3+N+K : 2+N+2*K);
    else
        coef.alpha = zeros(0,1);
        coef.beta  = zeros(0,1);
    end
end
