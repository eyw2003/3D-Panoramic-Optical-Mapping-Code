OBJ=write_wobj(OBJ,'MC051220452ActivationMapProjected.obj');

function write_wobj(OBJ,MC051220452ActivationMapProjected)

%%new code
%%filename: MC051220-452ActivationMapProjected.mat

if(exist('MC051220-452ActivationMapProjected','var')==0)
    [MC051220-452ActivationMapProjected,PanoramicImagingGUIv10] = uiputfile('*.obj', 'Write obj-file');
     MC051220-452ActivationMapProjected = [geom3d MC051220-452ActivationMapProjected];
end
[filefolder,filename] = fileparts(MC051220-452ActivationMapProjected);
comments=cell(1,4);
comments{1} = 'Matlab Write WObj exporter';
comments{2} = '';
fid = fopen(fullfilename,'MC051220-452ActivationMapProjected');
write_comment(fid,comments);
if(isfield(OBJ,'material')&&~isempty(OBJ.material))
    filename_mtl=fullfile(filefolder,[filename '.mtl']);
    fprintf(fid,'mtllib%s\n',filename_mtl);
    write_MTL_file(filename_mtl,OBJ.material)
end
if(isfield(OBJ,'vertices')&&~isempty(OBJ.vertices))
    write_vertices(fid,OBJ.vertices,'v');
end
if(isfield(OBJ,'vertices_point')&&~isempty(OBJ.vertices_point))
    write_vertices(fid,OBJ.vertices_point,'vp');
end
if(isfield(OBJ,'vertices_normal')&&~isempty(OBJ.vertices_normal))
    write_vertices(fid,OBJ.vertices_normal,'vn');
end
if(isfiled(OBJ,'vertices_texture')&&~isempty(OBJ.vertices_texture))
    writevertices(fid,OBJ.vertices_texture,'vt');
end
for i=1:length(OBJ.objects)
    type=OBJ.objects(i).type;
    data=OBJ.objects(i).data;
    switch(type)
        case 'usemtl'
            fprintf(fid,'usemtl %s\n',data);
        case 'MC051220-452ActivationMapProjected'
            check1=(isfield(OBJ,'vertices_texture')&&~isempty(OBJ.vertices_texture));
            check2=(isfield(OBJ,'vertices_normal')&&~isempty(OBJ.vertices_normal));
            if(check1&&check2)
                for j=1:size(data.vertices,1)
                    fprintf(fid,'f %d/%d/%d',data.vertices(j,1),data.texture(j,1),data.normal(j,1));
                    fprintf(fid,' %d/%d/%d', data.vertices(j,2),data.texture(j,2),data.normal(j,2));
                    fprintf(fid,' %d/%d/%d\n', data.vertices(j,3),data.texture(j,3),data.normal(j,3));
                end
            elseif(check1)
                for j=1:size(data.vertices,1)
                    fprintf(fid,'f %d/%d',data.vertices(j,1),data.texture(j,1));
                    fprintf(fid,' %d/%d', data.vertices(j,2),data.texture(j,2));
                    fprintf(fid,' %d/%d\n', data.vertices(j,3),data.texture(j,3));
                end
            elseif(check2)
                for j=1:size(data.vertices,1)
                    fprintf(fid,'f %d//%d',data.vertices(j,1),data.normal(j,1));
                    fprintf(fid,' %d//%d', data.vertices(j,2),data.normal(j,2));
                    fprintf(fid,' %d//%d\n', data.vertices(j,3),data.normal(j,3));
                end
            else
                for j=1:size(data.vertices,1)
                    fprintf(fid,'f %d %d %d\n',data.vertices(j,1),data.vertices(j,2),data.vertices(j,3));
                end
            end
        otherwise
            fprintf(fid,'%s ',type);
            if(iscell(data))
                for j=1:length(data)
                    if(ischar(data{j}))
                        fprintf(fid,'%s ',data{j});
                    else
                        fprintf(fid,'%0.5g ',data{j});
                    end
                end 
            elseif(ischar(data))
                 fprintf(fid,'%s ',data);
            else
                for j=1:length(data)
                    fprintf(fid,'%0.5g ',data(j));
                end      
            end
            fprintf(fid,'\n');
    end
end
     
fclose(fid);

%%%%write MTL later...
function write_MTL_file(filename,material)
fid = fopen(filename,'w');
comments=cell(1,2);
comments{1}=' Produced by Matlab Write Wobj exporter ';
comments{2}='';
write_comment(fid,comments);
for i=1:length(material)
    type=material(i).type;
    data=material(i).data;
    switch(type)
        case('newmtl')
            fprintf(fid,'%s ',type);
            fprintf(fid,'%s\n',data);
        case{'Ka','Kd','Ks'}
            fprintf(fid,'%s ',type);
            fprintf(fid,'%5.5f %5.5f %5.5f\n',data);
        case('illum')
            fprintf(fid,'%s ',type);
            fprintf(fid,'%d\n',data);
        case {'Ns','Tr','d'}
            fprintf(fid,'%s ',type);
            fprintf(fid,'%5.5f\n',data);
        otherwise
            fprintf(fid,'%s ',type);
            if(iscell(data))
                for j=1:length(data)
                    if(ischar(data{j}))
                        fprintf(fid,'%s ',data{j});
                    else
                        fprintf(fid,'%0.5g ',data{j});
                    end
                end 
            elseif(ischar(data))
                fprintf(fid,'%s ',data);
            else
                for j=1:length(data)
                    fprintf(fid,'%0.5g ',data(j));
                end      
            end
            fprintf(fid,'\n');
    end
end

comments=cell(1,2);
comments{1}='';
comments{2}=' EOF';
write_comment(fid,comments);
fclose(fid);
function write_comment(fid,comments)
for i=1:length(comments), fprintf(fid,'# %s\n',comments{i}); end
function write_vertices(fid,V,type)
switch size(V,2)
    case 1
        for i=1:size(V,1)
            fprintf(fid,'%s %5.5f\n', type, V(i,1));
        end
    case 2
        for i=1:size(V,1)
            fprintf(fid,'%s %5.5f %5.5f\n', type, V(i,1), V(i,2));
        end
    case 3
        for i=1:size(V,1)
            fprintf(fid,'%s %5.5f %5.5f %5.5f\n', type, V(i,1), V(i,2), V(i,3));
        end
    otherwise
end
switch(type)
    case 'v'
        fprintf(fid,'# %d vertices \n', size(V,1));
    case 'vt'
        fprintf(fid,'# %d texture verticies \n', size(V,1));
    case 'vn'
        fprintf(fid,'# %d normals \n', size(V,1));
    otherwise
        fprintf(fid,'# %d\n', size(V,1));
        
end
    
