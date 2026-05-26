function [vol] = model_volatility(T,K_norm,V,Lt,Lh,K_min,K_max,Scheme)
% Compute model implied volatility of a local volatility model
% T.. LV expiries, K_norm.. LV strikes, V.. LV matrix
% Lt,Lh,K_min,K_max,Scheme.. settings for the Dupire solver
%
% vol(i,j).. model implied volatility at time T(i) and strike K_norm(i,j) 

[rows, cols] = size(K_norm);
vol = zeros(rows,cols);


expiry = T(end);
[ k, t, C] = solve_dupire( T, K_norm, V, expiry, Lt, Lh, K_min, K_max, Scheme);

for idx = 1:length(T)
    
    price = interp2(t, k, C, T(idx), K_norm(:,idx));
    vol(:,idx) = blsimpv(1,K_norm(:,idx),0,T(idx),price);
end


end


