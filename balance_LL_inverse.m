function [ inverse_cells ] = balance_LL_inverse( input_size )
%LL_inverse Computes the inverse low-level DMD formatting matrix. 
%   This is Dvir Jacobovich version.
%   The output is such that:
%    output_x(cell) = first pixel this cell should cover. 

switch input_size
    
   case 16 
       
        x_end = (19:19:608);
        x_end = [x_end; 609];

        % (6, 4, 6)
%         y_end = [(44:43:172) (214:42:340) (383:43:)]';
%         x_end=(38:38:608)'; 
%         y_end=(54:42:684)'; 
   
        
    case 32 
        % (16, 32, 16)
        x_end = [(10: 9: 144) (154:10:464) (473:9:608)]';
        x_end = [x_end; 609];

        % (6, 20, 6)
        y_end = [(23:22:132) (153:21:552) (574:22:684)]';
        y_end = [y_end; 685];

        
%         x_end= (19:19:608)';
%         y_end= (33:21:684)';
        
        
    case 64
        
        % in this case we need to set the y axis to 64 pixels, 
        % and the x axis to 128 pixels (64 for each
        % side).
        % So for y axis we have: 684/64 = 10.68
        % For the x axis we have: 608 / 128 = 4.75 
        % and we want the small pixels to be in both side's centers, and 
        % the total number of pixels (in x and in y seperatly) to be 64 ofcouse.
       
        
        % Important! for example for the first one.
        
        % In the first part we have 48 logical pxs where the first one *ends* at 6 and the
        % last one ends at 240. (So 240-244 is the first pixel in the second part) 
        
        % In the second part we have 32 logical pxs where the first one ends in 244
        % and the last one ends in the 368.
        
        % In the third part we have 48 logical pxs where the first one
        % ends at 373 (the first one is 368-373) and the last one ends at
        % 608.
        option = 2;
        % option one is focusing on the sides. option two is forcing the
        % corespponding pixels to be the same size.

        switch option
            case 1
        % logic pxs:       48,        32,          48       
             x_end = [(6: 5: 240) (244:4:368) (373:5:608)]';
             x_end = [x_end; 609];
            
            case 2
                % Spliting the DMD into two 64x64 logic pixels and 304x684
                % physical pixels. The solution is (x, y, x, y) = (16, 48, 16, 48)
                % Where x is the number of pixs of size 4 and y size 5.
                x_end = [(5:4:64) (69:5:304) (308:4:368) (373:5:608)]';
                x_end = [x_end; 609];
        
        end
             
        % logic pxs:       22,        20,          22       
             y_end = [(12:11:242) (252:10:442) (453:11:684)]';
             y_end = [y_end; 685];
 
        %y_end=[(16:15:121) (135:14:793) (808:15:913)]';
        %x_end=[(19:18:469) (486:17:690) (708:18:1140)]';

    case 128 
    
    % For 256*128 logical pixels:
    % for x_end we have 608/256 ~ 2.3. Two options:
    
    % 1. (:2:) (:3:) (:2:) the solution for this one is (80, 96, 80) and
    % its althought we have more resolutions on the sides the center is
    % very big and the changing point may be at the sides where the beams
    % are gonna hit.
    
    % 2. (:3:) (:2:) (:3:) which we have more resolution in the
    % center, but the solution for this two eqs is good: (48, 160, 48)
    % since the center is way greater than the sides so we can just project
    % the two beams to be at the two sides but not in the first 48 and the
    % last 48 correspondly. 
    
    option = 4;
    % option 4 forcing the coressponding pixels to be the same size on both
    % sides.
    
    switch option
        
        case 1   
             % first option (80, 96, 80) almost like spliting into 3 equal areas: 
             x_end = [(3:2:160) (163:3:448) (450:2:608)]';
             x_end = [x_end; 609];

        case 2
            % second option [(:3:) (:2:) (:3:)], (48, 160, 48) more resolution 
            % in the center and the center is ~66%:
            x_end = [(4:3:144) (146:2:464) (467:3:608)]';
            x_end = [x_end; 609];
            
        case 3 
            % maximux res at the center.
            % Starts at 176 ends at 432 in max res where each
            % logical pix equal to physical.
            x_end = (178:1:432)';
            x_end = [x_end; 608];
%             x_end = [x_end; 609];
            
        case 4
            % Corresponding pixels on both saides have to be with the same size.
            % The idea here is to find (x, y) such that (x, y) represents
            % both sides of the DMD, Here we have - for x axis: 304/128 ~
            % 2.3, so we want to solve for: 2x + 3y = 304, and x + y =
            % 128, and the solution is (x, y, x, y) = (80, 48, 80, 48).
            x_end = [(3:2:160) (163:3:304) (306:2:464) (467:3:608)]';
            x_end = [x_end; 609];
    end
    
    y_end = [(7:6:132) (137:5:552) (558:6:684)]';
    y_end = [y_end; 685];
    
    case 256 
        % For 512*256 logical pixels:
        % for x_end we have 608/512 ~ 1.8. For (: 2 : ) (: 1: ) (:2:)
        % We are getting good solution - (48, 416, 48) which means more than
        % 90% of the x axis (90.625% to be accurate) pixels are centered
        % also we get maximal logic resolution at the center since the physical
        % and logical pixs sizes are equal.
        % So like in the 256*128 case we can set the two beams not hit the
        % small sides, and avoiding the intersection of signals with the switching 
        % resolution point.
        x_end = [(3:2:96) (97:1:512) (514:2:608)]';
        x_end = [x_end; 609];
        
        % For y_end
        % (:2:) (:3:) (:2:) yields the solution- (42, 172, 42)
        y_end = [(3:2:84) (87:3:600) (602:2:684)]';
        y_end = [y_end; 685];
          
    otherwise
        warning('Low level formatting not available for size %d', input_size)
end

x_begin = [1; x_end(1:end-1)];
y_begin = [1; y_end(1:end-1)];

[x_0, y_0] = meshgrid(x_begin, y_begin);
[x_1, y_1] = meshgrid(x_end, y_end);

inverse_cells = [x_0(:)'; y_0(:)'; x_1(:)'; y_1(:)'];


end
