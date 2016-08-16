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
function [x,f,exitflag,output,lambda,grad,hessian] ...
    = opt_cubicsp_f2con_symm_fmincon(x0,A,b,Aeq,beq,lb,ub,opts,p)
    xLast = []; % Last place computeall was called
    myf = []; % Use for objective at xLast
    myc = []; % Use for nonlinear inequality constraint
    myceq = []; % Use for nonlinear equality constraint
    fun = @(x) objfun(x,p); % the objective function, nested below
    cfun = @(x) constr(x,p); % the constraint function, nested below
    [x,f,exitflag,output,lambda,grad,hessian] ...
        = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,cfun,opts);
    % Nested functions
    % Objectives
    function y = objfun(x,p)
        if ~isequal(x,xLast) % Check if computation is necessary
            [myf,myc,myceq] = computeall(x,p);
            xLast = x;
        end
        y = myf;
    end
    % Constraints
    function [c,ceq] = constr(x,p)
        if ~isequal(x,xLast) % Check if computation is necessary
            [myf,myc,myceq] = computeall(x,p);
            xLast = x;
        end
        c = myc;
        ceq = myceq;
    end
    % Run actual simulations
    function [f,c,ceq] = computeall(x,p)
        [fvec,~,HR] = opt_cubicsp_symm_obj(x,p);
        f = fvec(1);
        c = fvec(2) - p.neg_f2_max;
        ceq = [];
    end
end
