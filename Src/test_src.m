pu_location=[trans_X(1,1), trans_Y(1,1)];

%load X, Y in location matrix
locations=cell(grids_num,grids_num);
height=Z;
energy=zeros(size(Z));
distance_to_pu=zeros(grids_num,grids_num);
for i=1:grids_num
    for j=1:grids_num
        locations{i,j}=[X(1,i),Y(j,1)];
    end
end

%calculate distance of each grid to PU
for i=1:grids_num
    for j=1:grids_num
        distance_to_pu(i,j)=Calculate_distance_by_latlon(locations{i,j},pu_location,'Haversine');
    end
end

%calculate spectrum energy of each grid
% distance=20; %km  trans to receiver distance
frequency=1800; %MHz carrier signal frequence
trans_height=100; %m  transmitter effective antenna height 
terrin=50; %100-50 m Height of base antenna above terrain
t_ratio=50; %50% Percentage time defined
tca=10; %degree terrain clearance angle
rec_height=5; %m  reciever antenna height
path_type='Land';
environment_type='dense';
for i=1:grids_num
    for j=1:grids_num
        energy(i,j)=Calculate_propagation_loss(distance_to_pu(i,j),frequency,trans_height,height(i,j),t_ratio,tca,rec_height,'Land','dense');
    end
end
surf(X,Y,energy); view(2); colorbar;
