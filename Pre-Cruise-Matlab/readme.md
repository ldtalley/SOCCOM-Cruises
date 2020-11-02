### Welcome to the older code for the SOCCOM pre-cruise reports! 
 
STEP 1: Edit the info in the MetaInfoLynne.m to be appropriate for your area. 

There will be pathways to the folder you are keeping all this in that needs to be changed at the top. 

% path to common files which are used for all plots
meta.common_loc = '/SOCCOM_pre-cruise/common_files/'; % common data files used

meta.chloro_loc = '/SOCCOM_pre-cruise/common_files/';

You will also need to edit:

if strcmp(cruise,'2020_NBP') %% CHANGE ANYTHING HERE THAT NEEDS TO BE CHANGED FOR YOUR AREA
    meta.Station = '2020_NBP_Station_Locations.txt';   % Station file name or "false"
    meta.Floats = '2020_NBP_Proposed_Floats.txt';      % proposed float file name oropen "false"
    meta.LatMin = -70; meta.LatMax = -30; meta.LonMin = -100; meta.LonMax = - 40; 
    
You need to edit the station file to 'false' and make meta.Floats = the file name of all the random positions you generated. Also edit the lat/lon bounds and the cruise name from '2020_NBP'. The cruise name can be whatever title you want (or you can edit the actual plotting code to no longer have a title).

STEP 2: Run the get_info_Lynne.m file with the appropriate cruise name. 

The first time you run it, uncomment the keyboard command and take note of the size of your Lat and Lon variable sizes. Then recomment keyboard and rerun the mfile with the Lat/Lon size in the function command itself. 

This should get you a smaller mat file of what you wanted. 

STEP 3: Run CO2_LANDSCHUTER.m file with the cruise and titl variables set to the cruise name you created.   
