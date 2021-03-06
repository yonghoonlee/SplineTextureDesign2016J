%====================================================================================%
% "Enhancing Full-Film Lubrication Performance via Arbitrary Surface Texture Design" %
% Authors:                                                                           %
% Yong Hoon Lee*, Jonathon K. Schuh, Randy H. Ewoldt, James T. Allison               %
% * E-mail: ylee196@illinois.edu                                                     %
% Licensed under CC BY-SA 4.0                                                        %
% -- Description: https://creativecommons.org/licenses/by-sa/4.0/                    %
% -- Legal code:  https://creativecommons.org/licenses/by-sa/4.0/legalcode           %
%====================================================================================%
% OPTIMIZATION CODE FOR SPLINE PARAMETERIZATION WITH ASYMMETRIC CONTINUOUS SURFACE   %
%====================================================================================%

restoredefaultpath;
header; % Clear memory, Add paths
filename = 'opt_cubicsp_f2con_N05_NF'; % Case filename
try
    ppool = parpool;
catch
    ppool = gcp;
end
disp('Parallel pool information:');
disp(ppool);

%% Parameter
p.N = 25;               % Polynomial dimension
p.NR = 5;               % Reduced parameter dimension
p.R1 = 0.01e-3;         % Disc inner radius
p.R2 = 20e-3;           % Disc outer radius
p.phi = 2 * pi / 10;    % Disc sector angle
p.Hmin = 0.25e-3+19e-6; % Minimum gap distance, 0.269 [mm]
p.Hmax = 1.5e-3;        % Maximum gap distance, 1.500 [mm]
p.Omega = 10;           % Angular velocity
p.b1 = 1.4;             % Viscosity
p.b2 = 0;               % Second-order fluid parameter
                        % (Note, Newtonian Fluid (NF) with b2=0, Wi=0)
% p.Wi = 0.1;           % Weissenberg number
p.LocalSlopeMax = 30;   % Maximum Local Slope

%% Derived parameters
p.Rdiff = p.R2 - p.R1;  % Difference in inner and outer radii
p.h0 = p.Hmin;          % Nominal gap
p.xmin = 1/1.01*p.Hmin;  % Control point minimum range
p.xmax = 1.01*p.Hmax;    % Control point maximum range

%% Coarse mesh information
[zR,wR] = zwgll(p.NR);  % z and w for reduced mesh space
rR = (p.R2 - p.R1)/2*zR + (p.R2 + p.R1)/2;
tR = p.phi/2*zR;
[RR,TR] = ndgrid(rR,tR);
[nxr,nxt] = size(RR);
nxt = nxt - 1;

%% Fine mesh information
[z,w]=zwgll(p.N);       % z and w for full mesh space
r = (p.R2 - p.R1)/2*z + (p.R2 + p.R1)/2;
t = p.phi/2*z;
[R,T] = ndgrid(r,t);

%% Constraints
X = RR.*cos(TR);
Y = RR.*sin(TR);
dX1 = sqrt(diff(X,1).^2 + diff(Y,1).^2);
dX2 = sqrt(diff(X,2).^2 + diff(Y,2).^2);

%% Save parameters
p.R = R;                % R matrix
p.T = T;                % Theta matrix
p.dX1 = dX1;            % row-direction distance between nodes
p.dX2 = dX2;            % column-direction distance between nodes
p.RR = RR;              % Reduced R matrix
p.TR = TR;              % Reduced Theta matrix
p.nxr = nxr;            % number of reduced r nodes
p.nxt = nxt;            % number of reduced theta nodes
p.w = w;                % collocation points for pseudospectral method

%% Multiobjective optimization preparation
neg_f2_max = [0:-0.25:-7];
ni = length(neg_f2_max);
xopt_i = zeros(nxr*nxt,ni);
fopt_i = zeros(3,ni);
objectivetype = 12;

%% Initial guess
x0 = p.Hmin * ones(nxr,nxt);
x0 = reshape(x0, numel(x0), 1);

%% Main loop
for i = 1:ni
    disp(strcat('Compute:',num2str(i),'/',num2str(ni)));
    opt_cubicsp_f2con_optscript
    % Initial guess for the next computation is a half way of current optimum
    x0 = (xopt + p.Hmin * ones(size(xopt))) / 2;
end

%% Recalculate wrong solutions with new initial values
iarr_idx = zeros(size(neg_f2_max));
for i = 1:size(iarr_idx,2)-1
   if (fopt_i(1,i) > fopt_i(1,i+1))
       iarr_idx(i) = 1;
   end
end
for i = 1:size(iarr_idx,2)
    if (exitflag{i} < 0)
        iarr_idx(i) = 1;
    end
end
iarr = [];
for i = size(iarr_idx,2):-1:1
    if (iarr_idx(i) == 1)
        iarr = [iarr, i];
    end
end
opt_cubicsp_f2con_RECALC;

%% Delete infeasible or non-optimal points
iarr_idx = zeros(size(neg_f2_max));
for i = size(iarr_idx,2):-1:1
    for j = 1:size(iarr_idx,2)
        if (i ~= j) 
            if (fopt_i(1,i) > fopt_i(1,j)) 
                if (fopt_i(2,i) > fopt_i(2,j))
                    iarr_idx(i) = 1;
                end
            end
        end
    end
end
for i = 1:size(iarr_idx,2)
    if (exitflag{i} < 0)
        iarr_idx(i) = 1;
    end
end
idel = [];
for i = 1:size(iarr_idx,2)
    if (iarr_idx(i) == 1)
        idel = [idel, i];
    end
end
opt_cubicsp_f2con_REDELETE;

%% Save result
save(strcat(filename,'_optimal.mat'));

%% Post processing
restoredefaultpath;
header_path;
post.exportfig = true;      % export to file
post.exporttype = 'dpdf';   % export file type: dpdf, depsc
post.cm = parula_def();     % colormap
postplot;
