function get_info_Lynne(cruise1,sizeLon,sizeLat) 

cruise = cruise1

get_chloro1(cruise) 


%% 
    function get_chloro1(cruise)

    meta = MetaInfoLynne(cruise);

    outfile = ['Chloro_data_' , cruise ,'.mat'];

    Chl = load('Chloro_data_.mat');

    ix = find(Chl.Chlor.lon >= meta.LonMin & Chl.Chlor.lon <= meta.LonMax);
    Lon = Chl.Chlor.lon(ix); 

    iy = find(Chl.Chlor.lat >= meta.LatMin & Chl.Chlor.lat <= meta.LatMax);
    Lat = Chl.Chlor.lat(iy);  
    
    %keyboard %THE FIRST TIME THROUGH UNCOMMENT THIS AND THEN YOU CAN PUT
    %THE SIZE OF THE LON AND LAT VARIABLES INTO THE FUNCTION INPUT LINE
    
    chlor = Chl.Chlor.Chlor(ix,iy);
    chlor = reshape(chlor,sizeLon,sizeLat);
        
    %chlor = chlor(chlor <= 1);
    
    save(outfile,'Lon','Lat','chlor')
    
    end


end