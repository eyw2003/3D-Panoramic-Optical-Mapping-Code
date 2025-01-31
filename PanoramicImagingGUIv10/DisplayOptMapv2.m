% function [ProjectedMap,OptMapFMovie,R,ThetaMeshAxis,ZMeshAxis,fig] = ProjectionOptMap(OptMap,SilhouetteFinal,AxX,AxY,AxZ,AxesOptMap)
function [ProjectedMap,OptMapFMovie,R,ThetaMeshAxis,ZMeshAxis] = DisplayOptMapv2(OptMap,SilhouetteFinal,AxX,AxY,AxZ)

nTheta = 180;
AxTheta = linspace(0,pi,nTheta);
dx = AxX(2)-AxX(1);
dy = AxY(2)-AxY(1);
h = waitbar(0,'Calculating display of the 3-D optical map');
OptMapBW = zeros(size(OptMap,1),size(OptMap,2));
R = zeros(2*nTheta,size(OptMap,3));
OptMapF = zeros(2*nTheta,size(OptMap,3));
OptMapRay = zeros(nTheta,size(OptMap,1));
SilhRay = zeros(nTheta,size(OptMap,1));
iy = zeros(1,size(OptMap,1));
iyS = zeros(1,size(OptMap,1));
ix = zeros(1,size(OptMap,2));
ixS = zeros(1,size(OptMap,2));

ProjectedMapInit = zeros(length(AxX),length(AxY),length(AxZ));

