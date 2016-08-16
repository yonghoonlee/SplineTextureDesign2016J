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
restoredefaultpath;
header;

filename = 'opt_cubicsp_f2con_N05_NF_optimal.mat';
load(filename);

for i = 1:ni
    xopt = xopt_i(:,i);
    xtmp = reshape(xopt,p.nxr,p.nxt);
    Htmp = [xtmp, xtmp(:,1)];
    Hopt = interp2(p.TR,p.RR,Htmp,p.T,p.R,'spline');
    Hopt(Hopt<p.Hmin) = p.Hmin;
    Hopt(Hopt>p.Hmax) = p.Hmax;
    p.b2 = computeSOF_b2(Hopt, p);
    disp(strcat('case ',num2str(i)));
    [fopt_i(1,i),fopt_i(2,i),fopt_i(3,i)] ...
        = Reynolds_Tex(Hopt, p, 'plot');
    fopt_i(2,i) = -fopt_i(2,i); % negative F_N
    close all;
end