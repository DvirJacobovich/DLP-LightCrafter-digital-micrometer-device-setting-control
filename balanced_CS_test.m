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
    fullSize = imageSize^2;
%     numMeasurements = 8 * imageSize;
    numMeasurements = 2;
    
    
    % fisrt matrix:
    row1 = ones(fullSize, 1);
    row2 = zeros(fullSize, 1);
    for i = 1 : fullSize
       if i > fullSize / 2
           row2(i) = 1;
       end
    end

    row3 = zeros(fullSize, 1);
    row4 = zeros(fullSize, 1);
    for i = 1: fullSize
       if mod(i, 2) == 0
           row3(i) = 1;
       else
           row4(i) = 1;
       end
         
    end
    
first_mat = [row1; row2];
second_mat = [row3; row4];    

first_measurement_matrix = [first_mat second_mat];
second_measurement_matrix = [second_mat first_mat];

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

Screen('FillRect', window, whiteColor, inverse_cells(:, (first_measurement_matrix(:, 2) > 0))); 
Screen('Flip', window);

KbStrokeWait;

Screen('FillRect', window, blackColor);
Screen('Flip', window);

Screen('FillRect', window, whiteColor, inverse_cells(:, (second_measurement_matrix(:, 2) > 0))); 
Screen('Flip', window);

KbStrokeWait;

Screen('FillRect', window, blackColor);
Screen('Flip', window);
        

% Screen('CloseAll');




% Flip from buffer to screen


    
    
    