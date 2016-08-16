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

fH = figure('Color',[1 1 1]);
[foc, foh] = contourf(Rmat.*cos(Theta)*1e3,Rmat.*sin(Theta)*1e3,-Hmat*1e3); hold on;
set(foh, 'LineWidth', 1);
view(-90,90);
caxis('auto');
%caxis([-5 5]);
M = max(abs(max(max(Hmat*1e3))),abs(min(min(Hmat*1e3))));
M = ceil(1.01*M*10)/10;
axis([0 20 -6.5 6.5 -M 0]);
set(gca,'FontSize',22);
set(gca,'LineWidth',1);
xlabel('X[mm]','FontSize',22);
ylabel('Y[mm]','FontSize',22);
zlabel('-h[mm]','FontSize',22);
cb = colorbar('Location','west','FontSize',22);
colormap(cm);
ct = title(cb,'-h[mm]','FontSize',22);
if verLessThan('matlab','8.4')
    set(cb,'Position',[0.144 0.129 0.0466 0.2738]); % R2014b Mac
    set(ct,'Position',[3.875 1.275 1.000]); % R2014b Mac
else
    set(cb,'Position',[0.1673 0.129 0.0466 0.2738]); % R2016a Mac
    set(cb,'AxisLocation','in'); % R2016a Mac
    set(ct,'Position',[33.875 166.72 0]); % R2016a Mac
end
Ndimfig=30;
Wdimfig=429;
Hdimfig=568;
set(fH,'Position',[850 396 Wdimfig Hdimfig]);
set(fH,'PaperUnits','centimeter');
set(fH,'PaperSize',[Wdimfig/Ndimfig,Hdimfig/Ndimfig]);
set(fH,'PaperPosition',[0,0,Wdimfig/Ndimfig,Hdimfig/Ndimfig]);
%
disp(strcat('-Hmin',num2str(min(min(-Hmat*1e3))),'-Hmax',num2str(max(max(-Hmat*1e3)))));
