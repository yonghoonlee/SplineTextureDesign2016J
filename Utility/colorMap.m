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
function color = colorMap(x, minimum, maximum)
% colorMap returns triplet color vector using value of x between minimum and maximum bounds

    p = (x - minimum) / (maximum - minimum);
    if p < 0
        p = 0;
    elseif p > 1
        p = 1;
    end
    
    red = jetMap(p - 0.25);
    green = jetMap(p);
    blue = jetMap(p + 0.25);
    color = [red green blue];
end

function intensity = jetMap(x)
    if x < 0.125
        intensity = 0;
    elseif x < 0.375
        intensity = (x-0.125) / 0.25;
    elseif x < 0.625
        intensity = 1;
    elseif x < 0.875
        intensity = 1 - (x-0.625) / 0.25;
    else
        intensity = 0;
    end
end