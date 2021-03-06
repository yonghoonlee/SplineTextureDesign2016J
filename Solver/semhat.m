%======================================================================================================%
% "A validated computational model for the design of surface textures in full-film lubricated sliding" %
% Authors:                                                                                             %
% Jonathon K. Schuh, Yong Hoon Lee, James T. Allison, Randy H. Ewoldt                                  %
% * E-mail: schuh4@illinois.edu                                                                        %
% Licensing terms and conditions should be discussed with the lead author of this code                 %
%======================================================================================================%
function [Ah, Bh, Ch, Dh, z, w] = semhat(N)
% Compute the single element 1D SEM stiffness, mass, and convection
% matrices, as well as the points and weights for a polynomial of degree N on [-1:1]
    [z,w] = zwgll(N);   %  z = [z0,z1,...,zN] Gauss-Lobatto points 
                        %  w = [w0,w1,...,wN] Gauss-Lobatto weights
    Bh = diag(w);    %  1-D mass matrix
    Dh = dhat(z);    %  1-D derivative matrix
    Ah = Dh'*Bh*Dh;  %  1-D stiffness matrix
    Ch = Bh*Dh;      %  1-D convection operator
end