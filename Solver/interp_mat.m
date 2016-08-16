%======================================================================================================%
% "A validated computational model for the design of surface textures in full-film lubricated sliding" %
% Authors:                                                                                             %
% Jonathon K. Schuh, Yong Hoon Lee, James T. Allison, Randy H. Ewoldt                                  %
% * E-mail: schuh4@illinois.edu                                                                        %
% Licensing terms and conditions should be discussed with the lead author of this code                 %
%======================================================================================================%
function[Jh] =  interp_mat(xo,xi)
% Compute the interpolation matrix from xi to xo using
% Bengt Fornberg's interpolation algorithm, fd_weights_full.
    no = length(xo);
    ni = length(xi);
    Jh = zeros(ni, no);
    w  = zeros(ni, 2);
    for i=1:no;
        w = fd_weights_full(xo(i), xi, 1);
        Jh(:,i) = w(:,1);
    end
    Jh = Jh';
end