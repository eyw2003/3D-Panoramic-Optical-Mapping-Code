function [OverwriteIndex] = chooseSavedialog

    d = dialog('Position',[300 300 300 150],'Name','Already existing file');
    DoneIndex = 0;
    txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[30 90 250 40],...
           'String','Do you want to overwrite the previously saved files?');
       
    popup = uicontrol('Parent',d,...
           'Position',[50 40 70 25],...
           'String','Yes',...
           'Callback',@yes_callback);
       
    btn2 = uicontrol('Parent',d,...
           'Position',[200 40 70 25],...
           'String','No',...
           'Callback',@no_callback);       
             
    % Wait for d to close before running to completion
    uiwait(d);
   
       function yes_callback(popup,event)
          OverwriteIndex = 1;
          close(d);
       end
   
    function no_callback(popup,event)
       OverwriteIndex = 0; 
       close(d);
    end
end