function x = qr_solve_dense(A,b)
% QR_SOLVE_DENSE  Solve min ||A*x - b||_2 using explicit Householder QR.
% No backslash, pinv, chol, svd, regress, fitlm, arima, etc.

    [m,n] = size(A);
    R = A;
    y = b;

    for k = 1:n
        v = R(k:end,k);
        nv = norm(v);
        if nv == 0
            continue;
        end

        sgn = sign(v(1));
        if sgn == 0, sgn = 1; end

        alpha = -sgn * nv;
        v(1) = v(1) - alpha;

        nv2 = norm(v);
        if nv2 == 0
            continue;
        end
        v = v / nv2;

        R(k:end,k:end) = R(k:end,k:end) - 2*v*(v.'*R(k:end,k:end));
        y(k:end)       = y(k:end)       - 2*v*(v.'*y(k:end));
    end

    R = triu(R(1:n,1:n));
    x = zeros(n,1);

    for i = n:-1:1
        if R(i,i) == 0
            error('Singular system in back substitution.');
        end
        x(i) = (y(i) - R(i,i+1:end)*x(i+1:end)) / R(i,i);
    end
end
