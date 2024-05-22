% Correct Script

% Load transition indices and labels
transition_indices = readmatrix('C:\Users\aneva\transition_indices.csv'); % Adjust as needed
labels = readtable('E:\IFC_BF_SSC_BOTH_wCh\Both\WTvsTPM_model_parsed_figs_thisistheonetouse\071223\Figs\AvgPool4_4\labelsforphate.csv', 'ReadVariableNames', false);
labels.Properties.VariableNames = {'Label'}; % Assign a column name to the labels

% Extract transition features
features = readmatrix('E:\IFC_BF_SSC_BOTH_wCh\Both\WTvsTPM_model_parsed_figs_thisistheonetouse\071223\Figs\AvgPool4_4\featuresforphate.csv');

% Convert transition indices to a column vector
transition_indices = transition_indices(:);

% Separate WT and TPM transition cells
wt_indices = transition_indices(strcmp(labels.Label(transition_indices), 'WT'));
tpm_indices = transition_indices(strcmp(labels.Label(transition_indices), 'TPM'));

% Randomly select 10 images from each category
num_images = 10;
wt_selected_indices = wt_indices(randperm(length(wt_indices), min(num_images, length(wt_selected_indices))));
tpm_selected_indices = tpm_indices(randperm(length(tpm_selected_indices), min(num_images, length(tpm_selected_indices))));

% Combine selected indices
selected_indices = [wt_selected_indices; tpm_selected_indices];
selected_labels = [repmat({'WT'}, length(wt_selected_indices), 1); repmat({'TPM'}, length(tpm_selected_indices), 1)];

% Display transition cell images
image_folder = 'E:\IFC_BF_SSC_BOTH_wCh\Both\WTvsTPM_model_parsed_figs_thisistheonetouse\071223\Parsed\Experiment 1\Day 1\Sample A\Replicate 1'; % Adjust to your image folder path
figure;
for i = 1:length(selected_indices)
    subplot(4, 5, i);
    [img_ch1, img_ch2] = load_image_by_index(selected_indices(i), image_folder, selected_labels{i});
    % Display the images side by side
    imshowpair(img_ch1, img_ch2, 'montage'); % Display the images side by side
    title(sprintf('%s Cell %d', selected_labels{i}, selected_indices(i)));
end
