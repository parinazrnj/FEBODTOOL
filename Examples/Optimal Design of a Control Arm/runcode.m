function [x,fval,exitflag,output,population,score] = runcode(nvars,lb,ub,InitialPopulationRange_Data,PopulationSize_Data,EliteCount_Data,CrossoverFraction_Data,MaxGenerations_Data,MaxStallGenerations_Data,FunctionTolerance_Data,ConstraintTolerance_Data)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = optimoptions('ga');
%% Modify options setting
options = optimoptions(options,'InitialPopulationRange', InitialPopulationRange_Data);
options = optimoptions(options,'PopulationSize', PopulationSize_Data);
options = optimoptions(options,'EliteCount', EliteCount_Data);
options = optimoptions(options,'CrossoverFraction', CrossoverFraction_Data);
options = optimoptions(options,'MigrationDirection', 'both');
options = optimoptions(options,'MaxGenerations', MaxGenerations_Data);
options = optimoptions(options,'MaxStallGenerations', MaxStallGenerations_Data);
options = optimoptions(options,'FunctionTolerance', FunctionTolerance_Data);
options = optimoptions(options,'ConstraintTolerance', ConstraintTolerance_Data);
options = optimoptions(options,'NonlinearConstraintAlgorithm', 'penalty');
options = optimoptions(options,'SelectionFcn', @selectionroulette);
options = optimoptions(options,'Display', 'iter');
options = optimoptions(options,'PlotFcn', { @gaplotbestf });
[x,fval,exitflag,output,population,score] = ...
ga(@Objectivefcn,nvars,[],[],[],[],lb,ub,@Constraintfcn,[],options);
