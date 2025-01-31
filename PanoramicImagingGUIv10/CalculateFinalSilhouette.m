function SilhouetteTotal = CalculateFinalSilhouette(numViews,AngleBtwViews,Silhouettes,FitRod,AxX,AxY,AxZ)

% Calculate the final smooth 3D silhouette of the heart using the previously
% calculated numViews 3D silhouettes.

% Inputs: numViews indicates the number of views in total (to cover 90degrees with a 5 degree steps, numViews = 19)
%         AngleBtwViews is the angle between two successive series of acq
%         Silhouettes is the name of the structure containing the numViews
%         4-faced silhouettes previously calculated with the occluding
%         contour scripts.
%         FitRod is the coordinates of the axis of rotation determined with
%         the function CalculateAxisRotation
%         AxX, AxY, AxZ are the axes of the virtual box surrounding the
%         heart

SilhouetteTotal = zeros(size(Silhouettes.Silhouette1));
dx = AxX(2)-AxX(1);
dy = AxY(2)-AxY(1);
dz = AxZ(2)-AxZ(1);
indXZero = find(AxX>-dx/2 & AxX<dx/2);
indYZero = find(AxY>-dy/2 & AxY<dy/2);
indZZero = find(AxZ>-dz/2 & AxZ<dz/2);
h = waitbar(0,'Calculating the resulting 3-D silhouette');
for iAngle = 1:1:numViews
   clear CoordHeart CoordHeartRot indHeart
   eval(strcat('Silhouette=Silhouettes.Silhouette',num2str(iAngle),';'))
   % Rotate the datasets
   AngleRot = -AngleBtwViews*(iAngle-1);
   SilhouetteRot = zeros(size(Silhouette));
   MatriceRot = [FitRod(4)^2+(1-FitRod(4)^2)*cosd(AngleRot), FitRod(4)*FitRod(5)*(1-cosd(AngleRot))-FitRod(6)*sind(AngleRot), FitRod(4)*FitRod(6)*(1-cosd(AngleRot))+FitRod(5)*sind(AngleRot);...
                FitRod(4)*FitRod(5)*(1-cosd(AngleRot))+FitRod(6)*sind(AngleRot), FitRod(5)^2+(1-FitRod(5)^2)*cosd(AngleRot), FitRod(5)*FitRod(6)*(1-cosd(AngleRot))-FitRod(4)*sind(AngleRot);...
                FitRod(4)*FitRod(6)*(1-cosd(AngleRot))-FitRod(5)*sind(AngleRot), FitRod(5)*FitRod(6)*(1-cosd(AngleRot))+FitRod(4)*sind(AngleRot), FitRod(6)^2+(1-FitRod(6)^2)*cosd(AngleRot)];
   indHeart = find(Silhouette);
   [CoordHeart(:,1),CoordHeart(:,2),CoordHeart(:,3)] = ind2sub(size(Silhouette),indHeart);   
   
   CoordHeartRot = CoordHeart*MatriceRot;   
   ellFitAftRot = inertiaEllipsoid(CoordHeartRot);
   
   TransMatrix = createTranslation3d(indXZero-ellFitAftRot(1), indYZero-ellFitAftRot(2), indZZero-ellFitAftRot(3)); 
   CoordHeartFinal = transformPoint3d(CoordHeartRot,TransMatrix);   
   
   for ii=1:length(indHeart)
      if round(CoordHeartFinal(ii,1))<=0 || round(CoordHeartFinal(ii,2))<=0 || round(CoordHeartFinal(ii,3))<=0
          testCoordNeg = 0;
      else
          SilhouetteRot(round(CoordHeartFinal(ii,1)),round(CoordHeartFinal(ii,2)),round(CoordHeartFinal(ii,3))) = 1;
      end
   end   % Fusion of the datasets
   SilhouetteTotal = SilhouetteTotal+SilhouetteRot;
%    
% fidu = fopen(strcat('Silhouette',num2str(iAngle)),'w');fwrite(fidu,SilhouetteRot,'double');fclose(fidu);
   waitbar(iAngle/numViews,h);
end
SilhouetteTotal(SilhouetteTotal<10) = 0; %Intersection of the datasets define the final silhouette
SilhouetteTotal(SilhouetteTotal>=10) = 1; 
close(h)