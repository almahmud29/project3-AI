clear
close all
load Data_Testing.mat

xplot = Test.XPLOT';
yplot = Test.YPLOT';
I = Test.C_index;
Z = Test.dBZ_SM;
Zdr = Test.ZDR_SM;
alpha = Test.dBZ_STD;

%%

index = I';
index = index(:)';

%%
Znew = Z';
Znew = Znew(:)';
Zdr_New = Zdr';
Zdr_New = Zdr_New(:)';
alpha_New = alpha';
alpha_New = alpha_New(:)';

%%

Test_Data = [index; Znew; Zdr_New; alpha_New];
% % 
%Test_Data(isnan(Test_Data)) = 0;

save Test_data_NNan.mat Test_Data
%%
figure
pcolor(Test.XPLOT, Test.YPLOT, Test.ZDR_SM');
caxis([-0.5 2]);
shading flat;
hh = colorbar;
set(get(hh,'title'), 'string', 'Z Dr (db)');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');
hold on;
axis image;
axis([-150 150 -150 150])
grid on

%%
figure
pcolor(Test.XPLOT, Test.YPLOT, Test.dBZ_SM');
caxis([-0.5 2]);
shading flat;
hh = colorbar;
set(get(hh,'title'), 'string', 'dBZ SM');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');
hold on;
axis image;
axis([-150 150 -150 150])
grid on

%%
figure
pcolor(Test.XPLOT, Test.YPLOT, Test.dBZ_STD');
caxis([-0.5 2]);
shading flat;
hh = colorbar;
set(get(hh,'title'), 'string', 'dBZ STD');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');
hold on;
axis image;
axis([-150 150 -150 150])
grid on

%%
figure
pcolor(Test.XPLOT, Test.YPLOT, Test.C_index');
caxis([-0.5 2]);
shading flat;
hh = colorbar;
set(get(hh,'title'), 'string', 'C index');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');
hold on;
axis image;
axis([-150 150 -150 150])
grid on