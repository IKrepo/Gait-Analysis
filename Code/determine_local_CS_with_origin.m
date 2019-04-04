function [ T ] = determine_local_CS_with_origin( p1, p2, p3, ori, segment )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculates the transformation T to a local coordinate     %
% system, dependent upon the segment for which the LCS is defined         %
%-------------------------------------------------------------------------%
% input: p1      1x3 (1st point for defining local CS)                    %
%        p2      1x3 (2nd point for defining local CS)                    %
%        p3      1x3 (3rd point for defining local CS)                    %
%        ori     1x3 (origin of the local coordinate system)              %
%        segment 1x1 (used to switch method)                              %
%-------------------------------------------------------------------------%
% !!! The output is arranged to be applied to vector data                 %
%     given as COLUMN VECTORS !!!                                         %
%-------------------------------------------------------------------------%
% The results are returned in a structure, named "T",                     %
% which holds the following elements:                                     %
% T.R          : 3x3 rotation matrix                                      %
% T.origin     : 3x1 origin (column vector)                               %
% T.M          : 4x4 homogeneous transformation matrix that combines      %
%                    rotation & translation                               %
%-------------------------------------------------------------------------%
% v0.1 (c) 09.03.2018 Markus O. Heller m.o.heller@soton.ac.uk             %
%-------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generally ex is roughly aligned with AP, 
%           ey is roughly aligned with ML, and
%           ez is roughly aligned with SI direction


switch ( segment )
    
    case 1 % foot P17,19,21   % Based on description.
%         ex = (p3-p2)/norm(p3-p2);
%         ez_tmp = (p1-p2)/norm(p1-p2);
%         ey = cross(ex,ez_tmp);
%         ey = ey/norm(ey);
%         ez = cross(ey,ex);
%         ez = ez/norm(ez);
        
        ey = (p3-p2)/norm(p3-p2); % Based on fig. 2 of scientific paper.
        ez_tmp = (p1-p2)/norm(p1-p2);
        ex = cross(ey,ez_tmp);
        ex=ex/norm(ex);
        ez=cross(ex,ey);
        ez=ez/norm(ez);
        
    case 2 % shank P7,11,17
        ez = (p1-p3)/norm(p1-p3); % Description and scientific paper agree.
        ey_tmp = (p1-p2)/norm(p1-p2);
        ex = cross(ey_tmp,ez);
        ex = ex/norm(ex);
        ey = cross(ez,ex);
        ey = ey/norm(ey);
        
    case 3 % thigh P3,5,7
        ez=(p2-p3)/norm(p2-p3);       % Suggested one.
        ex_tmp = (p1-p2)/norm(p1-p2); % Description and paper agree.
        ey = cross(ez,ex_tmp);
        ey=ey/norm(ey);
        ex=cross(ey,ez);
        ex=ex/norm(ex);
        
    case 4 % pelvis P1,2,3
        ex = (p3-p2)/norm(p3-p2); 
        ez_tmp = (p1-p3)/norm(p1-p3);
        ey = cross(ez_tmp,ex);
        ey = ey/norm(ey);
        ez = cross(ex,ey);
        ez = ez/norm(ez);
                
    otherwise
        
end

%-----------------------------------------------------------
% establish 4x4 matrix combining rotation and translation
% to be applied to a COLUMN vector !
%-----------------------------------------------------------

% start with the 3x3 rotation submatrix
R(1,:) = ex;
R(2,:) = ey;
R(3,:) = ez;

% prepare the translation to the origin of the local CS
t = -ori';
t = R*t;

% compose a 4x4 matrix from R and t
M = R;
M(1:3,4) = t;
M(4,:)   = [ 0 0 0 1 ];
%-----------------------------------------------------------
% return a 3x3 rotation matrix, the origin, as well as 4x4 
% homogeneous transformation matrix
%-----------------------------------------------------------
T.R(1,:) = ex;
T.R(2,:) = ey;
T.R(3,:) = ez;
T.origin = ori';   
T.M = M;
                                                                                                   
return                                                                                                 
end