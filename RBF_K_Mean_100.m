clear
close all
load Data_Training.mat
load data_Kmean_100.mat
% load Test_Data.mat
load Data_Testing.mat
load Test_Data_NNan.mat

tic
radar_variables = Training.X_tr;
response_train = Training.Y_tr;
response_train_Y = response_train';

data = [radar_variables response_train_Y];
data_modified_dimension = data';

% save data_modified_dimension data_modified_dimension;

%% ======= Initialize NN ======== %

% num_tr = 8780;
% num_te = 40000;
num_tr = 48780;
num_te = 0;
% num_te = 48000;
num_hd = 100;
num_in = 4;         % dimension of input data
num_ou = 1;         % dimension of output data

%% ======== Data Shuffling ======= %
num_samp = num_tr + num_te;
[n_row, n_col] = size(data_modified_dimension);
shuffle_seq = randperm(n_col);
for ii = 1:n_col
    data_shuffled(:,ii) = data_modified_dimension(:, shuffle_seq(ii));
end

%% ========== useful parameters used in RBF ========= 
w_100 = zeros(num_ou, num_hd);
lambda = 0.01;
P = lambda^(-1)*eye(num_hd);        % R^(-1)(0)
epochs = 20;


%% apply kmean method to cluster the training data
[center, pos_vector, n] = my_kmean(data_shuffled(1:4, :), num_tr, num_hd, data_Kmean_100(1:4,:));


%% =========== Calculating the parameters in RBF =======
center = data_shuffled(1:4,1:num_hd);
sigma = zeros(1, num_hd);

%% ========== calculating sigma

for ii = 1:num_hd
    dist_temp = 0;
    for jj = 1:num_tr
        dist_temp = distance(data_shuffled(1:4,jj), center(1:4, ii)) + dist_temp;
    end
    sigma(ii) = dist_temp/num_tr;
end


%% ========= Update weight

for epoch = 1:epochs
    epoch
    for m = 1:num_tr
        x = data_shuffled(1:4, m);
        d = data_shuffled(5, m);

        for i = 1:num_hd
            g(i, :) = exp(-(x - center(:, i))'*(x - center(:, i))/(2*sigma(i)^2));
        end

        P_tem = (P*g*g'*P)./(1+g'*P*g);
        P = P - P_tem;
        gg = P*g;
        e = d - w_100*g;
        w_100 = w_100 + (gg.*e)';
        result = w_100*g;
        e(m) = d - result;
    end
    MSE(epoch) = mean(e.^2);
end

%% PLot MSE K = 100
figure
for i = 1:20
    x = i;
    y = MSE(i);
        plot(x, y, 'r*', 'Linewidth', 3, 'MarkerSize', 2);
    hold on;
end

%% ========== testing RBF

spread = sigma;
fprintf('Testing the trained RBF with training data ----\n');
for i=1:num_tr
    x=data_shuffled(1:4, i);
    for j=1:num_hd
        g(j,:) = exp(-(x-center(:,j))'*(x-center(:,j))/(2*spread(j)^2));
    end
    o_Kmean_100(i) = w_100*g;
end


o_Kmean_100_True(o_Kmean_100<0) = -1;
o_Kmean_100_True(o_Kmean_100_True~=-1) = 1;

% Error =  (response_train - o_Kmean_100_True);

%% ========== testing RBF with Testing Data

spread = sigma;
fprintf('Testing the trained RBF with testing data ----\n');
for i=1:length(Test_Data)
    x=Test_Data(1:4, i);
    for j=1:num_hd
        g(j,:) = exp(-(x-center(:,j))'*(x-center(:,j))/(2*spread(j)^2));
    end
    o_Kmean_100_Test(i) = w_100*g;
end

% o_Kmean_100_True_Test(o_Kmean_100<0) = -1;
% o_Kmean_100_True_Test(o_Kmean_100_True_Test~=-1) = 1;

%%
%
nanmap=isnan(o_Kmean_100_Test);
o_Kmean_100_True_Test(o_Kmean_100_Test<0) = -1;
o_Kmean_100_True_Test(o_Kmean_100_Test>=0) = 1;
o_Kmean_100_True_Test(nanmap)=nan;
%%
% B = reshape(o_Kmean_100_True_Test, 361, 320);

B = reshape(o_Kmean_100_True_Test, [], 361);
B = B';

%%
xplot = Test.XPLOT';
yplot = Test.YPLOT';


% chat gpt
color1 = [1 0 0];   % red
color2 = [0 1 0];   % green

figure

pcolor(xplot, yplot, B);
custoMap = [color2; color1];

caxis([-1, 1]);
% breakpoint = 0;
shading flat;
% shading faceted;
colormap(custoMap);
hh = colorbar;
set(get(hh,'title'), 'string', 'classification result');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');
hold on;
axis image;
axis([-150 150 -150 150])
grid on
toc
