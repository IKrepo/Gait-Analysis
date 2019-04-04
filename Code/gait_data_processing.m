%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         gait_data_processing.m                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% This matlab code presents a series of data processing steps, for        %
% processing THR patient gait data, but also data from healthy adult.     %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          !!! MAIN PROGRAM !!!                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; clc; close all;
opengl software % Simple graphic editor for faster results


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Directory for the results                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Showing to Matlab the direcory where the created files are to be saved.
output_dir_plots = 'C:\Users\giann\Desktop\\Results_Plots\';
output_dir_tables = 'C:\Users\giann\Desktop\Results_Tables\';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    Processing anthropometrics.xlsx                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Showing to Matlab the direcory where the anthropometrics file is located.
input_dir_data = 'C:\Users\giann\Desktop\Input_Data\';

% Define the name of the excel file to be read.
file = 'anthropometrics.xlsx';

% Combine the two strings to form the filename including the full path.
filename = [input_dir_data file];
T1 = readtable(filename);

% Now convert the content of the table to cells.
% Filenames/strings will be easier to handle that way.
f_name = table2array(T1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Processing THR_patient folder                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input_dir = 'C:\Users\giann\Desktop\THR\';
               
files = dir( fullfile(input_dir,'*.xlsx') );  % list all *.xlsx files
files = {files.name}';                        % ' file names

activity_str   = { 'Walking' };

% the index identifies patients
trial_IDs{1}=[1,2]; % Patient 1 Walking

T2 = cell({});
data = cell({});

info_str = sprintf('\n\nCool method: reading specified XLSX files\n');
disp(info_str);
for pat=1
    t=1;
    for trial=trial_IDs{pat}
        file      = [ 'Patient_' num2str(pat) '_'  activity_str{1} '_'...
                        num2str(trial, '%02d') '.xlsx' ];
        filename  = [ input_dir file ];
        
        info_str = sprintf('Reading file: %s', filename);
        disp(info_str);
        
        T2{pat,t}    = readtable(filename);
        data{pat,t} = table2array(T2{pat,t});
                    
        t = t+1;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Processing Healthy Young Male Data                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input_dir_healthy = 'C:\Users\giann\Desktop\Healthy\';
               
files_healthy = dir( fullfile(input_dir_healthy,'*.xlsx') );
files_healthy = {files_healthy.name}';

data_healthy = cell({});

info_str = sprintf('\n\nHealthy Subject: reading specified XLSX files\n');
disp(info_str);
for f=1:3
    fname_healthy = fullfile(input_dir_healthy,files_healthy{f});
    info_str = sprintf('Reading file: %s', fname_healthy);
    disp(info_str);
    T_healthy = readtable( fname_healthy, 'ReadRowNames', false,...
                                  'ReadVariableNames', true );
    data_healthy{f} = table2array(T_healthy);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            !!! Main Code !!!                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[segment_weights, CoM_s_t] = edit_anthropometrics(f_name);

[segment_kinematics, external_loads, n_time_points, trial] =...
                                                  edit_data(data, CoM_s_t);

[id] = inverse_dynamics (segment_kinematics, external_loads,...
                                    n_time_points, segment_weights, trial);

[T, force_LCS, moment_LCS, JA, Mr_Euler] =...
                           convert_LCS (T2, id, trial, pat, n_time_points);

plot_2d_results (data, data_healthy, trial, force_LCS, moment_LCS,...
                                                         output_dir_plots);

plot_3d_results (data, id, n_time_points, output_dir_plots);

vectors_2d_3d(data, T, force_LCS, moment_LCS, output_dir_plots);

plot_animation(data, T, external_loads, force_LCS, moment_LCS, Mr_Euler);

save_tables(data, pat, trial, T, force_LCS, moment_LCS, JA, Mr_Euler,...
                                                       output_dir_tables);