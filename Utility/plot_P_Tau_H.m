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
header_path;

if (nargin >= 5)
    cm = varargin{3}.cm;
else
    cm = viridis();
end

pltP;
if (nargin >= 4)
    cxt = varargin{2}.pax;
    cx = [cxt(1), cxt(end)];
    caxis(cx); %caxis([-1.125 +8.149]);
    if verLessThan('matlab','8.4')
        set(cb,'YTickMode','manual');
        set(cb,'YTick',cxt);
        set(ct,'Position',[3.875 max(cxt)+0.2*(max(cxt)-min(cxt)) 1.000]); % R2014b Mac
    else
        set(cb,'TicksMode','manual');
        set(cb,'Ticks',cxt);
    end
end
drawnow;
if ((nargin >= 5) && (varargin{3}.exportfig == true))
    fname = varargin{3}.pname;
    print(strcat(currentpath,dirsep,'Figures',dirsep,fname),strcat('-',varargin{3}.exporttype));
end

pltTau;
if (nargin >= 4)
    cxt = varargin{2}.tax;
    cx = [cxt(1), cxt(end)];
    caxis(cx); %caxis([-0.206 +1.072]);
    if verLessThan('matlab','8.4')
        set(cb,'YTickMode','manual');
        set(cb,'YTick',cxt);
        set(ct,'Position',[3.875 max(cxt)+0.2*(max(cxt)-min(cxt)) 1.000]); % R2014b Mac
    else
        set(cb,'TicksMode','manual');
        set(cb,'Ticks',cxt);
    end
end
drawnow;
if ((nargin >= 5) && (varargin{3}.exportfig == true))
    fname = varargin{3}.tname;
    print(strcat(currentpath,dirsep,'Figures',dirsep,fname),strcat('-',varargin{3}.exporttype));
end

pltH;
if (nargin >= 4)
    cxt = varargin{2}.hax;
    cx = [cxt(1), cxt(end)];
    caxis(cx); %caxis([-1.5 -0.269]);
    if verLessThan('matlab','8.4')
        set(cb,'YTickMode','manual');
        set(cb,'YTick',cxt);
        set(ct,'Position',[3.875 max(cxt)+0.2*(max(cxt)-min(cxt)) 1.000]); % R2014b Mac
    else
        set(cb,'TicksMode','manual');
        set(cb,'Ticks',cxt);
    end
end
drawnow;
if ((nargin >= 5) && (varargin{3}.exportfig == true))
    fname = varargin{3}.hname;
    print(strcat(currentpath,dirsep,'Figures',dirsep,fname),strcat('-',varargin{3}.exporttype));
end

disp('a set of plot end');