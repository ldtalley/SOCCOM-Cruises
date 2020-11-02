function meta = MetaInfoLynne(cruise)

% program to set variables for cruises 
% Usage:   meta(cruise)
%
% Variables set as fielcs in structure::  
% 	Station
%	Floats
%	BathyFile
% 	LatMin, LatMax, LonMin, LonMax  (Lon scale -180 to 180)
% 	MarkerSize   % to scale marker sizes of floats and stations
% 	ylabel_offset,xyabel_offset   % to offset the station label on plot

%=======================================================
%  Edit these for path locations and common fie name
% Paths

% set paths to programs
%addpath '/Volumes/SOCCOM/SOCCOM_pre-cruise/mfiles'; % paths to mfiles, .m

% path to common files which are used for all plots
meta.common_loc = '/SOCCOM_pre-cruise/common_files/'; % common data files used

meta.top_loc = '/SOCCOM_pre-cruise/SOCCOM_pre-cruise/';

% location to world etopo2 file, very large
meta.etopo_loc = '/SOCCOM_pre-cruise/common_files/';  % location of etopo file

meta.altim_loc = '/SOCCOM_pre-cruise/common_files/';

meta.chloro_loc = '/SOCCOM_pre-cruise/common_files/';

meta.SST_loc = '/SOCCOM_pre-cruise/common_files/';

% File names
meta.SeaIceFile1 = 'nt_20060920_f13_v01_s.nc';       %greatest ice extent (change this depending on what sea ice file you want (this is September 20, 2006))
meta.SeaIceFile2 = 'nt_20060220_f13_v01_s.nc';       %lower ice extent (change this depending on what sea ice file you want (this is February 20, 2006))


%=======================================================
if strcmp(cruise,'2020_NBP') %% CHANGE ANYTHING HERE THAT NEEDS TO BE CHANGED FOR YOUR AREA
    meta.Station = '2020_NBP_Station_Locations.txt';   % Station file name or "false"
    meta.Floats = '2020_NBP_Proposed_Floats.txt';      % proposed float file name oropen "false"
    meta.LatMin = -70; meta.LatMax = -30; meta.LonMin = -100; meta.LonMax = - 40; 
    % DON'T CHANGE ANYTHING BELOW THIS LINE
    meta.CO2 = 'spco2_mean_2005-2015_MPI_SOM-FFN_v2016.mat'; % means from year 2005:2015
    meta.MarkerSize = 15;                          % Marker size, scaled in programs 
    meta.xlabel_offset = 0.25;                     % add to x position for label
    meta.ylabel_offset = 0; 
    meta.BathyFile = ['ETOPO2v2g_f4_' cruise '.mat'];      % bathymetry file made in get_bathy_from_etopo2.m
    meta.AltimFile = ['Aviso_' cruise '.mat'];
    meta.CurlFile = ['CurlData_' cruise '.mat']; 
    meta.ChloroFile = ['Chloro_data_',cruise,'.mat'];
    meta.ChloroFile2 = ['Chloro2_data_',cruise,'.mat'];
    meta.SSTFile = ['SSTFlux_',cruise,'.mat'];
    meta.HeatFile = ['HeatFlux_' cruise '.mat']; 
    meta.CurlVectorFile = ['VectorCurlData_' cruise '.mat'];
    meta.FreshWaterFile = ['FreshWater_' cruise '.mat'];
    meta.BuoyancyFluxFile = ['BuoyancyFlux_' cruise '.mat'];

    %latitude/longitude values for this area (-180-180 scale)
%===================================================================
% below all previously done by S.Ogle,  need to have "Metainfo." appended to each variable

