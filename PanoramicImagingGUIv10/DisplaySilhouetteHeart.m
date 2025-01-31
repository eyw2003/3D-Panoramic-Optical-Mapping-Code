function [SilhouetteFinal,R] = DisplaySilhouetteHeart(SilhouetteTotal,axesFig,AxX,AxY,AxZ)

dx = AxX(2)-AxX(1);
dy = AxY(2)-AxY(1);
dz = AxZ(2)-AxZ(1);
indXZero = find(AxX>-dx/2 & AxX<dx/2);
indYZero = find(AxY>-dy/2 & AxY<dy/2);
indZZero = find(AxZ>-dz/2 & AxZ<dz/2);
%% Rotation and translation of the silhouette to be at the center of the coordinate system and aligned with the z-axis
clear ROTMatrix
indSilhouette = find(SilhouetteTotal);
[CoordSilh(:,1),CoordSilh(:,2),CoordSilh(:,3)] = ind2sub(size(SilhouetteTotal),indSilhouette);

L1 = fitLine3d(CoordSilh);
vz = [0 0 1];
ROTMatrix = createRotationVector3d([L1(4) L1(5) L1(6)],vz);
CoordSilhRot=transformPoint3d(CoordSilh,ROTMatrix);
SilhouetteRot = zeros(size(SilhouetteTotal));
for ii=1:length(indSilhouette)
    if round(CoordSilhRot(ii,1))<=0 || round(CoordSilhRot(ii,2))<=0 || round(CoordSilhRot(ii,3))<=0
        testCoordNeg = 0;
    else
        SilhouetteRot(round(CoordSilhRot(ii,1)),round(CoordSilhRot(ii,2)),round(CoordSilhRot(ii,3))) = 1;
    end
end

ellFitS = inertiaEllipsoid(CoordSilhRot);
TransMatrixS = createTranslation3d(indXZero-ellFitS(1), indYZero-ellFitS(2),indZZero-ellFitS(3)); 
CoordSilhFinal = transformPoint3d(CoordSilhRot,TransMatrixS);
SilhouetteFinal = zeros(size(SilhouetteTotal));
for ii=1:length(indSilhouette)
    if round(CoordSilhFinal(ii,1))<=0 || round(CoordSilhFinal(ii,2))<=0 || round(CoordSilhFinal(ii,3))<=0
        testCoordNeg = 0;
    else
        SilhouetteFinal(round(CoordSilhFinal(ii,1)),round(CoordSilhFinal(ii,2)),round(CoordSilhFinal(ii,3))) = 1;
    end
end

%% Definition of a shell to display the silhouette in Matlab
nTheta = 180;
AxTheta = linspace(0,pi,nTheta);
R = zeros(2*nTheta,size(SilhouetteFinal,3));
SilhRay = zeros(nTheta,size(SilhouetteFinal,1));
iyS = zeros(1,size(SilhouetteFinal,1));
ixS = zeros(1,size(SilhouetteFinal,2));
h = waitbar(0,'Calculating display of the silhouette');
for iz = 1:size(SilhouetteFinal,3)
    ixS1 = zeros(1,nTheta);
    iyS1 = zeros(1,nTheta);
    ixS1b = zeros(1,nTheta);
    iyS1b = zeros(1,nTheta);
    ixS2 = zeros(1,nTheta);
    iyS2 = zeros(1,nTheta);
    ixS2b = zeros(1,nTheta);
    iyS2b = zeros(1,nTheta);
    if ~isempty(find(squeeze(SilhouetteFinal(:,:,iz)),1))       
        statsSilh = regionprops(squeeze(SilhouetteFinal(:,:,iz)),'centroid');   
        for itheta = 1:nTheta
            for ix = 1:size(SilhouetteFinal,1)
                iyS(ix) = round(statsSilh.Centroid(2)+tan(AxTheta(itheta))*(ix-statsSilh.Centroid(1)));
                if iyS(ix) >0 && iyS(ix)<= size(SilhouetteFinal,2)
                    SilhRay(itheta,ix) = squeeze(SilhouetteFinal(ix,iyS(ix),iz));
                end
            end
            if ~isempty(find(SilhRay(itheta,:), 1))
                [~,ixS1(itheta)] = find(SilhRay(itheta,:),1,'first');
                iyS1(itheta) = iyS(ixS1(itheta));                
            end
            if ~isempty(find(SilhRay(itheta,:), 1))
                [~,ixS2(itheta)] = find(SilhRay(itheta,:),1,'last');
                iyS2(itheta) = iyS(ixS2(itheta));
            end
