%======================================================================================================%
% "A validated computational model for the design of surface textures in full-film lubricated sliding" %
% Authors:                                                                                             %
% Jonathon K. Schuh, Yong Hoon Lee, James T. Allison, Randy H. Ewoldt                                  %
% * E-mail: schuh4@illinois.edu                                                                        %
% Licensing terms and conditions should be discussed with the lead author of this code                 %
%======================================================================================================%
function [tstar, Fn, mu] = Reynolds_Tex(H, opt, varargin)
    
    R1 = opt.R1;        % Inner radius [0.01e-3]
    R2 = opt.R2;        % Outer radius [20e-3]
    phi = opt.phi;      % Angle of sector [2 * pi / 10]
    h0 = opt.h0;        % Nominal gap distance [0.25e-3 + 19e-6]
    Omega = opt.Omega;  % Angular velocity [10]
    b1 = opt.b1;        % Viscosity [1.4]
    b2 = opt.b2;        % Second-order fluid parameter, [0]
    Ntex = 2*pi/phi;    % Number of periodic sectors, [10]
    N = size(H,1)-1;    % Polynomial order, [25]
    
    % Create the 1-D matrices for the psuedo-spectral method
    
    Kh = zeros(N+1);
    Mh = zeros(N+1);
    Ch = zeros(N+1);
    Dh = zeros(N+1);
    z = zeros(N+1,1);
    w = zeros(N+1,1);
    [Kh,Mh,Ch,Dh,z,w] = semhat(N);
    
    q = zeros(1,N);
    q(N) = 1;
    Q = [q; eye(N)];
    
    I = eye(N+1);
    Res = I(2:N,:);
    Pro = Res';
    
    Nuem = I(1:N,:)';
    r = (R2-R1)/2*(z) + (R2+R1)/2;
    theta = phi/2*(z);
    [Rmat,Theta] = ndgrid(r,theta);
    Rdiff = R2 - R1;
    
    R1d = diag(r);
    R = kron(I,R1d);
    Rinv1d = diag(1./r);
    Rinv = kron(I,Rinv1d);
    
    dhdz = H*Dh';
    Hmat = H;
    
    dh = zeros((N+1)^2,1);
    h = zeros((N+1)^2,1);
    dh = reshape(dhdz,numel(dhdz),1);
    h = reshape(H,numel(H),1);
    
    % Create the 2-D matrices used for solving the Reynolds equation
    
    H = diag(h.^3);
    Kb = -phi/Rdiff*(kron(I,Dh))'*(kron(Mh,Mh)*R*H)*kron(I,Dh)...
        - Rdiff/phi*(kron(Dh,I))'*(kron(Mh,Mh)*H*Rinv)*kron(Dh,I);
    fb=3*b1*Rdiff*Omega*kron(Mh,Mh)*R*dh;
    
    K = (kron(Q,I))'*Kb*kron(Q,I);
    f = kron(Q,I)'*fb;
    
    % Solve for the Newtonian pressure
    
    p = pinv(K)*f;
    
    % Create the Newtonian Pressure matrix
    
    Pn = zeros(N+1,N);
    for j = 1:N,
        for i = 1:N+1,
            Pn(i,j) = p((i) + (j-1)*(N+1));
        end
    end
    Pn = I*Pn*Q';
    PN = Pn;
    
    Pr0 = PN(N+1,:)';
    Pref = -Pr0(floor(N/2 + 1));
    PN = PN + Pref*ones(N+1);
    
    Pr0 = PN(N+1,:)';
    Pref = -1/2*(Pr0'*w);
    PN = PN + Pref*ones(N+1);
    
    % Calculate the Non-Newtonian Pressure matrix
    
    P = PN+b2./b1.*Omega.*(2/phi*PN*Dh')+b2./2*((1./(2*b1).*(2/Rdiff*Dh*PN).*Hmat)^2+...
        (1./(2*b1.*Rmat).*(2/phi*PN*Dh').*Hmat).^2+(Omega*Rmat./Hmat)^2+...
        Omega/b1*(2/phi*PN*Dh'));
    
    % Calculate tauzz
    
    tauzz = b2*((1./(2*b1).*(2/Rdiff*Dh*PN).*Hmat)^2 + ...
        (1./(2*b1.*Rmat).*(2/phi*PN*Dh').*Hmat).^2 + (Omega*Rmat./Hmat)^2 + ...
        Omega/b1*(2/phi*PN*Dh'));
    
    % Compute Normal Force
    
    Fn = Ntex*(Rdiff*phi/4*w'*(R1d'*(P-tauzz))*w);
    
    % Compute torque and viscosity
    
    tau = -(-1./(2*Rmat).*(2/phi*PN*Dh').*Hmat-b1.*Rmat.*Omega./(Hmat) - ...
        b2.*Omega./(2*b1.*Rmat).*(2/phi*(2/phi*PN*Dh')*Dh').*Hmat + ...
        b2.*Rmat.*Omega^2./(Hmat.^2).*(2/phi*Hmat*Dh'));
    M = Ntex*(Rdiff*phi/4*w'*(R1d'.^2*tau)*w);
    tstar = (2/(pi*R2^3)*M)/(b1*(Omega*R2)/h0);
    
    % Compute effective friction coefficient
    
    mu = (M/R2)/Fn;
    
    % PLOT
    
    if (nargin >= 3) && (strcmp(varargin{1},'plot'))
        plot_P_Tau_H;
    end
    
end