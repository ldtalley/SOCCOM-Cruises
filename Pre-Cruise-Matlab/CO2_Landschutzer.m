function CO2_Landschuter(cruise,titl)  %creates function for reference

% this function read a averaged (meaned) CO2 flux density file, typically output from 
% CO2_annual_mean_Landschutzer.m
%  loads as 
%	c = 
%	
%	                           seamask: [360x180 int32]
%	                               lat: [180x1 single]
%	                               lon: [360x1 single]
%	         fgco2_raw_Mean_2005to2015: [360x180 single]
%	    fgco2_smoothed_Mean_2005to2015: [360x180 single]
%
% NOTE:  the smoothed and raw files are very similar when meaned between 2005 and 2015
% 	Therefore,  the raw plots ( world and area, in blue-red) will be saved.  Other
%	plots made are commentd out, but remain in the code for reference if needed.
%	To comment in the plots,  remove "%p" from the beginning of lines.  Lines
%	not starting with "%p" are actual comments in the code.
%
% DONE
% 2018-08-16; in matlab ran 
%       >>  CO2_annual_mean_Landschutzer('spco2_1982-2015_MPI_SOM-FFN_v2016.nc');
%       to get the file spco2_mean_2005-2015_MPI_SOM-FFN_v2016.mat to use in CO2_Landschutzer.m


%
% cruise='2019_AMT28'  % testing
%addpath ../../mfiles  % testing


meta = MetaInfo(cruise);  %links to metainfo so we can call variables, etc from other mfiles

%*****
% also check out
%https://blogs.mathworks.com/steve/2016/04/25/clim-caxis-imshow-and-imagesc/
%
% use a GMT .cpt file for the color map and ticks
%  from https://www.mathworks.com/matlabcentral/fileexchange/28943-color-palette-tables-cpt-for-matlab
% for GMT cpt colormapping
addpath([meta.top_loc,'/mfiles/cpt_matlab/kakearney-cptcmap-pkg-845bf83/cptcmap']);
addpath([meta.top_loc,'/mfiles/cpt_matlab/kakearney-cptcmap-pkg-845bf83/parsepv']);
addpath([meta.top_loc,'/mfiles/cpt_matlab/kakearney-cptcmap-pkg-845bf83/cptcmap/cptfiles']);
addpath([meta.common_loc]);  %for the file GMT_CO2.cpt
%*****

% load Meaned CO2 file
c = load(fullfile(meta.CO2));

% find min, max of the M(eaned) file
% raw
mRawMin = min(min(c.fgco2_raw_Mean_2005to2015));
mRawMax = max(max(c.fgco2_raw_Mean_2005to2015));
disp([ 'World RAW Mean  min: ' num2str(mRawMin) ';  max: ' num2str(mRawMax)])
% smoothed
mSmoMin = min(min(c.fgco2_smoothed_Mean_2005to2015));
mSmoMax = max(max(c.fgco2_smoothed_Mean_2005to2015));
disp([ 'World SMOOTHED Mean  min: ' num2str(mSmoMin) ';  max: ' num2str(mSmoMax)])

%============================
% pull out data for date and area

if any(c.lon>180)
    disp('Error:  longitudes in meta file do not match lons in CO2 file (-180 to 180)' );
    keyboard;
end

% find index to area
ialat = find(c.lat>meta.LatMin & c.lat<meta.LatMax);
ialon = find(c.lon>meta.LonMin & c.lon<meta.LonMax);

% area position
alat = c.lat(ialat);
alon = c.lon(ialon);

% select area data
aflraw = c.fgco2_raw_Mean_2005to2015(ialon,ialat);
aflsmo = c.fgco2_smoothed_Mean_2005to2015(ialon,ialat);

%============================

%% keep null/missing values at nan for now,  for clean plotting comparisons
%mflraw(find(isnan(wflraw))) = 20;  
%mflsmo(find(isnan(wflsmo))) = 20;  
%
disp('Warning:  changing null values to NaNs,  which will be interpolated near coasts and other areas');
%%aflraw(find(isnan(aflraw))) = 20;  
%%aflsmo(find(isnan(aflsmo))) = 20;  
%
%============================

% make a colormap from -x to x.  Need this to make 0 at the middle
% GMT_CO2_blue goes from -18 to  0, but we are using GMT just for color
% GMT_CO2_red  goes from   1 to 18, but we are using GMT just for color
% GMT_CO2 is red and blue,  choose number of colors

% make ncol color GMT colormap, 2 red for each integer>0, 2 blue for each integer<0 
ncolors = 2;  % number of colors between integers

