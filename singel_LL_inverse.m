function [ inverse_cells ] = singel_LL_inverse( input_size )
%LL_inverse Computes the inverse low-level DMD formatting matrix. 
%   This is Dvir Jacobovich version.
%   The output is such that:
%    output_x(cell) = first pixel this cell should cover. 

switch input_size
    
   case 16 
       
%         x_end = (19:19:608);
%         x_end = [x_end; 609];

        % (6, 4, 6)
%         y_end = [(44:43:172) (214:42:340) (383:43:)]';
        x_end=(38:38:608)'; 
        y_end=(54:42:684)'; 
   
        
    case 32 
         x_end= (19:19:608)';
         y_end= (33:21:684)';
     
        
    case 64
        
        x_end = [(11: 10: 160) (169:9:448) (458:10:608)]';
        x_end = [x_end; 609];
        
        % The y is wrong!
        % 684 / 64 ~ 10.6 -> for 10x + 11y + 10x = 684 we get (1.67, 60.66, 1.67)
        % For 11x + 10y + 11x = 684 -> we get (-5.5, 75, -5.5).
       
        y_end = [(23:22:242) (262:20:442) (464:22:684)]';  
        y_end = [y_end; 685];

        

    case 128 
        
        x_end = [(5: 4: 64) (69: 5: 544) (548:4: 608)]';
        x_end = [x_end; 609];
        
        y_end = [(7:6:132) (137:5:552) (558:6:684)]';
        y_end = [y_end; 685];

    
    case 256 
      
    otherwise
        warning('Low level formatting not available for size %d', input_size)
end

x_begin = [1; x_end(1:end-1)];
y_begin = [1; y_end(1:end-1)];

[x_0, y_0] = meshgrid(x_begin, y_begin);
[x_1, y_1] = meshgrid(x_end, y_end);

inverse_cells = [x_0(:)'; y_0(:)'; x_1(:)'; y_1(:)'];


end