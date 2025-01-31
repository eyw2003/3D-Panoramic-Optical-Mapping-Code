function [choiceCam,DoneIndex] = chooseCamdialog

    d = dialog('Position',[300 300 300 150],'Name','Select a cam');
    DoneIndex = 0;
    txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[30 90 250 40],...
           'String','Select a camera to choose a ROI or press cancel');
       
    popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[100 70 100 25],...
           'String',{'CamA';'CamB';'CamC';'CamD'},...
           'Callback',@popup_callback);
       
    btn2 = uicontrol('Parent',d,...
           'Position',[200 20 70 25],...
           'String','Cancel',...
           'Callback',@cancelFun_callback);       
             
    % Wait for d to close before running to completion
    uiwait(d);
   
       function popup_callback(popup,event)
          idx = popup.Value;
          popup_items = popup.String;
          % This code uses dot notation to get properties.
          % Dot notation runs in R2014b and later.
          % For R2014a and earlier:
          % idx = get(popup,'Value');
          % popup_items = get(popup,'String');
          choiceCam = char(popup_items(idx,:));
          close(d);
       end
   
    function cancelFun_callback(popup,event)
       DoneIndex = 1; 
       idx = popup.Value;
       popup_items = popup.String;       
       choiceCam = char(popup_items(idx,:));
       close(d);
    end
end