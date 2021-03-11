%
%% Comparison of U-Net segmentation and ground truth of gas hydrate sample XCT data
% Requirements: (1) U-Net and ground truth data may be read as either a 
% tiff stack or a single .h5 file. (2) Folders containing tiff stacks must 
% contain all 2000 XY slices and slice names should end in numbers ranging 
% from *0000.tiff to *2000.tiff. (4) .h5 file data path must be simply 
% /data. (5) U-Net output must include all 2000 XY slices. (6) label ids 
% are 0 = sand; 1 = brine; 2 = CH4 gas.
%
%% Start of code
close all
clc
%
% Opening u-net results
waitfor (helpdlg({'Please select U-Net results file'},'Info'));
[Filename1, pathname1] = uigetfile('*','Select U-Net results');
space = " ";
if contains(Filename1,'.h5')
    fileINFO1 = h5info(strcat(pathname1,Filename1));
    try
        dataPATH1 = fileINFO1.Name;
        dataNAME1 = fileINFO1.Datasets.Name;
        dataSIZE1 = fileINFO1.Datasets.Dataspace.Size; % X Z Y order
    catch
        waitfor (helpdlg({strcat('Unknown file structure in', space, Filename1, '. Programme terminating.')},'Error'));
        return
    end
    dimX = dataSIZE1(1); dimY = dataSIZE1(2); dimZ = dataSIZE1(3);
elseif contains(Filename1,'.tif')
    [numslice, slice0, justtext, slicelist1] = slicecount(pathname1, Filename1);
else
    waitfor (helpdlg({'Unknown filetype (can only handle h5 and tif). Programme terminating'},'Error'));
    return    
end
%
% Opening validation data
waitfor (helpdlg({'Please select ground truth results file'},'Info'));
[Filename2, pathname2] = uigetfile('*','Select ground truth XY tomoslice');
if contains(Filename2,'.h5')
    fileINFO2 = h5info(strcat(pathname2,Filename2));
    try
        dataPATH2 = fileINFO2.Name;
        dataNAME2 = fileINFO2.Datasets.Name;
        dataSIZE2 = fileINFO2.Datasets.Dataspace.Size; % X Z Y order
    catch
        space = " ";
        waitfor (helpdlg({strcat('Unknown file structure in', space, Filename2, '. Programme terminating.')},'Error'));
        return
    end
    dimX = dataSIZE2(1); dimY = dataSIZE2(2); dimZ = dataSIZE2(3);
elseif contains(Filename2,'.tif')
    [numslice, slice0, justtext, slicelist2] = slicecount(pathname2, Filename2);
else
    waitfor (helpdlg({'Unknown filetype (can only handle h5 and tif). Programme terminating'},'Error'));
    return    
