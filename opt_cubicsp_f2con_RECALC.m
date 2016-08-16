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
wei1 = 0.5;
wei2 = (1 - wei1)/2;

for j = 1:length(iarr)
    i = iarr(j);
    x0 = p.Hmin * ones(size(xopt_i(:,1)));
    if (i == ni)
        x0 = (wei1 * xopt_i(:,i-1) + 2 * wei2 * x0);
    elseif (i == 1)
        x0 = (wei1 * xopt_i(:,i+1) + 2 * wei2 * x0);
    else
        x0 = (wei2 * xopt_i(:,i+1) + wei1 * x0 + wei2 * xopt_i(:,i-1));
    end
    opt_cubicsp_f2con_optscript;
    % Still not resolved, do it from the solution of the next point
    if ((exflag < 0) && (i ~= 1) && (i~= ni))
        x0 = xopt_i(:,i+1);
        opt_cubicsp_f2con_optscript;
    end
end
