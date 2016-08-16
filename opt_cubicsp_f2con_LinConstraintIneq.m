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
function [A, b] = opt_cubicsp_f2con_LinConstraintIneq(p)

    nxr = p.nxr;
    nxt = p.nxt;

    pts = [];
    for j = 1:nxt
        for i = 1:nxr-1
            pts = [pts; (i+(j-1)*nxr), (i+1+(j-1)*nxr)];
        end
    end
    for j = 1:nxt-1
        for i = 1:nxr
            pts = [pts; i+(j-1)*nxr, i+(j-1)*nxr+nxr];
        end
    end
    for j = 1:nxr
        pts = [pts; nxr*(nxt-1)+j, j];
    end
    
    dist = [];
    RR = reshape(p.RR, numel(p.RR), 1);
    TR = reshape(p.TR, numel(p.TR), 1);
    for i = 1:size(pts,1)
        idx1 = pts(i,1);
        idx2 = pts(i,2);
        x1 = RR(idx1) * cos(TR(idx1));
        y1 = RR(idx1) * sin(TR(idx1));
        x2 = RR(idx2) * cos(TR(idx2));
        y2 = RR(idx2) * sin(TR(idx2));
        dist = [dist; sqrt((x2-x1)^2 + (y2-y1)^2)];
    end
    
    A = [];
    b = [];
    for i = 1:size(pts,1)
        lvec1 = zeros(1,nxr*nxt);
        lvec2 = zeros(1,nxr*nxt);
        idx1 = pts(i,1);
        idx2 = pts(i,2);
        lvec1(idx1) = 1;
        lvec1(idx2) = -1;
        lvec2(idx1) = -1;
        lvec2(idx2) = 1;
        lvec1 = lvec1 / dist(i);
        lvec2 = lvec2 / dist(i);
        A = [A; lvec1; lvec2];
        b = [b; tan(p.LocalSlopeMax*pi/180); tan(p.LocalSlopeMax*pi/180)];
    end
    
end