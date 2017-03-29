% Propose: Calculate distance with input locations: lon and lat 
% Author: Kevin
% Date: March 29th, 2017

%example: [distance]=Calculate_distance_by_latlon([117,31], [118,32], 'Haversine' )
%type: 'Haversine' 'Pythagoras'
function [distance]=Calculate_distance_by_latlon(location1, location2, type_str)
  if(nargin<3)
      type_str='Haversine'; %defaultly use the first formula
  end
  if(nargin<2)
      error('Not enough input!!!'); exit;
  end
  [row_1,col_1]=size(location1);
  [row_2,col_2]=size(location2);
  if((row_1==row_2)&&(col_1==col_2) && (row_1~=1)&&(col_1~=2))
      error('Input data frame not match!!!'); exit;
  end

  [d1,d2]=lldistkm(location1, location2);
  if strcmp(type_str,'Haversine')
      distance=d1;
  elseif strcmp(type_str,'Pythagoras')
      distance=d2;
  else
      error('Formula type undefined!!');
  end
  
end


function [d1km d2km]=lldistkm(latlon1,latlon2)
% format: [d1km d2km]=lldistkm(latlon1,latlon2)
% Distance:
% d1km: distance in km based on Haversine formula
% (Haversine: http://en.wikipedia.org/wiki/Haversine_formula)
% d2km: distance in km based on Pythagoras?theorem
% (see: http://en.wikipedia.org/wiki/Pythagorean_theorem)
% After:
% http://www.movable-type.co.uk/scripts/latlong.html
%
% --Inputs:
%   latlon1: latlon of origin point [lat lon]
%   latlon2: latlon of destination point [lat lon]
%
% --Outputs:
%   d1km: distance calculated by Haversine formula
%   d2km: distance calculated based on Pythagoran theorem
%
% --Example 1, short distance:
%   latlon1=[-43 172];
%   latlon2=[-44  171];
%   [d1km d2km]=distance(latlon1,latlon2)
%   d1km =
%           137.365669065197 (km)
%   d2km =
%           137.368179013869 (km)
%   %d1km approximately equal to d2km
%
% --Example 2, longer distance:
%   latlon1=[-43 172];
%   latlon2=[20  -108];
%   [d1km d2km]=distance(latlon1,latlon2)
%   d1km =
%           10734.8931427602 (km)
%   d2km =
%           31303.4535270825 (km)
%   d1km is significantly different from d2km (d2km is not able to work
%   for longer distances).
%
% First version: 15 Jan 2012
% Updated: 17 June 2012
%--------------------------------------------------------------------------

radius=6371;
lat1=latlon1(1)*pi/180;
lat2=latlon2(1)*pi/180;
lon1=latlon1(2)*pi/180;
lon2=latlon2(2)*pi/180;
deltaLat=lat2-lat1;
deltaLon=lon2-lon1;
a=sin((deltaLat)/2)^2 + cos(lat1)*cos(lat2) * sin(deltaLon/2)^2;
c=2*atan2(sqrt(a),sqrt(1-a));
d1km=radius*c;    %Haversine distance

x=deltaLon*cos((lat1+lat2)/2);
y=deltaLat;
d2km=radius*sqrt(x*x + y*y); %Pythagoran distance

end