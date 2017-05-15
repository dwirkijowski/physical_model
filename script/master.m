%% Model 1
% One Span Perpendicular Diagrapms
% M1S0
modes = [1,2,4,6:8];
phymodel('m1s0.st7', modes)

%% M1S15
modes = [1,2,4:6];
phymodel('m1s15.st7', modes)

%% M1S20
modes = [1,2,4:7];
phymodel('m1s20.st7', modes)

%% M2S30
modes = [1,2,4:8];
phymodel('m1s30.st7', modes)

%% M1S45
modes = [1,2,4,7,8];
phymodel('m1s45.st7', modes)

%% Model 2
% One Span Parallel Diaphragms
% M2S15
modes = [1,2,4,6:8];
phymodel('m2s15.st7', modes)

%% M2S20
modes = [1,2,4,6:8];
phymodel('m2s20.st7', modes)

%% M2S30
modes = [1,2,5:8];
phymodel('m2s30.st7', modes)

%% M2S45
modes = [1,3,5:8];
phymodel('m2s45.st7', modes)

%% Model 3
% Two Span Perpendicular
% M3S0
modes = [1,2,4,6,7];
phymodel('m3s0.st7', modes)

%% M3S15
modes = [1,4:6];
phymodel('m3s15.st7', modes)

%% M3S20
modes = [1,3,5,6];
phymodel('m3s20.st7', modes)

%% M3S30
modes = [1,3,5,6];
phymodel('m3s30.st7', modes)

%%
modes = [1,2,5,6];
phymodel('m3s45.st7', modes)

%% Model 4
% Two Span Parallel
% M4S0
modes = [1,4,6];
phymodel('m4s0.st7', modes)

%% M4S15
modes = [1,4,6];
phymodel('m4s15.st7', modes)

%% M4S20
modes = [1,4,6];
phymodel('m4s20.st7', modes)

%% M4S30
modes = [1,4,6];
phymodel('m4s30.st7', modes)

%% M4S45
modes = [2,4,6];
phymodel('m4s45.st7', modes)