%elseif strcmp(area,'SR1B')          %if your area is SR1B edit here
%    Station = 'SR1B.txt';       %input station file name here or write "false" if you don't have a station file
%    Floats = false;             %input proposed float file name here or if there isn't one write "false"
%    BathyFile = 'ETOPO2v2g_f4_SR1B.mat';                         %bathymetry file for this specific area (it takes too long if you use the world bathymetry file)
%    LatMin = -65; LatMax = -50; LonMin = -80; LonMax = -50;      %latitude/longitude values for this area (-180-180 scale)
%    title('SR1B Stations and Bathymetry')                %input map title here
elseif strcmp(area,'OOI')                %if your area is OOI edit here
    Station = 'AAIW_2005_Stations.txt';        %input Station file name or write "false" if you don't have one (using 2005 because 2006 was sketchy with storms...
    Floats = 'OOIProposedFloats.txt';    %input proposed float file name or write "false" if you don't have one
    BathyFile = 'ETOPO2v2g_f4_OOI.mat';  %bathymetry file for this specific area (it takes too long if you use the world bathymetry file)
    LatMin = -65; LatMax = -45; LonMin = -105; LonMax = -60;                     %latitude/longitude values for this area (-180-180 scale)
    title('OOI Proposed Floats, AAIW05 Stations, and Bathymetry')       %input map title here
elseif strcmp(area,'P15S')                  %if your area is P15S edit here
    Station = 'P15S_header.txt';            %input Station file name or write "false" if you don't have one
    Floats = false;                         %input proposed float file name or write "false" if you don't have one
    BathyFile = 'ETOPO2v2g_f4_P15S.mat';    %bathymetry file for this specific area (it takes too long if you use the world bathymetry file)
    LatMin = -70; LatMax = -30; LonMin = -180; LonMax = -150;    %latitude/longitude values for this area   (-180-180 scale)
    title('P15S Stations and Bathymetry')              %input map title here
elseif strcmp(area,'I08S')                   %if your area is I08S enter file names below
    Station = 'i08s_header.txt';             %input Station file name or write "false" if you don't have one
    Floats = 'I08S_Proposed_Floats.txt';                          %input proposed float file name or write "false" if you don't have one
    BathyFile = 'ETOPO2v2g_f4_I08S.mat';     %bathymetry file for this specific area (it takes too long if you use the world bathymetry file)
    LatMin = -70; LatMax = - 30; LonMin = 70; LonMax = 120;     %latitude/longitude values for this area   (-180-180 scale)
    title('I08S Proposed Floats, Stations, and Bathymetry')              %input map title here
elseif strcmp(area,'CSIRO')                  %if your area is CSIRO edit file names below
    Station = 'CSIRO_Float.txt';             %input current argo float location file or Station file name or write "false" if you don't have one
    Floats = 'CSIRO_Proposed_Floats.txt';    %input proposed float file name or write "false" if you don't have one
    BathyFile = 'ETOPO2v2g_f4_CSIRO.mat';    %bathymetry file for this specific area (it takes too long if you use the world bathymetry file)
    LatMin = -60; LatMax = -40; LonMin = 70; LonMax = 150;                         %latitude/longitude values for this area   (-180-180 scale)
    title('CSIRO Proposed Floats, Current Argo Float, and Bathymetry')     %input map title here
elseif strcmp(area,'other')         %location for Lynne's talk, but you can put anything here
    Station = false;                %no station location file
    Floats = false;                 %no float file  
    BathyFile = 'ETOPO2v2g_f4_P15S_bigger.mat';   %bathymetry file for this area
    LatMin = -70; LatMax = -30; LonMin = -180; LonMax = -120;       %set max/min lat/lon
    title('Bathymetry (meters)')        %title
elseif strcmp(area,'S4I')           %if your area is S4I enter file names below
    Station = 'S4I_Station_Locations.txt';   %input current argo float location file or Station file name or write "false" if you don't have one 
    Floats = 'S41_Proposed_Floats.txt';                          %input proposed float file name or write "false" if you don't have one
    BathyFile = 'ETOPO2v2g_f4_S04Ieast.mat';  %bathymetry file for this specific area (it takes too long if you use the world bathymetry file)
    LatMin = -70; LatMax = -50; LonMin = 70; LonMax = 105;   %latitude/longitude values for this area   (-180-180 scale)
    title('I8S-S4I-93E Proposed Floats, Stations, and Bathymetry');      %input map title here
else
    disp('Area not found: check MetaInfo.m')
    return

end    %end of if statement for edittable area