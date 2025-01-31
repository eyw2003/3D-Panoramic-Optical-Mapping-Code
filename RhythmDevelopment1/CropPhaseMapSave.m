% ---- TO DO cropped PhaseMapMovie
% First convert NaN to 0
% Then apply mask = roipoly 
% Finally reconvert back the zeros to NaN

PhaseMapMovie(isnan(PhaseMapMovie))=0;
figure(); imagesc(PhaseMapMovie(:,:,1)); colormap jet;
mask=roipoly;

phaseCropped=zeros(size(PhaseMapMovie));
   for i = 1:size(PhaseMapMovie,3)
        phaseCropped(:,:,i)=PhaseMapMovie(:,:,i).*mask;
        temp=phaseCropped(:,:,i);
        temp(temp==0)=NaN;
        phaseCropped(:,:,i)=temp;
   end
figure(); imagesc(phaseCropped(:,:,1)); colormap jet;
   
PhaseMapMovie=phaseCropped;
save('IMG0312-051DPhaseMapMovie.mat','PhaseMapMovie')