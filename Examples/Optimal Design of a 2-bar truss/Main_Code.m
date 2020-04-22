% Main file for running the program
close all
clear variables 
close all

%% Inputs: In this section, you should modify the string values to enter your desired inputs
%%
% Variables Setting: keywords, Modifiable Parameters in terms of Design Variables,  Output Variables

outputfilename='outputfilename = ''Job-1'';';
keyword='keyword={''Truss Section Area-1'',''Truss Section Area-2''};';
param_val='y=x;';
output_variables='output_variables={''Stress Invariant'' };';

%%
% Inputs of Optimization Functions: Constraints in form of a matrix, Objective function in terms of
%  Design and Output Variables

% how to extract the results

Constraints={' Dmaxhor=0.0508;',...
              'Dmaxver=0.0508;',...
              'maxstress=172.369e6;',...
              'out2 = readFil(''Job-1.fil'',101);',...
              'NodalDisplacements=out2{1,1}(:,2:3);',...
              'S_stress = readFil(''Job-1.fil'',11);',...
              'stress=S_stress{1,1}(:,1);',...
              'stress =max(abs(stress))',...
              'maxNodDisplX1=max(abs(NodalDisplacements(:,1)))',...
              'maxNodDisplY1=max(abs(NodalDisplacements(:,2)))',...
              'c = [(maxNodDisplY1-Dmaxver)/maxNodDisplY1; (maxNodDisplX1-Dmaxhor)/Dmaxhor; (stress-maxstress)/maxstress]   ',...
              'ceq = [];',...
              'x'};
          
 Objective={  'global Wmat Fmat Xmat',...
              'u=9.144;',...
              'weight = 9.81*2767.99*x*u*[1;sqrt(2)]',...
              'f =  9.81*2767.99*x*u*[1;sqrt(2)]',...
              'Fmat=[f; Fmat];',...
              'Wmat=[weight; Wmat];',...
              'Xmat=[x;Xmat];' };         
           
        
%% Optimization Options of GA

nvars=2; %number of design variables
lb= 0.00365*  ones(nvars,1);
ub= 0.02258*  ones(nvars,1);

%% Library

global library Element_lib Node_lib file_jnl  Entry

global flagg flagg1 flagg2 flagg4 flagg5
flagg=0;
flagg1=0;
flagg2=0;
flagg4=0;
flagg5=0;
global Cmat Xmat Fmat  Wmat
Cmat=[]; 
Xmat=[];
Fmat=[];
Wmat=[];



%% Library for searching the value of a geometric feature
Element_lib={'Principal strains'   ,  'Principal stresses'  , 'Stress'  , 'Total Strain' , 'Section Force and Moment' , 'Plastic Strain' , 'Stress Invariant'  ;...
                403,                  401                   , 11        , 21             , 13                         , 22             ,12 ;...
                'EP',                 'SP'                  ,'S'        ,'E'             ,'SF'                        , 'PE'      ,'SINV'};
            
Node_lib= { 'Reaction Force'   ,'Displacement' , 'Acceleration';...
                104            ,101            , 103 ;...
                'RF'           , 'U'           , 'A'};


library={'Parameter',        'Truss Section Area', 'Elasticity',           'Density',         'Extrusion Depth',    'Cut Extrusion Depth' , 'Fillet';...
   'Parameter(expression=''','TrussSection(area=' ,'Elastic(table=((', 'Density(table=((', 'SolidExtrude(depth=','CutExtrude(depth='      , 'Round';...
   'Parameter(expression=''','TrussSection(area=' ,'Elastic(table=((', 'Density(table=((', 'SolidExtrude(depth=','CutExtrude(depth='      ,   'radius='  ;...          
   ''', name',                ', material'          ,', ',              ', )'   ,                ', ',            ', '                    ,        ')%%'};

%% Create Constraint and Objective Function
Create_Confunc(outputfilename,keyword,param_val,output_variables,Constraints);
Create_objfunc(Objective);

%% Input ABAQUS (.jnl) file 
[file_jnl FileFolder]=uigetfile('*.jnl','Open the jnl file');

% if the (.jnl) file  exists, create a single-line string based on the
% ABAQUS input file (.jnl) and run the Optimization 

    if (exist(file_jnl,'file')==2)
    Entry=Fil2strline( file_jnl);
    
    options=load('options_truss.mat');
    [x,fval,exitflag,output,population,score] = ...
        ga(@Objectivefcn,nvars,[],[],[],[],lb,ub,@Constraintfcn,[],options);                               
%             
    else
    sprintf('please first run abaqus to generate jnl file')
    return;
    end