%             hold on
%             plot(iy2(itheta),ix2(itheta),'or')
%             plot(iy1(itheta),ix1(itheta),'or'),pause
        end
        
        for itheta2 = 1:nTheta
            clear ixS iyS
            for iy = 1:size(SilhouetteFinal,2)
                ixS(iy) = round(statsSilh.Centroid(1)+tan(AxTheta(itheta2))*(iy-statsSilh.Centroid(2)));
                if ixS(iy) >0 && ixS(iy)<= size(SilhouetteFinal,1)
                    SilhRay(itheta2,iy) = squeeze(SilhouetteFinal(ixS(iy),iy,iz));
                end
            end
            if ~isempty(find(SilhRay(itheta2,:), 1))
                [~,iyS1b(itheta2)] = find(SilhRay(itheta2,:),1,'first');
                ixS1b(itheta2) = ixS(iyS1b(itheta2));
            end
            if ~isempty(find(SilhRay(itheta2,:), 1))
                [~,iyS2b(itheta2)] = find(SilhRay(itheta2,:),1,'last');
                ixS2b(itheta2) = ixS(iyS2b(itheta2));
            end
%             hold on
%             plot(iy2b(itheta2),ix2b(itheta2),'or')
%             plot(iy1b(itheta2),ix1b(itheta2),'or'),pause
        end
                
        thetaLiaison = 20;
        ixS1F(1:round(nTheta/2)-thetaLiaison) = ixS1(1:round(nTheta/2)-thetaLiaison);
        iyS1F(1:round(nTheta/2)-thetaLiaison) = iyS1(1:round(nTheta/2)-thetaLiaison);
        ixS2F(1:round(nTheta/2)-thetaLiaison) = ixS2(1:round(nTheta/2)-thetaLiaison);
        iyS2F(1:round(nTheta/2)-thetaLiaison) = iyS2(1:round(nTheta/2)-thetaLiaison);
        ixS1F(round(nTheta/2)-(thetaLiaison-1):round(nTheta/2)) = ixS1b(1:thetaLiaison);
        iyS1F(round(nTheta/2)-(thetaLiaison-1):round(nTheta/2)) = iyS1b(1:thetaLiaison);
        ixS2F(round(nTheta/2)-(thetaLiaison-1):round(nTheta/2)) = ixS2b(1:thetaLiaison);
        iyS2F(round(nTheta/2)-(thetaLiaison-1):round(nTheta/2)) = iyS2b(1:thetaLiaison);        
        ixS1F(round(nTheta/2)+1:round(nTheta/2)+thetaLiaison) = ixS1b(nTheta-(thetaLiaison-1):nTheta);
        iyS1F(round(nTheta/2)+1:round(nTheta/2)+thetaLiaison) = iyS1b(nTheta-(thetaLiaison-1):nTheta);
        ixS2F(round(nTheta/2)+1:round(nTheta/2)+thetaLiaison) = ixS2b(nTheta-(thetaLiaison-1):nTheta);
        iyS2F(round(nTheta/2)+1:round(nTheta/2)+thetaLiaison) = iyS2b(nTheta-(thetaLiaison-1):nTheta);
        ixS1F(round(nTheta/2)+thetaLiaison:nTheta) = ixS2(round(nTheta/2)+thetaLiaison:nTheta);
        iyS1F(round(nTheta/2)+thetaLiaison:nTheta) = iyS2(round(nTheta/2)+thetaLiaison:nTheta);     
        ixS2F(round(nTheta/2)+thetaLiaison:nTheta) = ixS1(round(nTheta/2)+thetaLiaison:nTheta);
        iyS2F(round(nTheta/2)+thetaLiaison:nTheta) = iyS1(round(nTheta/2)+thetaLiaison:nTheta);
%         hold on
%         plot(iyS2F,ixS2F,'+r')
%         plot(iyS1F,ixS1F,'+r')
         
        RS1 = sqrt(((ixS1F-statsSilh.Centroid(1))*dx).^2+((iyS1F-statsSilh.Centroid(2))*dy).^2);
        RS2 = sqrt(((ixS2F-statsSilh.Centroid(1))*dx).^2+((iyS2F-statsSilh.Centroid(2))*dy).^2);        
        R(:,iz) = [RS1 RS2];
    end
    waitbar(iz/size(SilhouetteFinal,3),h);
end
close(h)

% Filtering of the extreme values to avoid the spaceship style figure on
% top and bottom of the heart
UpBoundR = mean(R(:,round(iz/2)))+10*std(R(:,round(iz/2)));
R(R>=UpBoundR) = 0;

ThetaAxis = linspace(0,2*pi,2*nTheta);
ZAxis = AxZ;%linspace(0,size(SilhouetteFinal,3),size(SilhouetteFinal,3));
[ThetaMeshAxis,ZMeshAxis]=meshgrid(ThetaAxis,ZAxis);
axes(axesFig);
h = surf(R.*cos(ThetaMeshAxis).',R.*sin(ThetaMeshAxis).',ZMeshAxis.');
set(h,'LineStyle','none','FaceColor',[1 0 0],'FaceAlpha',0.5);
axis image