% --- Generate an image with a white background ---

C=APDmap;
figure();
C(C==0)=NaN;
h=imagesc(C);
set(h,'alphadata',~isnan(C))
colormap(jet); 
caxis([0 120]); axis off; axis square;colorbar;


% 


