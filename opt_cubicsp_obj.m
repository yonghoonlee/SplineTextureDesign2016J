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
function [f,H,HR] = opt_cubicsp_obj(x,p)
    xin = reshape(x,p.nxr,p.nxt);
    HR = [xin, xin(:,1)];
    H = interp2(p.TR,p.RR,HR,p.T,p.R,'spline');

    % Constraint Hmin < H < Hmax
    H(H<p.Hmin) = p.Hmin;
    H(H>p.Hmax) = p.Hmax;
    
    % Simulation
    p.b2 = computeSOF_b2(H,p);
    [f1,f2,f3] = Reynolds_Tex(H,p);
    
    % Compute/determine objective function
    if (p.obj == 1)
        f = f1;
    elseif (p.obj == 2)
        f = -f2;
    elseif (p.obj == 3)
        f = f3;
    elseif (p.obj == 4)
        f = p.w * f1 + (1 - p.w) * (-f2);
    elseif (p.obj == 12)
        f = [f1, -f2];
    elseif (p.obj == 123)
        f = [f1, -f2, f3];
    end
end