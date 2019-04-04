function [id] = inverse_dynamics (segment_kinematics, external_loads,...
                                    n_time_points, segment_weights, trial)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%               Perform Simplified Inverse Dynamics Analysis              %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputs:                                                                 %
% =======                                                                 %
%                                                                         %
% segment_kinematics - 3D locataion of segment origin (w.r.t. global CS)  %
%                      3D orientation of segment (w.r.t. global CS)       %
%                      3D location of CoM (w.r.t. global CS)              %
%                                                                         %
% external loads     - 3D ground reaction force (w.r.t. global CS)        %
%                      3D external moment (w.r.t. global CS)              %
%                      3D location of CoP of GRF (w.r.t. global CS)       %
%                                                                         %
% n_time_points      - scalar, numner of time points for which to         %
%                      perform the analyses (size of data/matrices)       %
%                                                                         %
% segment_weights    - weights of the segments [N]                        %
%                                                                         %
%                                                                         %
% output:                                                                 %
% =======                                                                 %
%                                                                         %
% inverse_dynamics_results                                                %
%                   - 3D intersegmental resultant force at each joint,    % 
%                     time point (w.r.t. global CS)                       %
%                   - 3D intersegmental resultant force at each joint,    % 
%                     time point (w.r.t. global CS)                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

segment_IDs = [1 2 3]; % segment IDs:  foot = 1; shank = 2; thigh = 3;

id = struct([]);
Fseg = cell({});
M_F_Dist = struct([]);
M_Weight = struct([]);

for pat = 1 : length(segment_kinematics(:, 1)) % Patients = 1
    for cur_trial = 1 : trial(1, pat) % Walking trials = [2]
        for time = 1:n_time_points        % Loop over all time points.
            for segment = segment_IDs
                
                % initialise data incl.: loads at distal joint, CoM,
                % joint centres
                switch ( segment )
                case 1
                % foot: apply the external forces % moments
                id{pat, cur_trial}(time, segment).F_dist =...
                                external_loads{pat, cur_trial}(time).F_GRF;
                id{pat, cur_trial}(time, segment).M_dist =...
                                external_loads{pat, cur_trial}(time).M_GRF;
                id{pat, cur_trial}(time, segment).joint_centre_dist =...
                                external_loads{pat, cur_trial}(time).r_GRF;
                id{pat, cur_trial}(time, segment).CoM =...
                    segment_kinematics{pat, cur_trial}(time, segment).CoM;
                id{pat, cur_trial}(time, segment).joint_centre_prox =...
                  segment_kinematics{pat, cur_trial}(time, segment).origin;
                otherwise
                id{pat, cur_trial}(time, segment).F_dist =...
                            -id{pat, cur_trial}(time, segment-1).F_prox;
                id{pat, cur_trial}(time, segment).M_dist =...
                            -id{pat, cur_trial}(time, segment-1).M_prox;
                id{pat, cur_trial}(time, segment).joint_centre_dist =...
                    id{pat, cur_trial}(time, segment-1).joint_centre_prox;
                id{pat, cur_trial}(time, segment).CoM =...
                    segment_kinematics{pat, cur_trial}(time, segment).CoM;
                id{pat, cur_trial}(time, segment).joint_centre_prox =...
                  segment_kinematics{pat, cur_trial}(time, segment).origin;
                end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %        Calculate Intersegmental Resultant Forces        %
                %         additional forces acting on the segment         %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                Fseg{1, pat}(segment, :) =...
                    segment_weights{1, pat}(segment, 3) * [ 0 0 -1 ];
        
                % forces at proximal joint from sum of forces
                id{pat, cur_trial}(time,segment).F_prox = -id{pat,...
                    cur_trial}(time, segment).F_dist - Fseg{1,...
                                                        pat}(segment, :);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %                          END                            %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %      Calculate Intersegmental Resultant Moments         %
                %     calculate moments around the location of the        %
                %                proximal joint centre                    %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                M_F_Dist{pat, cur_trial}(time,segment).distal_force =...
                    cross((-id{pat, cur_trial}(time,...
                    segment).joint_centre_prox + id{pat,...
                    cur_trial}(time, segment).joint_centre_dist),...
                    id{pat, cur_trial}(time, segment).F_dist);
                
                M_Weight{pat, cur_trial}(time, segment).weight =...
                   cross((-id{pat, cur_trial}(time,...
                   segment).joint_centre_prox + id{pat, cur_trial}(time,...
                   segment).CoM),Fseg{1, pat}(segment, :));
               
                % moments at proximal joint from sum of ALL moments
                id{pat, cur_trial}(time, segment).M_prox = -id{pat,...
                   cur_trial}(time, segment).M_dist - M_F_Dist{pat,...
                   cur_trial}(time, segment).distal_force -...
                   M_Weight{pat, cur_trial}(time, segment).weight;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %                          END                            %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
        end
    end
end
end