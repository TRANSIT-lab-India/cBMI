
%% Creating headmodels and running RSBL


% Converts dicom files into .nii 
dicm2nii('C:\Users\tiwar\Desktop\Gokul\Nikunj Experiment\S9007\S9007_MRI\DICOM\','C:\Users\tiwar\Desktop\Gokul\Nikunj Experiment\S9007\S9007_MRI\S9007_dcm2nii\',0);

% Combining all necessary files generated from brainstorm to make .mat file
% that is compatible with the pop_rsbl function.

home = '...anat\Subject01'; 

% Set filenames
filename_skin = fullfile(home,'tess_head_bem_1082V.mat');
filename_outskull = fullfile(home,'tess_outerskull_bem_642V.mat');
filename_inskull = fullfile(home,'tess_innerskull_bem_642V.mat');
filename_cortex = fullfile(home,'tess_cortex_central_low_fix.mat');

load(filename_skin,'Vertices','Faces'); 
scalp = struct('vertices',Vertices,'faces',Faces);
load(filename_outskull,'Vertices','Faces');
outskull = struct('vertices',Vertices,'faces',Faces);
load(filename_inskull,'Vertices','Faces');
inskull = struct('vertices',Vertices,'faces',Faces);
load(filename_cortex,'Vertices','Faces','Atlas');
cortex = struct('vertices',Vertices,'faces',Faces);
montage = load('...\channel.mat');
gainMatrix = load('...\headmodel_surf_openmeeg.mat');

% Find D&K atlas
ind = find(strcmp({Atlas.Name},'Desikan-Killiany'));

% Build the atlas structure
atlas = struct('colorTable',zeros(size(cortex.vertices,1),1),'label',[]);
atlas.label = {Atlas(ind).Scouts.Label};
for roi=1:length(atlas.label)
    atlas.colorTable(Atlas(ind).Scouts(roi).Vertices) = roi;
end

% Build the head model
hm = headModel('channelSpace',[montage.HeadPoints.Loc]','label',{montage.Channel.Name},...
    'scalp',scalp,'outskull',outskull,'inskull',inskull,'cortex',cortex,'atlas',atlas,'version',2);

channelSpace = hm.channelSpace;
labels = hm.labels;
cortex = hm.cortex;
inskull = hm.inskull;
outskull = hm.outskull;
scalp = hm.scalp;
fiducials = hm.fiducials;
atlas=hm.atlas;
hm.K=gainMatrix.Gain;
K=hm.K;
L=hm.L;
version =2;
hm.plot();

% Save the headmodel
save('...headmodel_file.mat', 'channelSpace', 'labels', 'cortex', 'inskull', 'outskull', 'scalp', 'fiducials', 'atlas', 'K', 'L','version'); 

%% Source localization using rsbl

EEG = pop_loadset('...epoched_data.set');

% The headmodel files are generated for each patient using the Brainstorm
% toolbox and computed the leadfield matrix.
EEG.etc.src.hmfile = '...headmodel_file.mat';

EEG = pop_rsbl(EEG, false, true,'power','bsbl',1);

% Saving source localized data
EEG = pop_saveset( EEG8, 'filename','sled_data.set','filepath','path');