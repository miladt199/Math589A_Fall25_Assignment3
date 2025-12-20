function best = select_model(y, s, Ngrid, Kgrid, criterion)
%SELECT_MODEL  Return struct used by grade.m (must contain .N .K .coef .score)

    if nargin < 5 || isempty(criterion)
        criterion = 'bic';
    end

    % IMPORTANT FIX: initialize with required fields so best.N doesn't crash
    best = struct();
    best.score = Inf;
    best.N = NaN;
    best.K = NaN;
    best.s = s;
    best.criterion = criterion;
    best.beta = [];
    best.coef = struct('c',NaN,'d',NaN,'a',[],'alpha',[],'beta',[]);
    best.RSS = NaN;
    best.M = NaN;
    best.p = NaN;
    best.res = [];

    found = false;

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
                found = true;
            end
        end
    end

    if ~found
        error('select_model:NoValidModel', ...
              'No valid (N,K) in the provided grids for this data length.');
    end
end
