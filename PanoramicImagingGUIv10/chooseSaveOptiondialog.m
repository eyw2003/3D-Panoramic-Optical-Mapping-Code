function [SaveIndex] = chooseSaveOptiondialog

    d = dialog('Position',[300 300 300 150],'Name','Choose a save option');
    SaveIndex = 0;
    txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[30 90 250 40],...
           'String','Do you plan to visualize the 3-D map later in Amira?');       
     
    btn = uicontrol('Parent',d,...
           'Position',[40 20 80 25],...
           'String','Yes',...
           'Callback',@yes_callback);
       
    btn2 = uicontrol('Parent',d,...
           'Position',[200 20 70 25],...
           'String','No',...
           'Callback',@no_callback);       
             
    % Wait for d to close before running to completion
    uiwait(d);
    function yes_callback(popup,event)
       SaveIndex = 1;        
       close(d);
    end

    function no_callback(popup,event)
       SaveIndex = 0;       
       close(d);
    end
end