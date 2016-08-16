%======================================================================================================%
% "A validated computational model for the design of surface textures in full-film lubricated sliding" %
% Authors:                                                                                             %
% Jonathon K. Schuh, Yong Hoon Lee, James T. Allison, Randy H. Ewoldt                                  %
% * E-mail: schuh4@illinois.edu                                                                        %
% Licensing terms and conditions should be discussed with the lead author of this code                 %
%======================================================================================================%
function [Dh] = dhat(x)
% Compute the interpolatory derivative matrix D_ij associated
% with nodes x_j such that
%     ^
% w = D*u   
% -     -
% returns the derivative of u at the points x_i.
    n1 = length(x);
    w = zeros(n1, 2);
    Dh = zeros(n1, n1);
    for i = 1:n1;
        w = fd_weights_full(x(i), x,1); % Bengt Fornberg's interpolation algorithm
        Dh(:, i) = w(:, 2); % Derivative of pn is stored in column 2.
    end
    Dh = Dh';
end