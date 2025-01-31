function [wf] = waveFront(data)
%% Wavefront Calculation %%
dVdt = data(:,2:end)-data(:,1:end-1);
% Preallocate variable for wave front activation times
waveFrontInd = cell(size(dVdt,1),1);
for n = 1:size(dVdt,1)
    % For all faces with data calculate activation times
    if sum(dVdt(n,:))~=0
        [waveFrontInd{n}] = peakfinder(dVdt(n,:),(max(dVdt(n,:))-min(dVdt(n,:)))/2);
    end
end
% % % % Calculate number of activation found per signal
% % % numWF = cellfun(@length,waveFrontInd);

% Preallocate variable for wavefront values
wf = zeros(size(dVdt,1),size(dVdt,2));
% Normalizes wavefront values by making all activation times equal to 1
for n = 1:size(waveFrontInd,1)
    wf(repmat(n,length(waveFrontInd{n})),waveFrontInd{n}) = 1;
end
% To visualize wavefront cause activation locations to decrement in
% intensity over 5 seconds
for n = 1:size(waveFrontInd,1)
    for m = 1:4
        wf(repmat(n,length(waveFrontInd{n})),waveFrontInd{n}+m) = 1-m*0.2;
    end
end
end