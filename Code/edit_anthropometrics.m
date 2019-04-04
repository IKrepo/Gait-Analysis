function [segment_weights, CoM_s_t] = edit_anthropometrics(f_name)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Function for editing data read from the anthropometrics excel file.     %
%                                                                         %
% Inputs:                                                                 %
% 1) f_name          -> table that contains the data for anthropometrics. %
%                                                                         %
% Outputs:                                                                %
% 1) segment_weights -> A cell of arrays containing the weight of each    %
%                       segment expressed as a percentage of the total    %
%                       weight of the patient.                            %
% 2) CoM_s_t         -> Array showing the location of the centre of mass  %
%                       of for the shank and thigh expressed as a         %
%                       percentage measured from proximal point at each   %
%                       segment.                                          %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    part = [ 1 2 3 ]; % segment IDs:  foot = 1; shank = 2; thigh = 3;
    segment_weights = cell({});
    
    for i=1:length(f_name(1,:))-1
        for j = part
            segment_weights{i}(j,:) = [0 0 ...
            str2double(f_name(4+j, i+1))*100/str2double(f_name(4, i+1))];
        end
    end
    CoM_s_t = [0.4340; 0.4330];
end