end
%
%
%% Carrying out comparison
% Results preallocation
res_sand = zeros(40,7);
res_brine = zeros(40,7);
res_ch4 = zeros(40,7);
m = 0;
for n = 980:1019
    disp(['Slice ', num2str(n),' evaluated']); %print log
    m = m + 1;       
    if contains(Filename2,'.h5')
        slice_val = h5read(strcat(pathname2,Filename2), strcat(dataPATH2,'/',dataNAME2), [1 1 (n - 979)], [dimX dimY 1]);
        slice_val = slice_val';
    else
        slice_val = imread(strcat(slicelist2(n + 1).folder,'\',slicelist2(n + 1).name));
    end    
    if contains(Filename1,'.h5')
        slice_unet = h5read(strcat(pathname1,Filename1), strcat(dataPATH1,'/',dataNAME1), [1 1 n], [dimX dimY 1]);
        slice_unet = slice_unet';
    else
        slice_unet = imread(strcat(slicelist1(n + 1).folder,'\',slicelist1(n + 1).name));
    end
    
    % comparing sand
    comp_sand_tp = (slice_val == 0).*(slice_unet == 0); % True positive sand
    comp_sand_tn = (slice_val ~= 0).*(slice_unet ~= 0); % True negative sand
    comp_sand = (slice_val == 0)~=(slice_unet == 0); % False positive and false negative sand
    comp_sand_sep = (slice_val+1).*uint8(comp_sand);
    tp_sand = length(find(comp_sand_tp == 1));
    tn_sand = length(find(comp_sand_tn == 1));
    fn_sand = length(find(comp_sand_sep == 1));
    fp_sand = length(find(comp_sand_sep == 2)) + length(find(comp_sand_sep == 3));
    accuracy_sand = (tp_sand + tn_sand)/(tp_sand + tn_sand + fp_sand + fn_sand);
    jaccard_i_sand = tp_sand/(tp_sand + fp_sand + fn_sand);
    res_sand(m,:) = [fn_sand, length(find(comp_sand_sep == 2)),length(find(comp_sand_sep == 3)),...
        tp_sand, tn_sand, accuracy_sand, jaccard_i_sand];
    % comparing brine
    comp_brine_tp = (slice_val == 1).*(slice_unet == 1); % True positive brine
    comp_brine_tn = (slice_val ~= 1).*(slice_unet ~= 1); % True negative brine
    comp_brine = (slice_val == 1)~=(slice_unet == 1);
    comp_brine_sep = (slice_val+1).*uint8(comp_brine);
    tp_brine = length(find(comp_brine_tp == 1));
    tn_brine = length(find(comp_brine_tn == 1));
    fn_brine = length(find(comp_brine_sep == 2));
    fp_brine = length(find(comp_brine_sep == 1)) + length(find(comp_brine_sep == 3));
    accuracy_brine = (tp_brine + tn_brine)/(tp_brine + tn_brine + fp_brine + fn_brine);
    jaccard_i_brine = tp_brine/(tp_brine + fp_brine + fn_brine);
    res_brine(m,:) = [fn_brine, length(find(comp_brine_sep == 1)), length(find(comp_brine_sep == 3)),...
        tp_brine, tn_brine, accuracy_brine, jaccard_i_brine];
    % comparing methane
    comp_ch4_tp = (slice_val == 2).*(slice_unet == 2); % True positive methane
    comp_ch4_tn = (slice_val ~= 2).*(slice_unet ~= 2); % True negative methane
    comp_ch4 = (slice_val == 2)~=(slice_unet == 2);
    comp_ch4_sep = (slice_val+1).*uint8(comp_ch4);
    tp_ch4 = length(find(comp_ch4_tp == 1));
    tn_ch4 = length(find(comp_ch4_tn == 1));
    fn_ch4 = length(find(comp_ch4_sep == 3));
    fp_ch4 = length(find(comp_ch4_sep == 1)) + length(find(comp_ch4_sep == 2));
    accuracy_ch4 = (tp_ch4 + tn_ch4)/(tp_ch4 + tn_ch4 + fp_ch4 + fn_ch4);
    jaccard_i_ch4 = tp_ch4/(tp_ch4 + fp_ch4 + fn_ch4);
    res_ch4(m,:) = [fn_ch4, length(find(comp_ch4_sep == 1)), length(find(comp_ch4_sep == 2)),...
        tp_ch4, tn_ch4, accuracy_ch4, jaccard_i_ch4];
end
% results table
T = table(res_sand(:,1),res_sand(:,2),res_sand(:,3),res_sand(:,4),res_sand(:,5),res_sand(:,6),res_sand(:,7),...
    res_brine(:,1),res_brine(:,2),res_brine(:,3),res_brine(:,4),res_brine(:,5),res_brine(:,6),res_brine(:,7),...
    res_ch4(:,1),res_ch4(:,2),res_ch4(:,3),res_ch4(:,4),res_ch4(:,5),res_ch4(:,6),res_ch4(:,7),...
    'VariableNames',...
    {'False_neg_sand','MislabelledBrine-1','MislabelledCH4-1','True_pos_sand','True_neg_sand','Accuracy_sand','Jaccard_index_sand',...
    'False_neg_brine','MislabelledSand-2','MislabelledCH4-2','True_pos_brine','True_neg_brine','Accuracy_brine','Jaccard_index_brine',...
    'False_neg_ch4','MislabelledSand-3','MislabelledBrine-3','True_pos_ch4','True_neg_ch4','Accuracy_ch4','Jaccard_index_ch4'});
answ = questdlg(strcat('Save results in', space, pathname1, ' ?'),'Warning','YES','NO','YES');
switch answ
    case 'YES'
        writetable(T,strcat(pathname1,'\',justtext(1:5),'_','u-net-comp.xlsx'),'Sheet',1,'Range','B1');
        disp('Programme finalised successfully. Results saved.');
    case 'NO'
        disp('Programme finalised successfully. Results not saved.');
end
%% Functions
function [numslice, slice0, justname, slicelist] = slicecount(pathname, Filename)
filetype = ismember(Filename,'.'); % checking where file type starts
for n = 1:length(filetype)
    if filetype(n) == 1
        break
    end
end
justname = Filename(1:n-1); % getting the name, which may contain numbers
justname = justname(1:end-4); % getting the part of the name which is just letters, i.e. the 'handle'
slicelist = dir([pathname justname '*']); % counting the number of images in folder with such handle
slice0 = imread(strcat(pathname,Filename)); % read supplied first image
numslice = size(slicelist,1);
end
