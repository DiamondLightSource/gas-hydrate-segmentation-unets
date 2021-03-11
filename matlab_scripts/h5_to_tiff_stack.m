%
%% h5 to tiff stack converter
%
%% Start of code
%
% Loading h5 file
waitfor (helpdlg({'Please select HDF file'},'Info'));
[Filename1, pathname1] = uigetfile('*','HDF file');
fileINFO1 = h5info(strcat(pathname1,Filename1));
space = " ";
try
    dataPATH1 = fileINFO1.Name;
    dataNAME1 = fileINFO1.Datasets.Name;
    dataSIZE1 = fileINFO1.Datasets.Dataspace.Size; % X Z Y order
catch
    waitfor (helpdlg({strcat('Unknown file structure in', space, Filename1, '. Programme terminating.')},'Error'));
    return
end
dimX = dataSIZE1(1); dimY = dataSIZE1(2); dimZ = dataSIZE1(3);
%
% Saving location and name
waitfor (helpdlg({'Please select saving directory and rootname'},'Info'));
[resname, savepath] = uiputfile('*.tiff'); % do not change filetype
resname = resname(1:end-5);
%
% Saving
for n = 1:dimZ
   disp(['Saving slice number ', num2str(n-1)]); % print log
   slice = h5read(strcat(pathname1,Filename1), strcat(dataPATH1,'/',dataNAME1), [1 1 n], [dimX dimY 1]);
   slice = slice';
   resnum = sprintf('%04d', n-1);
   imwrite(slice, strcat(savepath,resname,'_',resnum,'.tiff'));
end
