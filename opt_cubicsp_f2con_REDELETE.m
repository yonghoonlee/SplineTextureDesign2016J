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
clear iarr;
iarr = ones(size(neg_f2_max));
for i = 1:length(idel)
    iarr(idel(i)) = 0;
end

tmp_neg_f2_max = neg_f2_max;
tmp_xopt_i = xopt_i;
tmp_fopt_i = fopt_i;
tmp_exitflag = exitflag;
tmp_output = output;
tmp_lambda = lambda;
tmp_gradient = gradient;
tmp_hessian = hessian;
tmp_timeT = timeT;
neg_f2_max = [];
xopt_i = [];
fopt_i = [];
clear exitflag;
clear output;
clear lambda;
clear gradient;
clear hessian;
clear timeT;

j = 0;
for i = 1:length(iarr)
    if (iarr(i) == 1)
        j = j + 1;
        neg_f2_max = [neg_f2_max, tmp_neg_f2_max(i)];
        xopt_i = [xopt_i, tmp_xopt_i(:,i)];
        fopt_i = [fopt_i, tmp_fopt_i(:,i)];
        exitflag{j} = tmp_exitflag(i);
        output{j} = tmp_output{i};
        lambda{j} = tmp_lambda{i};
        gradient{j} = tmp_gradient{i};
        hessian{j} = tmp_hessian{i};
        timeT{j} = tmp_timeT{i};
    end
end
ni = length(neg_f2_max);

clear tmp_xopt_i;
clear tmp_fopt_i;
clear tmp_exitflag;
clear tmp_output;
clear tmp_lambda;
clear tmp_gradient;
clear tmp_hessian;
clear tmp_timeT;

