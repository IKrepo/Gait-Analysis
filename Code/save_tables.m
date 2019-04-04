function [] = save_tables(data, patients, trial, T, force_LCS,...
                          moment_LCS, JA, Mr_Euler, output_dir_tables)

Euler_Angles_Knee  = zeros(603,3);
Euler_Angles_Ankle = zeros(603,3);
Euler_Angles_Hip   = zeros(603,3);

% Creating the tables and saving the results in excel files.
sum1 = 1;
sum2 = 0;
for pat = 1 : patients % Patients = 1
    for cur_trial = 1 : trial(1, pat)     % Walking trials = [2]
        for time = 1 : length(data{1, 1}) % Loop over all time points.
            
            Transformation_Foot(sum1 : time*4, :) =...
                                        T{pat, cur_trial}(time, 1).LCS.M;
            Transformation_Shank(sum1 : time*4, :) =...
                                        T{pat, cur_trial}(time, 2).LCS.M;
            Transformation_Thigh(sum1 : time*4, :) =...
                                        T{pat, cur_trial}(time, 3).LCS.M;
            Transformation_Pelvis(sum1 : time*4, :) =...
                                        T{pat, cur_trial}(time, 4).LCS.M;
                                    
            sum1 = sum1 + 4;
                   
            Euler_Angles_Knee(sum2 + time,:)  = Mr_Euler{pat,...
                                                    cur_trial}(time).Knee;
            Euler_Angles_Ankle(sum2 + time,:) = Mr_Euler{pat,...
                                                    cur_trial}(time).Ankle;
            Euler_Angles_Hip(sum2 + time,:)   = Mr_Euler{pat,...
                                                    cur_trial}(time).Hip;
        
        sum2 = sum2 + 2;
        
        end
        sum1 = 1;
        sum2 = 0;
        
        Force_LCS_Ankle = cat(1, force_LCS{pat, cur_trial}.ankle);
        Force_LCS_Knee  = cat(1, force_LCS{pat, cur_trial}.knee);
        Force_LCS_Hip   = cat(1, force_LCS{pat, cur_trial}.hip);

        Moment_LCS_Ankle = cat(1, moment_LCS{pat, cur_trial}.ankle);
        Moment_LCS_Knee  = cat(1, moment_LCS{pat, cur_trial}.knee);
        Moment_LCS_Hip   = cat(1, moment_LCS{pat, cur_trial}.hip);

        Joint_Angles_R_Ankle = cat(1, JA{pat, cur_trial}.R_ankle);
        Joint_Angles_R_Knee  = cat(1, JA{pat, cur_trial}.R_knee);
        Joint_Angles_R_Hip   = cat(1, JA{pat, cur_trial}.R_hip);
        
        
        T_out_1 = table(Transformation_Foot, Transformation_Shank,...
                        Transformation_Thigh, Transformation_Pelvis);
        out_file_1 = [output_dir_tables 'Transformation_Table_Patient_'...
                      num2str(pat) '_Case_' num2str(cur_trial) '.xlsx'];
        writetable(T_out_1, out_file_1);

        
        T_out_2 = table(Force_LCS_Ankle, Force_LCS_Knee, Force_LCS_Hip,...
                        Moment_LCS_Ankle, Moment_LCS_Knee,...
                        Moment_LCS_Hip);
        out_file_2 = [output_dir_tables...
                      'LCS-Forces-Moments_Patient' num2str(pat)...
                      '_Case_' num2str(cur_trial) '.xlsx'];
        writetable(T_out_2, out_file_2);
        
        
        T_out_3 = table(Joint_Angles_R_Ankle, Joint_Angles_R_Knee,...
                        Joint_Angles_R_Hip, Euler_Angles_Knee,...
                        Euler_Angles_Ankle, Euler_Angles_Hip);
        out_file_3 = [output_dir_tables...
                      'LCS-Joint_and Euler_Angles_Patient' num2str(pat)...
                      '_Case_' num2str(cur_trial) '.xlsx'];
        writetable(T_out_3, out_file_3);
    end
end
end
                