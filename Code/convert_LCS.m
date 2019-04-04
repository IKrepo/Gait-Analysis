function [T, force_LCS, moment_LCS, JA, Mr_Euler] =...
                    convert_LCS (T2, id, trial, patients, n_time_points)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Function for editing data read from the THR excel files.                %
%                                                                         %
% Inputs:                                                                 %
% 1) T2            -> Cell of arrays that contains the data for THR.      %
% 2) id            -> Inverse Dynamics Results:                           %
%                     1) -> 3D intersegmental resultant force at each     %
%                           joint, time point (w.r.t. global CS)          %
%                     2) -> 3D intersegmental resultant force at each     %
%                           joint, time point (w.r.t. global CS)          %
% 3) trial         -> An array containing the actural number of trials    %
%                     for each patient (i.e. [8, 5, 8, 6]                 %
% 4) patients      -> Number of patients  = 4                             %
% 3) n_time_points -> A scalar containing the total number of trials      %
%                          i.e. 201 for every walking trial.              %
%                                                                         %
% Outputs:                                                                %
% 1) T     -> Structure which holds the following elements:               %
%             1) T.R      -> 3x3 rotation matrix                          %
%             2) T.origin -> 3x1 origin (column vector)                   %
%             3) T.M      -> 4x4 homogeneous transformation matrix that   %
%                            combines rotation & translation              %
% 2) Force_LCS  -> Structure containing the coordinates of the force at   %
%                  each joint in the local coordinate system.             %
%                  1) Force_LCS.ankle -> 3x1 array                        %
%                  2) Force_LCS.knee  -> 3x1 array                        %
%                  2) Force_LCS.hip   -> 3x1 array                        %
% 3) Moment_LCS -> Structure containing the coordinates of the moment at  %
%                  each joint in the local coordinate system:             %
%                  1) Moment_LCS.ankle -> 3x1 array                       %
%                  2) Moment_LCS.knee  -> 3x1 array                       %
%                  2) Moment_LCS.hip   -> 3x1 array                       %
% 4) JA        -> Structure containing the joint angles:                  %
%                  1) JA.R_ankle -> 3x3 array                             %
%                  2) JA.R_knee  -> 3x3 array                             %
%                  3) JA.R_hip   -> 3x3 array                             %
% 5) Mr_Euler  ->  Structure theat contains Euler angles:                 %
%                  1) Mr_Euler.Ankle -> 3x1 array                         %
%                  2) Mr_Euler.Knee  -> 3x1 array                         %
%                  3) Mr_Euler.Hip   -> 3x1 array                         %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    tmp_lms    = struct([]);
    T          = struct([]);
    force_LCS  = struct([]);
    moment_LCS = struct([]);
    JA         = struct([]);
    Mr_Euler   = struct([]);
    
    for pat = 1 : patients % Patients = 1
        for cur_trial = 1 : trial(1, pat)  % Walking trials = [2]
            
            % Extract the landmarks for all time points and all patients.
            tmp_lms{pat, cur_trial} =...
                    extract_pt_data_from_data_matrix(T2{pat, cur_trial});
            
            for time = 1 : n_time_points % Loop over all time points.
                
                for segment = 1:4 % foot, shank, thigh, pelvis = 1, 2, 3, 4
                    T{pat, cur_trial}(time, segment).LCS =...
                        determine_local_CS_with_origin(...
                        tmp_lms{pat, cur_trial}(segment).p1(time, :),...
                        tmp_lms{pat, cur_trial}(segment).p2(time, :),...
                        tmp_lms{pat, cur_trial}(segment).p3(time, :),...
                        tmp_lms{pat, cur_trial}(segment).p1(time, :),...
                        segment);
                end
                
                
                % Transforming the inverse dynamics results in the
                % shank / thigh system
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %      Converting Forces and Moments from GCS to LCS      %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                force_LCS{pat, cur_trial}(time).knee =...
                    T{pat, cur_trial}(time, 2).LCS.R * id{pat,...
                    cur_trial}(time, 1).F_prox';
                moment_LCS{pat, cur_trial}(time).knee =...
                    T{pat, cur_trial}(time, 2).LCS.R * id{pat,...
                    cur_trial}(time, 1).M_prox';

                force_LCS{pat, cur_trial}(time).ankle = T{pat,...
                    cur_trial}(time, 2).LCS.R * id{pat,...
                    cur_trial}(time, 2).F_prox';
                moment_LCS{pat, cur_trial}(time).ankle = T{pat,...
                    cur_trial}(time, 2).LCS.R * id{pat,...
                    cur_trial}(time, 2).M_prox';

                force_LCS{pat, cur_trial}(time).hip = T{pat,...
                    cur_trial}(time, 3).LCS.R * id{pat,...
                    cur_trial}(time, 3).F_prox';
                moment_LCS{pat, cur_trial}(time).hip = T{pat,...
                    cur_trial}(time, 3).LCS.R * id{pat,...
                    cur_trial}(time, 3).M_prox';
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %               Calculating Joint Angles                  %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                % foot, shank, thigh, pelvis = 1, 2, 3, 4
                JA{pat, cur_trial}(time).R_knee = T{pat,...
                     cur_trial}(time, 3).LCS.R * T{pat,...
                     cur_trial}(time, 2).LCS.R';
                JA{pat, cur_trial}(time).R_ankle = T{pat,...
                     cur_trial}(time, 1).LCS.R * T{pat,...
                     cur_trial}(time, 2).LCS.R';
                JA{pat, cur_trial}(time).R_hip = T{pat,...
                     cur_trial}(time, 4).LCS.R * T{pat,...
                     cur_trial}(time, 3).LCS.R';
                 
                [t1_knee,  t2_knee,  t3_knee]  = calcEulerAngs(JA{pat,...
                                 cur_trial}(time).R_knee, [1 2 3], true );
                
                [t1_ankle, t2_ankle, t3_ankle] = calcEulerAngs(JA{pat,...
                                 cur_trial}(time).R_ankle, [1 2 3], true );
                
                [t1_hip,   t2_hip,   t3_hip]   = calcEulerAngs(JA{pat,...
                                 cur_trial}(time).R_hip, [1 2 3], true );
                
                Mr_Euler{pat, cur_trial}(time).Knee = [t1_knee,...
                                                       t2_knee,...
                                                       t3_knee];
                
                Mr_Euler{pat, cur_trial}(time).Ankle = [t1_ankle,...
                                                       t2_ankle,...
                                                       t3_ankle];
                
                Mr_Euler{pat, cur_trial}(time).Hip = [t1_hip,...
                                                       t2_hip,...
                                                       t3_hip];
            end
        end
    end
end