for iz = 1:size(OptMap,3)
    ix1 = zeros(1,nTheta);
    iy1 = zeros(1,nTheta);
    ix1b = zeros(1,nTheta);
    iy1b = zeros(1,nTheta);
    ix2 = zeros(1,nTheta);
    iy2 = zeros(1,nTheta);
    ix2b = zeros(1,nTheta);
    iy2b = zeros(1,nTheta);
    ixS1 = zeros(1,nTheta);
    iyS1 = zeros(1,nTheta);
    ixS1b = zeros(1,nTheta);
    iyS1b = zeros(1,nTheta);
    ixS2 = zeros(1,nTheta);
    iyS2 = zeros(1,nTheta);
    ixS2b = zeros(1,nTheta);
    iyS2b = zeros(1,nTheta);
    OptMap1 = zeros(1,nTheta);
    OptMap1b = zeros(1,nTheta);
    OptMap2 = zeros(1,nTheta);
    OptMap2b = zeros(1,nTheta);
    
    OptMapZ = squeeze(OptMap(:,:,iz));
    SilhZ = squeeze(SilhouetteFinal(:,:,iz));
    if ~isempty(find(OptMapZ, 1)) && ~isempty(find(SilhZ, 1))
        OptMapBW(abs(OptMapZ)>0) = 1;
        statsMap = regionprops(OptMapBW,'centroid');
        %             imagesc(OptMapZ)
        for itheta = 1:nTheta
            for ix = 1:size(OptMap,1)
                iy(ix) = round(statsMap.Centroid(2)+tan(AxTheta(itheta))*(ix-statsMap.Centroid(1)));
                if iy(ix) >0 && iy(ix)<= size(OptMapBW,2)
                    OptMapRay(itheta,ix) = OptMapZ(ix,iy(ix));
                end
            end
            if ~isempty(find(OptMapRay(itheta,:), 1))
                [~,ix1(itheta)] = find(OptMapRay(itheta,:),1,'first');
                iy1(itheta) = iy(ix1(itheta));
                if iy1(itheta) >0 && iy1(itheta)<= size(OptMapZ,2)
                    OptMap1(itheta) = OptMapZ(ix1(itheta),iy1(itheta));
                end
            end
            if ~isempty(find(OptMapRay(itheta,:), 1))
                [~,ix2(itheta)] = find(OptMapRay(itheta,:),1,'last');
                iy2(itheta) = iy(ix2(itheta));
                if iy2(itheta) >0 && iy2(itheta)<= size(OptMapZ,2)
                    OptMap2(itheta) = OptMapZ(ix2(itheta),iy2(itheta));
                end
            end
            %             hold on
            %             plot(iy2(itheta),ix2(itheta),'ok')
            %             plot(iy1(itheta),ix1(itheta),'ok')
        end
        
        for itheta2 = 1:nTheta
            clear ix iy
            for iy = 1:size(OptMap,2)
                ix(iy) = round(statsMap.Centroid(1)+tan(AxTheta(itheta2))*(iy-statsMap.Centroid(2)));
                if ix(iy) >0 && ix(iy)<= size(OptMapBW,1)
                    OptMapRay(itheta2,iy) = OptMapZ(ix(iy),iy);
                end
            end
            if ~isempty(find(OptMapRay(itheta2,:), 1))
                [~,iy1b(itheta2)] = find(OptMapRay(itheta2,:),1,'first');
                ix1b(itheta2) = ix(iy1b(itheta2));
                if ix1b(itheta2) >0 && ix1b(itheta2)<= size(OptMapZ,2)
                    OptMap1b(itheta2) = OptMapZ(ix1b(itheta2),iy1b(itheta2));
                end
            end
            if ~isempty(find(OptMapRay(itheta2,:), 1))
                [~,iy2b(itheta2)] = find(OptMapRay(itheta2,:),1,'last');
                ix2b(itheta2) = ix(iy2b(itheta2));
                if ix2b(itheta2) >0 && ix2b(itheta2)<= size(OptMapZ,2)
                    OptMap2b(itheta2) = OptMapZ(ix2b(itheta2),iy2b(itheta2));
                end
            end
            %             hold on
            %             plot(iy2b(itheta2),ix2b(itheta2),'oc')
            %             plot(iy1b(itheta2),ix1b(itheta2),'oc')%,pause
        end
        
        thetaLiaison = 20;
        OptMap1F(1:round(nTheta/2)-thetaLiaison) = OptMap1(1:round(nTheta/2)-thetaLiaison);
        ix1F(1:round(nTheta/2)-thetaLiaison) = ix1(1:round(nTheta/2)-thetaLiaison);
        iy1F(1:round(nTheta/2)-thetaLiaison) = iy1(1:round(nTheta/2)-thetaLiaison);
        OptMap2F(1:round(nTheta/2)-thetaLiaison) = OptMap2(1:round(nTheta/2)-thetaLiaison);
        ix2F(1:round(nTheta/2)-thetaLiaison) = ix2(1:round(nTheta/2)-thetaLiaison);
        iy2F(1:round(nTheta/2)-thetaLiaison) = iy2(1:round(nTheta/2)-thetaLiaison);
        OptMap1F(round(nTheta/2)-(thetaLiaison-1):round(nTheta/2)) = fliplr(OptMap1b(1:thetaLiaison));
        ix1F(round(nTheta/2)-(thetaLiaison-1):round(nTheta/2)) = fliplr(ix1b(1:thetaLiaison));
        iy1F(round(nTheta/2)-(thetaLiaison-1):round(nTheta/2)) = fliplr(iy1b(1:thetaLiaison));
        OptMap2F(round(nTheta/2)-(thetaLiaison-1):round(nTheta/2)) = fliplr(OptMap2b(1:thetaLiaison));
        ix2F(round(nTheta/2)-(thetaLiaison-1):round(nTheta/2)) = fliplr(ix2b(1:thetaLiaison));
        iy2F(round(nTheta/2)-(thetaLiaison-1):round(nTheta/2)) = fliplr(iy2b(1:thetaLiaison));
        OptMap1F(round(nTheta/2)+1:round(nTheta/2)+thetaLiaison) = fliplr(OptMap1b(nTheta-(thetaLiaison-1):nTheta));
        ix1F(round(nTheta/2)+1:round(nTheta/2)+thetaLiaison) = fliplr(ix1b(nTheta-(thetaLiaison-1):nTheta));
        iy1F(round(nTheta/2)+1:round(nTheta/2)+thetaLiaison) = fliplr(iy1b(nTheta-(thetaLiaison-1):nTheta));
        OptMap2F(round(nTheta/2)+1:round(nTheta/2)+thetaLiaison) = OptMap2b(nTheta-(thetaLiaison-1):nTheta);
        ix2F(round(nTheta/2)+1:round(nTheta/2)+thetaLiaison) = ix2b(nTheta-(thetaLiaison-1):nTheta);
        iy2F(round(nTheta/2)+1:round(nTheta/2)+thetaLiaison) = iy2b(nTheta-(thetaLiaison-1):nTheta);
        OptMap1F(round(nTheta/2)+thetaLiaison:nTheta) = OptMap2(round(nTheta/2)+thetaLiaison:nTheta);
        ix1F(round(nTheta/2)+thetaLiaison:nTheta) = ix2(round(nTheta/2)+thetaLiaison:nTheta);
        iy1F(round(nTheta/2)+thetaLiaison:nTheta) = iy2(round(nTheta/2)+thetaLiaison:nTheta);
        OptMap2F(round(nTheta/2)+thetaLiaison:nTheta) = OptMap1(round(nTheta/2)+thetaLiaison:nTheta);
        ix2F(round(nTheta/2)+thetaLiaison:nTheta) = ix1(round(nTheta/2)+thetaLiaison:nTheta);
        iy2F(round(nTheta/2)+thetaLiaison:nTheta) = iy1(round(nTheta/2)+thetaLiaison:nTheta);
