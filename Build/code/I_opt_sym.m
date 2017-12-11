function [I_opt_sym] = I_opt_sym(P, I, adj, delta_tau, delta_I, beta, gamma)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

kappa = gamma*(1+beta)^(-(1+beta)/beta);

J = size(P, 1);
N = size(P, 2);


P_transform = reshape(P, [J, 1, N]);

for n=1:N
   P_n = P_transform(:,:,n);
   
   inner_bracket_sliced_1(:,:,n) = (max(zeros(J), transpose(P_n * transpose(P_n.^-1)) -1).^((1+beta)/beta)) .* P_n .* (delta_tau).^(-1/beta);
   inner_bracket_sliced_2(:,:,n) = (max(zeros(J), (P_n .* transpose(P_n.^-1)) -1).^((1+beta)/beta)) .* transpose(P_n) .* transpose((delta_tau).^(-1/beta));

end


inner_bracket = (sum(inner_bracket_sliced_1, 3) + sum(inner_bracket_sliced_2, 3)) .* adj;


% Obtain the multiplier

% mu = sum(sum((((kappa .* inner_bracket .* ((delta_tau).^(-1/beta))).^(beta/(gamma-beta))) .* (delta_I.^(gamma/(beta-gamma)))), 1, 'omitnan'), 2, 'omitnan').^((gamma-beta)/beta);


% Obtain I_opt

I_raw = ((kappa .* (delta_I + transpose(delta_I)).^(-1)) .* inner_bracket).^(beta/(beta-gamma));
I_raw(isnan(I_raw)) = 0;

mu = 1/sum(sum(I_raw .* delta_I));

I_opt_sym = I_raw * mu;


end

