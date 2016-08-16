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
function b2 = computeSOF_b2(H,p)
    if (~isfield(p,'Wi') && isfield(p,'b2'))
        b2 = p.b2;
    elseif (isfield(p,'Wi'))
        w = p.w;
        phi = p.phi;
        Wi = p.Wi;
        b1 = p.b1;
        R = p.R;
        Omega = p.Omega;
        Rdiff = p.Rdiff;
        % Compute b2
        b2 = -Wi.*b1./(R.*Omega./H);
        A = zeros(size(H));
        for i = 1:length(w)
            for j = 1:length(w)
                A(i,j) = Rdiff * w(i) * R(i,1) * phi * w(j) / 4;
            end
        end
        b2 = sum(sum(b2.*A))/sum(sum(A));
    elseif (~isfield(p,'b2') && ~isfield(p,'Wi'))
        error('error, please define b2 or Wi');
    end
end