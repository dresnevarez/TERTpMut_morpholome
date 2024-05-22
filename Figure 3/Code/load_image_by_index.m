function [img_ch1, img_ch2] = load_image_by_index(index, image_folder, class_label)
    % Determine the class subdirectory
    if strcmp(class_label, 'WT')
        subdir = 'Class WT';
        subdir_suffix = 'WT';
    elseif strcmp(class_label, 'TPM')
        subdir = 'Class TPM';
        if index <= 5000
            subdir_suffix = 'C228T';
        else
            subdir_suffix = 'C250T';
        end
    else
        error('Unknown class label');
    end

    % Construct file patterns
    file_pattern_ch1 = sprintf('%s_%d_Ch1*.mat', subdir_suffix, index); % Adjust based on actual naming convention
    file_pattern_ch2 = sprintf('%s_%d_Ch2*.mat', subdir_suffix, index); % Adjust based on actual naming convention

    % Get the directory and file info for Ch1
    dir_path = fullfile(image_folder, subdir);
    file_info_ch1 = dir(fullfile(dir_path, file_pattern_ch1));

    % Get the directory and file info for Ch2
    file_info_ch2 = dir(fullfile(dir_path, file_pattern_ch2));

    % Debugging output
    fprintf('Searching for files in: %s\n', dir_path);
    fprintf('Files found for Ch1: %d\n', length(file_info_ch1));
    fprintf('Files found for Ch2: %d\n', length(file_info_ch2));

    if isempty(file_info_ch1)
        error('Expected files for index %d in class %s, but found none for Ch1', index, class_label);
    end
    if isempty(file_info_ch2)
        error('Expected files for index %d in class %s, but found none for Ch2', index, class_label);
    end

    % Load the image data
    full_path_ch1 = fullfile(file_info_ch1(1).folder, file_info_ch1(1).name); % Select the first match
    full_path_ch2 = fullfile(file_info_ch2(1).folder, file_info_ch2(1).name); % Select the first match
    img_data_ch1 = load(full_path_ch1);
    img_data_ch2 = load(full_path_ch2);

    % Ensure 'new' field exists and has at least one channel
    if isfield(img_data_ch1, 'new') && size(img_data_ch1.new, 3) >= 1 && isfield(img_data_ch2, 'new') && size(img_data_ch2.new, 3) >= 1
        % Extract Channel 1 and Channel 2, and apply image normalization using mat2gray
        img_ch1 = mat2gray(img_data_ch1.new(:,:,1)); % Normalization for Ch1
        img_ch2 = mat2gray(img_data_ch2.new(:,:,1)); % Normalization for Ch2
    else
        error('Expected at least one channel in the ''new'' field for index %d in class %s', index, class_label);
    end
end
