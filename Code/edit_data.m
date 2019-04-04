function [segment_kinematics, external_loads, n_time_points, trial] =...
                                                edit_data(data, CoM_s_t)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Function for editing data read from the THR excel files.                %
%                                                                         %
% Inputs:                                                                 %
% 1) data    -> Table that contains the data for THR                      %
% 2) CoM_s_t -> Array showing the location of the centre of mass for the  %
%               shank and thigh expressed as a percentage measured from   %
%               proximal point at each segment.                           %
%                                                                         %
% Outputs:                                                                %
% 1) segment_kinematics -> A structure of arrays containing:              %
%                          1) .origin -> Coordinates of the segment       %
%                                        origin for foot shank and thigh. %
%                          2) .CoM    -> Centre of mass for each segment  %
% 2) external_loads     -> A structure of arrays containing:              %
%                          1) .F_GRF  -> 3 force components of the ground %
%                                        reaction force at the left food. %
%                          2) .M_GRF  -> The free external moment at the  %
%                                        left foot.                       %
% 3) n_time_points      -> A scalar containing the total number of trials %
%                          i.e. 201 for every walking trial.              %
% 4) trial              -> An array containing the actural number of      %
%                          trials for each patient                        %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    segment_kinematics = struct([]);
    external_loads = struct([]);

    n_time_points = length(data{1, 1});
    part = [1 2 3]; % part:  foot = 1; shank = 2; thigh = 3;
    trial = zeros();

    for ii = 1 : length(data(:, 1))       % From 1 - (number of patients)
        for jj = 1 : length(data(ii, :))  % Walking trials
            if cellfun(@isempty, data(ii,jj)) == 0
                trial(1, ii) = trial(1, ii) + 1;
            end
        end % At the end, walking trials = walking trials of every patient.
    end

    for pat = 1 : length(data(:, 1))       % Patients = 1
        for cur_trial = 1 : trial(1, pat)  % Walking trials
            for i = 1 : length(data{1, 1}) % Time discretizations = 201
                for j = part

                    segment_kinematics{pat, cur_trial}(i, j).origin =...
                        data{pat, cur_trial}(i, ((43:45)-6*j));
                    % P17, P7, P3 respectively (i.e proximal)

                    if j == 1 % Foot
                        segment_kinematics{pat, cur_trial}(i, j).CoM =...
                            (data{pat, cur_trial}(i, 37:39) +...
                            data{pat, cur_trial}(i, 40:42) +...
                            data{pat, cur_trial}(i, 43:45))/3;
                        
                        external_loads{pat, cur_trial}(i, j).F_GRF =...
                            data{pat, cur_trial}(i, 3:5);
                        
                        external_loads{pat, cur_trial}(i).M_GRF =...
                            [0 0 data{pat, cur_trial}(i, 6)];
                        
                        external_loads{pat, cur_trial}(i).r_GRF =...
                            data{pat, cur_trial}(i, 7:9);
                    else
                        segment_kinematics{pat, cur_trial}(i, j).CoM =...
                            data{pat, cur_trial}(i, ((43:45)-6*j)) -...
                            CoM_s_t((j-1), pat) *...
                            (data{pat, cur_trial}(i, ((43:45)-6*j)) -...
                            data{pat, cur_trial}(i, ((43:45)-6*(j-1))));
                    end
                end
            end
        end
    end
end
