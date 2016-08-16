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

F = lambda{i}.ineqlin;

nxr = p.nxr;
nxt = p.nxt;
FF = zeros(nxr,nxt+1);
FF = reshape(FF,numel(FF),1);

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

Fa = zeros(size(pts,1),1);
Fb = zeros(size(pts,1),1);
Ft = zeros(size(pts,1),1);
for i = 1:size(pts,1)
    Fa(i) = F(2*i-1);
    Fb(i) = F(2*i);
    Ft(i) = max(abs(Fa(i)),abs(Fb(i)));
end

for i = 1:size(pts,1)
    idx1 = pts(i,1);
    idx2 = pts(i,2);
    if (nxr*(nxt-1)+idx2 == idx1)
        idx2 = idx2 + nxr*nxt;
    end
    FF(idx1) = FF(idx1) + 0.25*Ft(i);
    FF(idx2) = FF(idx2) + 0.25*Ft(i);
end

FF = reshape(FF,nxr,nxt+1);
FFN = zeros(p.N+1,p.N+1);
FFN = interp2(TR,RR,FF,T,R,'spline');
FFN(FFN<0) = 0;

fLag = figure('Color',[1 1 1]);
[foc, foh] = contourf(R.*cos(T)*1e3,R.*sin(T)*1e3,FFN);
set(foh, 'LineWidth', 1);
view(-90,90);
caxis('auto');
axis([0 20 -6.5 6.5 min(min(FFN)) max(max(FFN))]);
set(gca,'FontSize',22);
set(gca,'LineWidth',1);
xlabel('X[mm]','FontSize',22);
ylabel('Y[mm]','FontSize',22);
zlabel('\lambda_{max}','FontSize',22);
cb = colorbar('Location','west','FontSize',22);
colormap(post.cm);
ct = title(cb,'\lambda','FontSize',22);
if verLessThan('matlab','8.4')
    set(cb,'Position',[0.144 0.129 0.0466 0.2738]); % R2014b Mac
    set(ct,'Position',[3.875 -0.275 1.000]); % R2014b Mac
else
    set(cb,'Position',[0.1673 0.129 0.0466 0.2738]); % R2016a Mac
    set(cb,'AxisLocation','in'); % R2016a Mac
    set(ct,'Position',[33.875 166.72 0]); % R2016a Mac
end
Ndimfig=30;
Wdimfig=429;
Hdimfig=568;
set(fLag,'Position',[900 396 Wdimfig Hdimfig]);
set(fLag,'PaperUnits','centimeter');
set(fLag,'PaperSize',[Wdimfig/Ndimfig,Hdimfig/Ndimfig]);
set(fLag,'PaperPosition',[0,0,Wdimfig/Ndimfig,Hdimfig/Ndimfig]);
%
cxt = [min(min(FFN)), 0.5*(min(min(FFN))+max(max(FFN))), max(max(FFN))];
cx = [cxt(1), cxt(end)];
caxis(cx); %caxis([-1.5 -0.269]);
if verLessThan('matlab','8.4')
    set(cb,'YTickMode','manual');
    set(cb,'YTick',cxt);
    set(ct,'Position',[3.875 max(cxt)+0.3*(max(cxt)-min(cxt)) 1.000]); % R2014b Mac
else
    set(cb,'TicksMode','manual');
    set(cb,'Ticks',cxt);
end
