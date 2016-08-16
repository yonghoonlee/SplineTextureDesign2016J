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

fP = figure('Color',[1 1 1]);
[foc, foh] = contourf(Rmat.*cos(Theta)*1e3,Rmat.*sin(Theta)*1e3,P*1e-3); hold on;
set(foh, 'LineWidth', 1);
view(-90,90);
caxis('auto');
%caxis([-5 5]);
M = max(abs(max(max(P*1e-3))),abs(min(min(P*1e-3))));
M = ceil(1.01*M*10)/10;
axis([0 20 -6.5 6.5 -M M]);
set(gca,'FontSize',22);
set(gca,'LineWidth',1);
xlabel('X[mm]','FontSize',22);
ylabel('Y[mm]','FontSize',22);
zlabel('P[kPa]','FontSize',22);
cb = colorbar('Location','west','FontSize',22);
colormap(cm);
ct = title(cb,'P[kPa]','FontSize',22);
if verLessThan('matlab','8.4')
    set(cb,'Position',[0.144 0.129 0.0466 0.2738]); % R2014b Mac
    set(ct,'Position',[3.875 9.275 1.000]); % R2014b Mac
else
    set(cb,'Position',[0.1673 0.129 0.0466 0.2738]); % R2016a Mac
    set(cb,'AxisLocation','in'); % R2016a Mac
    set(ct,'Position',[33.875 166.72 0]); % R2016a Mac
end
Ndimfig=30;
Wdimfig=429;
Hdimfig=568;
set(fP,'Position',[750 396 Wdimfig Hdimfig]);
set(fP,'PaperUnits','centimeter');
set(fP,'PaperSize',[Wdimfig/Ndimfig,Hdimfig/Ndimfig]);
set(fP,'PaperPosition',[0,0,Wdimfig/Ndimfig,Hdimfig/Ndimfig]);
%
[ffc,ffh] = contour(Rmat.*cos(Theta)*1e3,Rmat.*sin(Theta)*1e3,P*1e-3); hold on;
set(ffh, 'LevelListMode', 'manual');
set(ffh, 'LevelList', [0]);
set(ffh, 'LineColor', [0 0 0]);
set(ffh, 'LineWidth', 3.5);
%
disp(strcat('Pmin',num2str(min(min(P*1e-3))),'Pmax',num2str(max(max(P*1e-3)))));
