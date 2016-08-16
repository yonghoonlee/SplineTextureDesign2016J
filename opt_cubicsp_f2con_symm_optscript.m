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
%% Objective
p.obj = objectivetype;
p.neg_f2_max = neg_f2_max(i);

%% Optimization using Interior Point algorithm
A = []; b = []; Aeq = []; beq = []; nonlcon = [];
[A, b] = opt_cubicsp_f2con_LinConstraintIneq(p);
lb = p.xmin * ones(size(x0));
ub = p.xmax * ones(size(x0));
options = optimoptions('fmincon', 'Algorithm', 'interior-point', ...
    'Display', 'iter', ...
    'TolX', 1e-8, 'TolFun', 1e-6, 'TolCon', 1e-6, 'MaxIter', 500, ...
    'FinDiffType', 'central', 'UseParallel', true,...
    'MaxFunEvals',Inf);
tic;
[xopt,fopt,exflag,out,lamb,grad,hess] ...
    = opt_cubicsp_f2con_symm_fmincon(x0,A,b,Aeq,beq,lb,ub,options,p);
time_ip = toc;

%% Save result
xopt_i(:,i) = xopt;
xtmp = reshape(xopt,p.nxr,p.nxt);
if (mod(p.nxr,2) == 0)
    Htmp = [xtmp, fliplr(xtmp)];
else
    Htmp = [xtmp, fliplr(xtmp(:,1:end-1))];
end
Hopt = interp2(p.TR,p.RR,Htmp,p.T,p.R,'spline');
Hopt(Hopt<p.Hmin) = p.Hmin;
Hopt(Hopt>p.Hmax) = p.Hmax;
p.b2 = computeSOF_b2(Hopt, p);
[fopt_i(1,i),fopt_i(2,i),fopt_i(3,i)] ...
    = Reynolds_Tex(Hopt, p);
fopt_i(2,i) = -fopt_i(2,i); % negative F_N
exitflag{i} = exflag;
output{i} = out;
lambda{i} = lamb;
gradient{i} = grad;
hessian{i} = hess;
timeT{i} = time_ip;
