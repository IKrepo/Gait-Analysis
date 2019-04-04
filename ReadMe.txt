This text file provides an explanation about the code and the functions developed.
It also explains how to run the code.

However the results cannot be reproduced since the anthropometric data
are not available due to copyrights.
An example of "fake" anthropometric data is included for testing the code.

For the code to run smoothly, please change all the input and output directories.

There are five directories:

	A) Two directories for the output results:
		1) The first one is used to store all the plots.
		2) The second one is used to store all the excel files.

	B) Three directories for the input results:
		1) The first one is used to access Input file.
		2) The second one is used to acces THR files.
		3) The third one is used to access Healthy files.

The code is structured using a number of small functions controlled by the
master MATLAB code called "gait_data_processing.m".

I tried to make the code as general as possible in order
to be able to handle changes from the input files.

The functions used are the following:

1 -> gait_data_processing (main code used for reading input files, storing the
                           output files and calling all the other functions).

2 -> edit_anthropometrics (processing the 'anthropometrics.xlsx' file).

3 -> edit_data            (processing the data read from THR_patients files).

4 -> inverse_dynamics     (uses the data from edit_data function to perform
                           inverse dynamics analysis).

5 -> convert_LCS          (convert points, forces and moments from GCS to LCS).

This function calls other functions for achieving its goal:
	5.1 -> extract_pt_data_from_data_matrix (uses THR_patients files (T2 table)
	                                         to extract point/landmark locations).

	5.2 -> determine_local_CS_with_origin   (calculates the transformation T to
	                                         a local coordinate system).

	5.3 -> calcEulerAngs                    (used to extract euler angles
	                                         from cosine matrices).

6 -> plot_2d_results     (used to plot 2d graphs of the results).

7 -> plot_3d_results     (used to plot 3d graphs of the results).

8 -> vectors_2d_3d       (used to plot the vectors of forces and moments at each
                          joint in both 2d and 3d).

9 -> plot_animation      (used to perform simple vector style animation showing
                          the direction of the force and moment at each joint
                          during a gait cycle for patient 1 walking trial 1).

10 -> save_results        (used to save the plots and excel file in the corresponding
			  directories).

IF FUNCTIONS 6, 7, 8 and 9 are commented, uncomment to see the results.

Computation time for some plots is long because of the extensive use of scatter plots.

The code might take saveral minutes to produce the results based on the pc used.

			            !!! SOS !!!
///////////////////////////////////////////////////////////////////////////////////////
///  For the plot_animation function to work as expected, change the values of the  ///
///  off marker of the patients from -1 to 0 to indicate when the left foot is off  ///
///  is off from the plate.                                                         ///
///////////////////////////////////////////////////////////////////////////////////////
