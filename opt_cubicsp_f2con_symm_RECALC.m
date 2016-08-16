%====================================================================================%
% "Enhancing Full-Film Lubrication Performance via Arbitrary Surface Texture Design" %
% Authors:                                                                           %
% Yong Hoon Lee*, Jonathon K. Schuh, Randy H. Ewoldt, James T. Allison               %
% * E-mail: ylee196@illinois.edu                                                     %
% Licensed under CC BY-SA 4.0                                                        %
% -- Description: https://creativecommons.org/licenses/by-sa/4.0/                    %
% -- Legal code:  https://creativecommons.org/licenses/by-sa/4.0/legalcode           %
%====================================================================================%
% SUBROUTINE/FUNCTION/SCRIPT - DO NOT RUN DIRECTLY                                   %
%====================================================================================%
wei1 = 0.8;
wei2 = (1 - wei1)/2;

for j = 1:length(iarr)
    i = iarr(j);
    if (i == ni)
        x0 = (wei1 * xopt_i(:,i-1) + 2 * wei2 * xopt_i(:,i));
    elseif (i == 1)
        x0 = (wei1 * xopt_i(:,i+1) + 2 * wei2 * xopt_i(:,i));
    else
        x0 = (wei1 * xopt_i(:,i+1) + wei2 * (xopt_i(:,i-1) + xopt_i(:,i)));
    end
    opt_cubicsp_f2con_symm_optscript;
end
