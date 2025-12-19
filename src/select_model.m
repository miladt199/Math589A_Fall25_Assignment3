function best = select_model(y, s, Ngrid, Kgrid, criterion)
%SELECT_MODEL  Return struct used by grade.m (must contain .N .K .coef .score)

    best = struct('score', Inf);

    for N = Ngrid(:).'
        for K = Kgrid(:).'
            try
                fit = fit_once(y, s, N, K);
            catch
                continue
            end

            S = score_model(fit.RSS, fit.M, fit.p, criterion);

            if S < best.score
                best = fit;
                best.score = S;
                best.criterion = criterion;
            end
        end
    end
end
