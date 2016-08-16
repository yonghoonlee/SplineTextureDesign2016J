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
[xopt1,fopt1,exflag1,out1,lamb1,grad1,hess1] ...
    = opt_cubicsp_f2con_fmincon(x0,A,b,Aeq,beq,lb,ub,nonlcon,options,p);
time_ip1 = toc;

%% Retry with minimum gap height for infeasible points
exflag2 = 100;
if (exflag1 < 0) % try with x0 = p.Hmin
    x0 = p.Hmin * ones(size(x0));
    tic;
    [xopt2,fopt2,exflag2,out2,lamb2,grad2,hess2] ...
        = opt_cubicsp_f2con_fmincon(x0,A,b,Aeq,beq,lb,ub,nonlcon,options,p);
    time_ip2 = toc;
end

%% Retry with maximum gap height for infeasible points
exflag3 = 100;
if ((exflag1 < 0) && (exflag2 < 0)) % try with x0 = p.Hmax
    x0 = p.Hmax * ones(size(x0));
    tic;
    [xopt3,fopt3,exflag3,out3,lamb3,grad3,hess3] ...
        = opt_cubicsp_f2con_fmincon(x0,A,b,Aeq,beq,lb,ub,nonlcon,options,p);
    time_ip3 = toc;
end

%% Compare exit flags
if (exflag1 >= 0)
    inx = 1;
elseif (exflag2 >= 0)
    inx = 2;
elseif (exflag3 >= 0)
    inx = 3;
else
    lamb1sum = sum((lamb1.ineqlin).^2) + sum((lamb1.ineqnonlin).^2);
    lamb2sum = sum((lamb2.ineqlin).^2) + sum((lamb2.ineqnonlin).^2);
    lamb3sum = sum((lamb3.ineqlin).^2) + sum((lamb3.ineqnonlin).^2);
    [~,inx] = min([lamb1sum, lamb2sum, lamb3sum]);
end

%% Output
if (inx == 1)
    xopt = xopt1;
    exflag = exflag1;
    out = out1;
    lamb = lamb1;
    grad = grad1;
    hess = hess1;
    time_ip = time_ip1;
elseif (inx == 2)
    xopt = xopt2;
    exflag = exflag2;
    out = out2;
    lamb = lamb2;
    grad = grad2;
    hess = hess2;
    time_ip = time_ip2;
elseif (inx == 3)
    xopt = xopt3;
    exflag = exflag3;
    out = out3;
    lamb = lamb3;
    grad = grad3;
    hess = hess3;
    time_ip = time_ip3;
end

%% Save result
xopt_i(:,i) = xopt;
xtmp = reshape(xopt,p.nxr,p.nxt);
Htmp = [xtmp, xtmp(:,1)];
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
