function [ lm ] = extract_pt_data_from_data_matrix(T)
% extracts point/landmark locations from full data data matrix
% input : Table T, 201xn_vars
% output: structure lm 

data     = table2array(T);
% n_frames = height(T);

pt_base_idx = 19; % first column with point coordinates (P1_X)

%--------------------------------------------------------------------------
% pelvis pts
%--------------------------------------------------------------------------
segment = 4; % pelvis is segment 4

p1 = data(:,pt_base_idx:pt_base_idx+2);    % P1
p2 = data(:,pt_base_idx+3:pt_base_idx+5);  % P2
p3 = data(:,pt_base_idx+6:pt_base_idx+8);  % P3

lm(segment).p1 = p1;
lm(segment).p2 = p2;
lm(segment).p3 = p3;

%--------------------------------------------------------------------------
% thigh/femur pts
%--------------------------------------------------------------------------
segment = 3; % thigh/femur is segment 3

p1 = data(:,pt_base_idx+6:pt_base_idx+8);   % P3
p2 = data(:,pt_base_idx+9:pt_base_idx+11);  % P5
p3 = data(:,pt_base_idx+12:pt_base_idx+14); % P7

lm(segment).p1 = p1;
lm(segment).p2 = p2;
lm(segment).p3 = p3;

%--------------------------------------------------------------------------
% shank/tibia pts
%--------------------------------------------------------------------------
segment = 2; % shank/tibia is segment 2

p1 = data(:,pt_base_idx+12:pt_base_idx+14); % P7
p2 = data(:,pt_base_idx+15:pt_base_idx+17); % P11
p3 = data(:,pt_base_idx+18:pt_base_idx+20); % P17

lm(segment).p1 = p1;
lm(segment).p2 = p2;
lm(segment).p3 = p3;

%--------------------------------------------------------------------------
% foot pts
%--------------------------------------------------------------------------
segment = 1; % foot is segment 2

p1 = data(:,pt_base_idx+18:pt_base_idx+20); % P17
p2 = data(:,pt_base_idx+21:pt_base_idx+23); % P19
p3 = data(:,pt_base_idx+24:pt_base_idx+26); % P21

lm(segment).p1 = p1;
lm(segment).p2 = p2;
lm(segment).p3 = p3;

end