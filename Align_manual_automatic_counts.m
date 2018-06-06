clear all


% Get manual counts
csv_files = list_files('Dirname', 'sample_data', 'Pattern', {'.csv'}, 'FullPath', true);


img_files = list_files('Dirname', 'sample_img', 'Pattern', {'.tif'}, 'FullPath', true);

% We don't have the 20X counts yet

img_files = img_files(1:3);

% Get the automatic counts
% automatic_files = list_files('Pattern', {'DAPI_[0-9].mat'}, 'FullPath', true);

automatic_files = string(ls('*.mat'));

automatic_files = automatic_files(1:3);

% Make a cell to store things

results = cell(length(csv_files),1);

% Do alignments 

for ii=1:length(csv_files)

% load the image    
img = imread(img_files{ii});    

% load the source data

source = readtable(csv_files{ii});

% Source is manual counts
source = [source.X source.Y];

% Target is automatic counting
target_struct = load(automatic_files{ii});

% get the centroids from struct
target = table2array(target_struct.centroids);

% We align the dots using a threshold. Accelerates math and constrains
% alignments

[target_indices, target_distances, unassigned_targets, total_cost] = hungarianlinker(source, target, 10);

% transpose things into column vectors

target_indices = target_indices';
unassigned_targets = unassigned_targets';

% We will get the assigned values
% target_indices will have -1 if not assigned, so we subset those out

assigned_rows = target_indices(target_indices>0);

%% Plot the alignment
figure
imshow(img)
hold on
plot(source(:,1), source(:,2), 'wo')
plot(target(:,1), target(:,2), 'ro')
plot(target(assigned_rows, 1), target(assigned_rows, 2), 'r+')
l1 = legend('Location', 'southoutside', ...
            '\color{white} Manual counts', ...
            '\color{red} Automatic Counts', ... 
            '\color{red} Aligned counts');
set(l1,'color','black');
hold off

%% Calculate stuff

% Manual count is 'gold standard'
% Note that counts could easily be wrong and/or highly variable between
% human counters. Thus, we want ~ 80% true positive proportion

manual_count = size(source, 1);
automatic_count = size(target, 1);

% 'False' discoveries means computer saw something human didn't
% Take with grain of salt...
false_discoveries = size(unassigned_targets, 1);

% True positives are the aligned in both datasets
true_positives = size(assigned_rows, 1);

% True positive rate is true_positives/manual_count
TPR = true_positives/manual_count;

% False positive rate is the 'false' discoveries 
FDR = false_discoveries/automatic_count;


%% Get the data out

results{ii}.csv_file = csv_files{ii};
results{ii}.img_file = img_files{ii};
results{ii}.automatic_file = automatic_files{ii};
results{ii}.source = source;
results{ii}.target = target;
results{ii}.target_indices = target_indices;
results{ii}.assigned_rows = assigned_rows;
results{ii}.unassigned_targets = unassigned_targets;

% stats

results{ii}.manual_count = manual_count;
results{ii}.automatic_count = automatic_count;
results{ii}.false_discoveries = false_discoveries;
results{ii}.true_positives = true_positives;
results{ii}.TPR = TPR;
results{ii}.FDR = FDR;


end

