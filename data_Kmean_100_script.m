load data_modified_dimension.mat

% found this code online: https://www.mathworks.com/matlabcentral/answers/213423-how-to-select-random-columns

ncol = 100;
x = randperm(size(data_modified_dimension,2),ncol);
data_Kmean_100 = data_modified_dimension(:,x);

save data_Kmean_100 data_Kmean_100