%         hold on
%         plot(iy2F(110:180),ix2F(110:180),'oc')
%         plot(iy1F(110:180),ix1F(110:180),'oc')
        %             pause(0.1)
        OptMapF(:,iz) = [OptMap1F OptMap2F];
        
        %
        statsSilh = regionprops(squeeze(SilhouetteFinal(:,:,iz)),'centroid');
        %             imagesc(SilhouetteFinal(:,:,iz))
        for itheta = 1:nTheta
            for ix = 1:size(OptMap,1)
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
            for iy = 1:size(OptMap,2)
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
        %             hold on
        %             plot(iyS2F,ixS2F,'+r')
        %             plot(iyS1F,ixS1F,'+r')
        
        RS1 = sqrt(((ixS1F-statsSilh.Centroid(1))*dx).^2+((iyS1F-statsSilh.Centroid(2))*dy).^2);
        RS2 = sqrt(((ixS2F-statsSilh.Centroid(1))*dx).^2+((iyS2F-statsSilh.Centroid(2))*dy).^2);
        R(:,iz) = [RS1 RS2];
        
        for itheta = 1:nTheta
            if ixS1F(itheta) > 0 && iyS1F(itheta) > 0
                ProjectedMapInit(ixS1F(itheta),iyS1F(itheta),iz) = OptMapF(itheta,iz);
            end
            if ixS2F(itheta) > 0 && iyS2F(itheta) > 0
                ProjectedMapInit(ixS2F(itheta),iyS2F(itheta),iz) = OptMapF(itheta+nTheta,iz);
            end
        end
    end
    waitbar(iz/size(OptMap,3),h)
end

ProjectedMap = ProjectedMapInit;
OptMapFMovie = OptMapF;
close(h)

% Filtering of the projected map (to avoid a grainy aspect in Amira)
ProjectedMap(ProjectedMap == 0) = -Inf;
ProjectedMapFilt = ProjectedMap;
for ii = 1:size(ProjectedMap,3)
    clear nzComp
    [indRowZ,indColZ] = find(isinf(squeeze(ProjectedMap(:,:,ii))));
    for iZ = 1:length(indRowZ)
        if indRowZ(iZ) > 1 && indColZ(iZ) > 1 && indRowZ(iZ) < size(ProjectedMap,1) && indColZ(iZ) < size(ProjectedMap,2)
            if isinf(ProjectedMap(indRowZ(iZ)-1,indColZ(iZ)-1,ii)) && isinf(ProjectedMap(indRowZ(iZ)-1,indColZ(iZ),ii)) && isinf(ProjectedMap(indRowZ(iZ)-1,indColZ(iZ)+1,ii)) && isinf(ProjectedMap(indRowZ(iZ),indColZ(iZ)-1,ii)) && isinf(ProjectedMap(indRowZ(iZ)-1,indColZ(iZ)+1,ii)) && isinf(ProjectedMap(indRowZ(iZ)+1,indColZ(iZ)-1,ii)) && isinf(ProjectedMap(indRowZ(iZ)+1,indColZ(iZ),ii)) && isinf(ProjectedMap(indRowZ(iZ)+1,indColZ(iZ)+1,ii))
                a = 1;
            else
                ZeroNeighbourhood = [ProjectedMap(indRowZ(iZ)-1,indColZ(iZ)-1,ii),ProjectedMap(indRowZ(iZ)-1,indColZ(iZ),ii),ProjectedMap(indRowZ(iZ)-1,indColZ(iZ)+1,ii),ProjectedMap(indRowZ(iZ),indColZ(iZ)-1,ii),ProjectedMap(indRowZ(iZ)-1,indColZ(iZ)+1,ii),ProjectedMap(indRowZ(iZ)+1,indColZ(iZ)-1,ii),ProjectedMap(indRowZ(iZ)+1,indColZ(iZ),ii),ProjectedMap(indRowZ(iZ)+1,indColZ(iZ)+1,ii)];                
                nzComp = ZeroNeighbourhood(~isinf(ZeroNeighbourhood));
                ProjectedMapFilt(indRowZ(iZ),indColZ(iZ),ii) = mean(nzComp);
            end
        end
    end
end
ProjectedMap = ProjectedMapFilt;

% Filtering of the extreme values to avoid the spaceship style figure on
% top and bottom of the heart
UpBoundR = mean(R(:,round(iz/2)))+10*std(R(:,round(iz/2)));
R(R>=UpBoundR) = 0;

ThetaAxis = linspace(0,2*pi,2*nTheta);
ZAxis = AxZ;%linspace(0,size(OptMap,3),size(OptMap,3));
[ThetaMeshAxis,ZMeshAxis]=meshgrid(ThetaAxis,ZAxis);
% fig = figure;
% h = surf(R.*cos(ThetaMeshAxis).',R.*sin(ThetaMeshAxis).',ZMeshAxis.',squeeze(OptMapFMovie));
% set(h,'LineStyle','none')
% axis image
% colormap(jet)
% The image is displayed in a new figure (above) and the GUI (below)
% axes(AxesOptMap)
% h = surf(R.*cos(ThetaMeshAxis).',R.*sin(ThetaMeshAxis).',ZMeshAxis.',squeeze(OptMapFMovie));
% set(h,'LineStyle','none')
% axis image
% colormap(jet)
