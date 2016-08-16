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
currentpath = pwd;
if ispc
    dirsep = '\';
elseif isunix
    dirsep = '/';
end
path(path,strcat(currentpath, dirsep, 'Solver'));
path(path,strcat(currentpath, dirsep, 'Utility'));
path(path,strcat(currentpath, dirsep, 'Library', dirsep, 'Colormaps'));
path(path,strcat(currentpath, dirsep, 'Library', dirsep, 'export_fig'));
