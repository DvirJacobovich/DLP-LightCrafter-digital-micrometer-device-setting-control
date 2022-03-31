clear, clc

addpath('pregen_wavelets');
addpath(genpath('reconstruction'));
addpath 'C:\Users\Dvir\Desktop\DMD Settings and Control\DMD Full Control\Usfull stuff'
addpath 'C:\Users\Dvir\Desktop\DMD Settings and Control\DMD Full Control\pregen_wavelets\dragon'
addpath 'C:\Users\Dvir\Desktop\DMD Settings and Control\DMD Full Control\pregen_wavelets\hadamard'

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
    
     % Define black and white.
     % For the simulation white color is all off and black is all on.
    whiteColor = WhiteIndex(screenNumber);              
    blackColor = BlackIndex(screenNumber);
    
    %Skip the sync tests because they fail screens with framerate > 250 Hz
    %anyway.
    Screen('Preference', 'SkipSyncTests', 1);
    [window, ~] = PsychImaging('OpenWindow', screenNumber, whiteColor);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    imageSize = 128;
%     numMeasurements = 8 * imageSize;
    numMeasurements = (imageSize^2)/8;
        % Generates measurement matrices if they don't already exist. 
        
         [Movie_mat, permutations] = ...
            GenerateMovieMat(imageSize, numMeasurements, 'dragon', 1, 1);
                 
            disp('created CS measurement set')

inverse_cells = singel_LL_inverse(imageSize); 

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
    warning('External screen resolution was not the expected 608x684')
end


% %load black frame and do noise estimation
Screen('FillRect', window, blackColor);
% % Flip from buffer to screen
Screen('Flip', window);
KbStrokeWait;

vtime0 = clock;
timesStartMask = [];
timesEndMasks = [];

for k = 1:numMeasurements + 1
    if k == numMeasurements + 1
        Screen('FillRect', window, blackColor);
        Screen('Flip', window);
        KbStrokeWait;
        waitbar(0);
        break;
    end


    waitbar(k/numMeasurements);

    % Draw mask
    start_times = clock;
    Screen('FillRect', window, whiteColor, inverse_cells(:, (Movie_mat(:, k) > 0))); 
    Screen('Flip', window);
    end_times = clock;
    
    timesStartMask = [timesStartMask; start_times];
    timesEndMasks = [timesEndMasks; end_times];

    % Flip from buffer to screen`ff
   
end

s = set_increas_order(timesStartMask(:,6),numMeasurements - 1);
e = set_increas_order(timesEndMasks(:,6), numMeasurements - 1);
dif = e - s;

file_name = sprintf('Variables_%d_%d_%d_%d%d_size_%d_CS.mat',vtime0(1:5), imageSize);
save(file_name);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Full measurements %%%%%%%%%%%%%%%%%%%%%%%
Screen('CloseAll');


% full_mat_struct = load('C:\Users\Dvir\Desktop\DMD Settings and Control\DMD Full Control\pregen_wavelets\dragon\128.mat');
% full_mat_struct = load('C:\Users\Dvir\Desktop\DMD Settings and Control\DMD Full Control\pregen_wavelets\hadamard\128.mat');
% 
% full_mat = full_mat_struct.Movie_mat;
% full_permutation = full_mat_struct.permutations;
% full_permutation = [full_permutation -1];
% 
% full_vtime0 = clock;
% full_timesStartMask = [];
% full_timesEndMasks = [];
% 
% counter = 1;
% for per = full_permutation
%     if counter == length(full_permutation) + 1
%         Screen('FillRect', window, blackColor);
%         Screen('Flip', window);
%         KbStrokeWait;
%         break;
%     end
% 
% 
%     waitbar(counter/ (length(full_permutation) + 1));
% 
%     % Draw mask
%     full_start_times = clock;
%     Screen('FillRect', window, whiteColor, inverse_cells(:, (full_mat(:, per) > 0))); 
%     Screen('Flip', window);
%     full_end_times = clock;
%     
%     full_timesStartMask = [full_timesStartMask; full_start_times];
%     full_timesEndMasks = [full_timesEndMasks; full_end_times];
% 
%     % Flip from buffer to screen`ff
%    counter = counter + 1;
% end
% 
% 

% My Note:
% inverse_cells is a matrix with 4 rows (one for each: x_0', y_0', x_1', y_1' flatted
% in this order - each row contains all the elements of its corresponds matrix where the
% order inside the row is: traspose the matrix and flat by rows! (or flat by columns the 
% original matrix)).
% Where x_0 is the matrix represends the x coordinate where you start from
% 1, to end - 1, and x1 is x_end matrix. Same for y's.

    