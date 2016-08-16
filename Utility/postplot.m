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

%% P, Tau, H contours

close all;

hf = figure('Color',[1 1 1]);
ilist = 1:ni; % ilist = [4 8 12 16 20 24];
llist = length(ilist);
for j = 1:llist
    i = ilist(j);
    close all;
    xtmp = reshape(xopt_i(:,i),nxr,nxt);
    Htmp = [xtmp, xtmp(:,1)];
    Htmp = interp2(p.TR,p.RR,Htmp,p.T,p.R,'spline');
    Htmp(Htmp<p.Hmin) = p.Hmin;
    Htmp(Htmp>p.Hmax) = p.Hmax;
    disp(i);
    post.pname = strcat('contourP_',num2str(i));
    post.tname = strcat('contourTau_',num2str(i));
    post.hname = strcat('contourH_',num2str(i));
    post.lname = strcat('contourLM_',num2str(i));
    cx.pax = [-5.09, 0, 5, 9.87];
    cx.tax = [-0.256 0 0.4 0.8 1.21];
    cx.hax = [-1.5 -1 -0.5 -0.269];
    Reynolds_Tex(Htmp,p,'plot',cx,post);    % Plot P, Tau, H
    pltLAGMULT;                             % Plot Lagrange Multiplier
    drawnow;
    if (post.exportfig == true)
        % eval(['export_fig ',currentpath,dirsep,'Figures',dirsep,post.lname,' ',strcat('-', post.exporttype)]);
        print(strcat(currentpath,dirsep,'Figures',dirsep,post.lname),strcat('-',post.exporttype));
    end
    disp('plot done');
end

%% Pareto set plots

hf = figure('Color',[1 1 1]);
plot(fopt_i(1,:),fopt_i(2,:),'ko','LineWidth',2,'MarkerSize',10);
xlabel('\tau*');
ylabel('-F_N');
title('objective space');
figtitle = 'ParetoSet';
figfilename = strcat(currentpath,dirsep,'Figures',dirsep,filename,'_',figtitle);
if (post.exportfig == true)
    print(figfilename,strcat('-',post.exporttype));
end



