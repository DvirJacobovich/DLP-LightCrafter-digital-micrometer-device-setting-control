clc, clear
close all;

addpath('pregen_wavelets');
addpath(genpath('reconstruction'));
addpath('C:\Users\Dvir\Desktop\DMD Settings and Control\DMD Full Control\Usfull stuff')


%%%%%%%%%%%%%% PTB %%%%%%%%%%%%%%%%%
    
    PsychDefaultSetup(2);
    
    %Debug flag controls verbosity level
    %Screen('Preference', 'Verbosity',  handles.debugFlag);
    
    % Get the screen numbers
    screens = Screen('Screens');
    
    % Draw to the external screen
    screenNumber = max(screens);
    if screenNumber ~= 2
        error('External screen not found/not in use!')
    end
    
     % Define black and white
    whiteColor = WhiteIndex(screenNumber);
    blackColor = BlackIndex(screenNumber);
    
    %Skip the sync tests because they fail screens with framerate > 250 Hz
    %anyway.
    Screen('Preference', 'SkipSyncTests', 1);
    [window, ~] = PsychImaging('OpenWindow', screenNumber, whiteColor);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    imageSize = 128;
    full_size = imageSize^2;
         
        Movie_mat1 = zeros(full_size, full_size);
        for i = 1 : full_size
            vec = Movie_mat1(i, :);
            vec(i) = 1;
            Movie_mat1(i, :) = vec;
        end
        
        Movie_mat0 = Movie_mat1;      
        Movie_mat = [Movie_mat1; Movie_mat0];

            disp('created CS measurement set')            
     
inverse_cells = balance_LL_inverse(imageSize); 



% Open an on screen window if not open
if isempty(window)
    Screen('Preference', 'SkipSyncTests', 1);
    [window, ~] = PsychImaging('OpenWindow', screenNumber, whiteColor);
else
    Screen('FillRect', window, whiteColor);
    Screen('Flip', window);% set screen to white
end
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel); % PTB priority

% Get the size of the on screen window
[screenSizeX, screenSizeY] = Screen('WindowSize', window);

if screenSizeX ~= 608 || screenSizeY ~= 684
    warning('External screen resolution was not the expected 1140x912')
end


%load black frame and do noise estimation
Screen('FillRect', window, blackColor);
% Flip from buffer to screen
Screen('Flip', window);
KbStrokeWait;

for k = 1:full_size
    
%     waitbar(k/full_size);

    % Draw mask
    Screen('FillRect', window, whiteColor, inverse_cells(:, (Movie_mat(:, k) > 0))); 
%     KbStrokeWait;
   
    % Flip from buffer to screen.
    
    Screen('Flip', window);
end
Screen('FillRect', window, blackColor);
Screen('Flip', window);
KbStrokeWait;

% Flip from buffer to screen

% My Note:
% inverse_cells is a matrix with 4 rows (one for each: x_0', y_0', x_1', y_1' flatted
% in this order - each row contains all the elements of its corresponds matrix where the
% order inside the row is: traspose the matrix and flat by rows! (or flat by columns the 
% original matrix)).
% Where x_0 is the matrix represends the x coordinate where you start from
% 1, to end - 1, and x1 is x_end matrix. Same for y's.
 