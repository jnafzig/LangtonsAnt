%%  This script simulates Langton's Ant.
% Langton's ant is a cellular automata which moves around on a regular grid
% of zeros and ones.  The ant has a direction and at each step moves one
% square forward and turns left or right depending on the state of the
% square it is standing on.  It turns right if it is standing on a 1 and
% left if standing on a 0.  In this case it starts on a regular grid of ones with
% periodic boundary conditions.
%
% Selected frames are output as png images and these can be compiled into a
% video using ffmpeg.


clear;

N = 640;
M = 480;
Board = ones(M,N);

AntDirection = 0; % 0 -> up, 1 -> right, 2 -> down, 3 -> left
AntLocation = [1,1]*floor(N/2);

%# figure
fig = figure;
set(fig, 'Color','white')
set(fig, 'nextplot','replacechildren', 'Visible','off');

% set(fig, 'Units', 'centimeters');
pos = get(fig, 'Position');
pos(3) = N; % Select the width of the figure in [cm]
pos(4) = M; % Select the height of the figure in [cm]
set(fig,'defaultaxesposition',[0 0 1 1])
set(fig, 'Position', pos);

NumSteps = 50000;
NumSkip = 500;
NumFrames = floor(NumSteps/NumSkip);

FrameNumber = 0;
for i = 1:NumSteps
    if Board(AntLocation(1),AntLocation(2))==0
        Board(AntLocation(1),AntLocation(2))=1;
        AntDirection = mod(AntDirection+1,4);   
    else 
        Board(AntLocation(1),AntLocation(2))=0;
        AntDirection = mod(AntDirection-1,4);
    end
    switch AntDirection
        case 0
            AntLocation = AntLocation + [0,1];
        case 1
            AntLocation = AntLocation + [1,0];
        case 2
            AntLocation = AntLocation + [0,-1];
        case 3
            AntLocation = AntLocation + [-1,0];
    end
    AntLocation = mod(AntLocation-1,[M,N])+1;
    
    if mod(i,NumSkip) == 0;
        FrameNumber = FrameNumber+1;
        imwrite(uint8(255*Board), sprintf('video/%04d.png',FrameNumber));
    end
    
    if mod(100*i,NumSteps)==0
        fprintf('.');
    end
    
end
fprintf('\n');

% compile png files
%system('ffmpeg -r 60 -i video/%04d.png -s 1380x720 -c:v libx264 -qscale 10 -r 30 ant.mp4')

