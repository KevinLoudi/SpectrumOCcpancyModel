% Propose: Simulation of one primary user's energy propagation in [0,1]x[0,1]
% Author: Kevin
% Date: March 29th, 2017

%energy_mat: energy distribution within the map
%map_height: height of each grid
%pu_info_obj: struct contain pu information
%grids_num: grid number assigned
%average_terrin: average heigh the map should have

function [energy_mat,map_locations,map_height]=Simulation_primary_user_propagation(pu_info_obj,grids_num...
    ,average_terrin)
   %load dependencies
   addpath('D:\\Code\\WorkSpace\\SpectrumModel\\Tools\\itu_pr1546'); %ITU.P.R 1546 Model
   %addpath('D:\\Code\\WorkSpace\\SpectrumModel\\Include'); %Gobal methods
    
   %generate random terrin
   [X,Y,Z]=Generate_random_field(grids_num);
   Z=Normalize(Z);
   Z=Z.*average_terrin; %max height--50m
   fprintf('Created random map terrin!\n');
   
   %randomly generate pu locations
   [trans_X, trans_Y]=Distribute_random_points(2);
   pu_location=[trans_X(1,1), trans_Y(1,1)];
   fprintf('Select random Primary user locations!\n');
   
   %prepare for outputs
   map_locations=cell(grids_num,grids_num);
   map_height=Z;
   energy_mat=zeros(size(Z));
   distance_to_pu=zeros(grids_num,grids_num);
   
   %calculate map locations
   for i=1:grids_num
    for j=1:grids_num
        map_locations{i,j}=[X(1,i),Y(j,1)];
    end
   end
  
  %calculate distance of each grid to PU
  for i=1:grids_num
    for j=1:grids_num
        distance_to_pu(i,j)=Calculate_distance_by_latlon(map_locations{i,j},pu_location,'Haversine');
    end
  end
  fprintf('Map grids'' distance to Primary user calculated!\n');
  
  %calculate pu's propagation
 for i=1:grids_num
    for j=1:grids_num
        energy_mat(i,j)=Calculate_propagation_loss(distance_to_pu(i,j),pu_info_obj.frequency...
            ,pu_info_obj.trans_height,map_height(i,j),pu_info_obj.t_ratio...
            ,pu_info_obj.tca,pu_info_obj.rec_height,pu_info_obj.path_type...
            ,pu_info_obj.environment);
    end
end
   fprintf('Spectrum propagation estimated!!\n');
   fprintf('Simulation finished!\n');
end