vmax = max(abs(floor(mSmoMin)),abs(ceil(mSmoMax)));
[brcmap, rlims, rticks, rbfncol, rctable] = cptcmap('GMT_CO2', 'mapping', 'direct', 'ncol' ,vmax*2*ncolors);


% Area plot with blue-red colormap
clf;

hold on

imagesc(alon,alat,aflraw');   % must transpose
set(gca,'YDir','normal');  % set to a normal y-direction
set(gca,'YLim',[meta.LatMin meta.LatMax]); % sets map y-limits to the Latitudes specified for your area
set(gca,'XLim',[meta.LonMin meta.LonMax]);
set(gca,'FontSize',16)

[L,m] = contour(alon,alat,aflraw',[-3:1:3],'Color','k');
clabel(L,m,'LabelSpacing',200);

%daspect([1,1,1]);
title( ['Landschutzer CO2 flux density, meaned, raw, 2005-2015 for ',titl],'FontSize',16)
colormap(brcmap);
set(gca,'CLim',[vmax*-1 vmax]);
%set(gca,'FontSize',18);
ax = gca;
ax.FontSize = 16;
hc = colorbar('YTICK',[(vmax*-1):1:(vmax)]);
geoshow('landareas.shp','FaceColor','black');  % takes a while,  but easy proga
%print('-dpng',fullfile(meta.top_loc,cruise,['Landschutzer_BlueRed_Mean_raw_' cruise '.png']));


ylabel('Degree Longitude','FontSize',16)
xlabel('Degree Latitude','FontSize',16)
h = colorbar; 
%set(get(h,'label'),'string','umol/m2/y','FontSize',16)


%===================================================================================
%This is for a single cruise
if meta.Station == false             %if your location does NOT have a station file
    StationF = false;           %assign StationF as "false"
else                              %if your location has a station file (or a current Argo float position as with CSIRO)
    StationFile = load(meta.Station);  %load station file
    StationF = true;              %assign StationF as "true"
end

if meta.Floats == false              %if your location does NOT have a proposed float file
    Floaty = false;             %make Floaty "false"
else                            %if your location has a proposed float file
    Floaty = true;              %make Floaty "true"
    FloatFile = load(meta.Floats);   %load Float file
end

if StationF ~= false       %assign StationF as "false"
    x = StationFile(:,3); %creates y vector for cruise line if you want to use stations
    y = StationFile(:,2); %creates x vector for cruise line if you want to use stations
    Cruise = line(x,y,'LineWidth',2,'Color',[0.2 0.2 0.2]);  %creates cruise line
elseif Floaty ~= false
    x = FloatFile(:,3);
    y = FloatFile(:,2);  %creates y vector for cruise line if you want to use floats
    Cruise = line(x,y,'LineWidth',2,'Color',[0.3 0.3 0.3]);  %creates cruise line'
end

if StationF == true             %if your area has a station file, the stations will plot
    numbrows = size(StationFile);   %find how many rows are in the station file
    for row = 1:numbrows            %loops through every station
        Stat = plot(StationFile(row,3),StationFile(row,2),'.','MarkerSize',meta.MarkerSize,'LineWidth',2,'MarkerEdgeColor',[0 0 0]);  %plots station locations with bright green X and assigns to Stat for 'legendary' usage
        plot(StationFile(row,3),StationFile(row,2),'o','MarkerSize',meta.MarkerSize*0.05,'MarkerEdgeColor',[0 0 0]); 
    end
end

if Floaty == true                    %if your area has a float file plot the proposed float locations
    [numrows numcols] = size(FloatFile);  %find how many rows and columns are in FloatFile to find how many rows to loop through
    for row = 1:numrows    %loop through the positions in the file
        Latitude = FloatFile(:,2);   %get Latitude variable
        Longitude = FloatFile(:,3);  %get Longitude variable
        Flo = plot(Longitude(row),Latitude(row),'.','MarkerSize',2.5*meta.MarkerSize,'LineWidth',4,'MarkerEdgeColor',[1 0 1]); %plot the proposed floats with magenta Xs and assign to Flo for legendary use

    end
end 

legend([Cruise Flo],[titl,' Cruise Track'],[titl,' Float Locations'],'Location','Southeast')
%======================================================================================

saveas(gcf,[cruise,'_CO2.jpg'])

hold off

% print the raw world in red blue as it's own plot.
% figure(2)
% imagesc(c.lon,c.lat,c.fgco2_raw_Mean_2005to2015'); % must transpose
% set(gca,'YDir','normal');  % set to a normal y-direction
% daspect([1,1,1]);
% title(gca,'Landschutzer, CO2 flux density, raw, 2005-2015 Mean, umol/m2/y');
% %ylim([meta.LatMin meta.LatMax]);
% %xlim([meta.LonMin meta.LonMax]);
% colormap(brcmap);
% set(gca,'CLim',[vmax*-1 vmax]);
% colorbar;
% %print('-dpng', fullfile(meta.top_loc,cruise,['Landschutzer_BlueRed_Mean_raw.png']));
% 
% return
% 
% % everything below is for reference ploting
% 
% %============================
% %p% plots world ,  raw and smooth, for reference. in colormap(jet) 
% %pfigure(1)
% %pclf;
% %ph1 = subplot(2,1,1);
% %pimagesc(c.lon,c.lat,c.fgco2_raw_Mean_2005to2015'); % must transpose
% %pset(h1,'YDir','normal');  % set to a normal y-direction
% %pdaspect([1,1,1]);
% %ptitle(h1, 'Landschutzer, CO2 flux density, raw, 2005-2015 Mean, umol/m2/y');
% %p%ylim([meta.LatMin meta.LatMax]);
% %p%xlim([meta.LonMin meta.LonMax]);
% %pcolormap(jet);
% %pcolorbar;
% %pset(h1,'CLim',[-5 5]);
% %p
% %ph2 = subplot(2,1,2);
% %pimagesc(c.lon,c.lat,c.fgco2_smoothed_Mean_2005to2015'); % must transpose
% %pset(h2,'YDir','normal');  % set to a normal y-direction
% %pdaspect([1,1,1]);
% %ptitle(h2,'Landschutzer, CO2 flux density, smoothed, 2005-2015 Mean, umol/m2/y');
% %p%ylim([meta.LatMin meta.LatMax]);
% %p%xlim([meta.LonMin meta.LonMax]);
% %pcolormap(jet);
% %pcolorbar;
% %pset(h2,'CLim',[-5 5]);
% %p
% %pprint('-depsc',fullfile(meta.top_loc,cruise,'Landschutzer_jet_meaned_raw_smoothed.eps')
% %pprint('-dpng',fullfile(meta.top_loc,cruise,'Landschutzer_jet_meaned_raw_smoothed.png')
% 
% %p%clf;  % clear all figures
% %pclear h1 h2
% %============================
% %p% plots world in red blue,  raw and smooth, for testing
% %pfigure(4)
% %pclf;
% %ph1 = subplot(2,1,1);
% %pimagesc(c.lon,c.lat,c.fgco2_raw_Mean_2005to2015'); % must transpose
% %pset(h1,'YDir','normal');  % set to a normal y-direction
% %pdaspect([1,1,1]);
% %ptitle(h1, 'Landschutzer, CO2 flux density, raw, 2005-2015 Mean, umol/m2/y');
% %p%ylim([meta.LatMin meta.LatMax]);
% %p%xlim([meta.LonMin meta.LonMax]);
% %pcolormap(brcmap);
% %pset(gca,'CLim',[vmax*-1 vmax]);
% %p
% %ph2 = subplot(2,1,2);
% %pimagesc(c.lon,c.lat,c.fgco2_smoothed_Mean_2005to2015'); % must transpose
% %pset(h2,'YDir','normal');  % set to a normal y-direction
% %pdaspect([1,1,1]);
% %ptitle(h2,'Landschutzer, CO2 flux density, smoothed, 2005-2015 Mean, umol/m2/y');
% %p%ylim([meta.LatMin meta.LatMax]);
% %p%xlim([meta.LonMin meta.LonMax]);
% %pcolormap(brcmap);
% %pset(gca,'CLim',[vmax*-1 vmax]);
% %pcolorbar;
% %p
% %pprint('-depsc',fullfile(meta.top_loc,cruise,'Landschutzer_BlueRed_meaned_raw_smoothed.eps');
% %pprint('-dpng',fullfile(meta.top_loc,cruise,'Landschutzer_BlueRed_meaned_raw_smoothed.png');
% 
% %p% print the raw world in red blue as it's own plot. 
% %pfigure(8)
% %pimagesc(c.lon,c.lat,c.fgco2_raw_Mean_2005to2015'); % must transpose
% %pset(gca,'YDir','normal');  % set to a normal y-direction
% %pdaspect([1,1,1]);
% %ptitle(gca,'Landschutzer, CO2 flux density, raw, 2005-2015 Mean, umol/m2/y');
% %p%ylim([meta.LatMin meta.LatMax]);
% %p%xlim([meta.LonMin meta.LonMax]);
% %pcolormap(brcmap);
% %pset(gca,'CLim',[vmax*-1 vmax]);
% %pcolorbar;
% %pprint('-dpng',fullfile(meta.top_loc,cruise,'Landschutzer_BlueRed_meaned_raw.png');
% %p% print the area
% %pylim([meta.LatMin meta.LatMax]);
% %pxlim([meta.LonMin meta.LonMax]);
% %pprint('-dpng',fullfile(meta.top_loc,cruise,'Landschutzer_BlueRed_meaned_raw' cruise '.png']));
% 
% %pfigure(9)
% %pimagesc(c.lon,c.lat,c.fgco2_smoothed_Mean_2005to2015'); % must transpose
% %pset(gca,'YDir','normal');  % set to a normal y-direction
% %pdaspect([1,1,1]);
% %ptitle(gca,'Landschutzer, CO2 flux density, smoothed, 2005-2015 Mean, umol/m2/y');
% %p%ylim([meta.LatMin meta.LatMax]);
% %p%xlim([meta.LonMin meta.LonMax]);
% %pcolormap(brcmap);
% %pset(gca,'CLim',[vmax*-1 vmax]);
% %pcolorbar;
% %pprint('-dpng',fullfile(meta.top_loc,cruise,'Landschutzer_BlueRed_meaned_smoothed.png');
% %p% print the area
% %pylim([meta.LatMin meta.LatMax]);
% %pxlim([meta.LonMin meta.LonMax]);
% %pprint('-dpng',fullfile(meta.top_loc,cruise,['Landschutzer_BlueRed_meaned_smoothed' cruise '.png']));
% 
% %=========================================================
% 
% 
% %============================
% %p% now print and save the area
% %p% plots area in red blue,  raw and smooth, for testing
% %pfigure(5)
% %pclf;
% %ph1 = subplot(2,1,1);
% %pimagesc(alon,alat,aflraw'); % must transpose
% %pset(h1,'YDir','normal');  % set to a normal y-direction
% %pdaspect([1,1,1]);
% %ptitle(h1, 'Landschutzer, CO2 flux density, raw, 2005-2015 Mean, umol/m2/y');
% %p%ylim([meta.LatMin meta.LatMax]);
% %p%xlim([meta.LonMin meta.LonMax]);
% %pcolormap(brcmap);
% %pset(gca,'CLim',[vmax*-1 vmax]);
% %pcolorbar
% %p
% %ph2 = subplot(2,1,2);
% %pimagesc(alon,alat,aflsmo'); % must transpose
% %pset(h2,'YDir','normal');  % set to a normal y-direction
% %pdaspect([1,1,1]);
% %ptitle(h2,'Landschutzer, CO2 flux density, smoothed, 2005-2015 Mean, umol/m2/y');
% %p%ylim([meta.LatMin meta.LatMax]);
% %p%xlim([meta.LonMin meta.LonMax]);
% %pcolormap(brcmap);
% %pset(gca,'CLim',[vmax*-1 vmax]);
% %pcolorbar;
% %p
% %pprint('-depsc',fullfile(meta.top_loc,cruise,'Landschutzer_BlueRed_2019_AMT28.eps'));
% %pprint('-dpng',fullfile(meta.top_loc,cruise,'Landschutzer_BlueRed_2019_AMT28.png'));
% 
% %p%clf;  % clear all figures
% %pclear h1 h2
% 
% %============================
% 
% 
% 
% %p% plots with blue-red colormap
% %pfigure(2)
% %pclf;
% %psubplot(2,1,1);
% %pimagesc(alon,alat,aflraw' );   % must transpose
% %pset(gca,'YDir','normal');  % set to a normal y-direction
% %pdaspect([1,1,1]);
% %ptitle(gca, 'Landschutzer,CO2 flux density, raw, 2005-2015, umol/m2/y');
% %pcolormap(brcmap);
% %pset(gca,'CLim',[vmax*-1 vmax]);
% %phc = colorbar('YTICK',[(vmax*-1)+1:1:(vmax-1)]);
% %pgeoshow('landareas.shp','FaceColor','black');  % takes a while,  but easy progamming
% %p
% %psubplot(2,1,2);
% %pimagesc(alon,alat,aflsmo' );   % must transpose
% %pset(gca,'YDir','normal');  % set to a normal y-direction
% %pdaspect([1,1,1]);
% %ptitle(gca, 'Landschutzer,CO2 flux density, smoothed, 2006/2/15, umol/m2/y');
% %pcolormap(brcmap);
% %pset(gca,'CLim',[vmax*-1 vmax]);
% %phc = colorbar('YTICK',[(vmax*-1)+1:1:(vmax-1)]);
% %pgeoshow('landareas.shp','FaceColor','black');  % takes a while,  but easy progamming
% %pprint('-depsc',fullfile(meta.top_loc,cruise,'Landschutzer_smoothed_scaled_2019_AMT28.eps'));
% %pprint('-dpng',fullfile(meta.top_loc,cruise,'Landschutzer_smoothed_scaled_2019_AMT28.png'));
% 
% 
% %============================
