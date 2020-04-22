%% Main file for running the program
% In this script, you should enter your desired inputs as well as your ...
% input ABAQUS file.

%Note that this script is not executable and should be written based on the
%instructions and examples attached

close all
clear variables 
close all

%% Inputs: In this section, you should modify the string values to enter your desired inputs
% *** Variables Setting:
%     keywords, Modifiable Parameters in terms of Design Variables,  Output Variables

outputfilename=...    % The name of ABAQUS executive and output files
    'outputfilename = ''Job-1'';';

keyword='keyword={};' % Your desired keywords which represent the parameters whose values change 
                      % during the optimization should be placed inside the bracket

param_val='y= f(x)';  % the values of parameters should be defined in terms of design variables
                      % and should be places inside the ' ' 
%____________________________________________________________________________________________

% *** Inputs of Optimization Functions: 
%     Constraints in form of a matrix, Objective function in terms of Design and Output Variables

Constraints={''};    %  Matlab commands which describe how to extract the results 
                     %  and define the inequlaity and equality equations
                     
Objective={''};      %  Matlab commands which define the objective function               
 
%____________________________________________________________________________________________
       
% *** Optimization Options of GA
%     number of variables,d esign variable ranges (bounds, and options used in optimization
nvars=0;             %  number of design variables
lb=[] ;
ub= [];
options=load('options'); % you should enter your desired optimization options

%% Library for searching the value of a geometric feature

global library Element_lib Node_lib file_jnl  Entry

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
% create the constraint and objective functions based on the inputs
Create_Confunc(outputfilename,keyword,param_val,output_variables,Constraints)

Create_objfunc(Objective)

%% Input ABAQUS (.jnl) file and run the optimization

[file_jnl FileFolder]=uigetfile('*.jnl','Open the jnl file');

    if (exist(file_jnl,'file')==2)                  % if the (.jnl) file  exists 
        
    Entry=Fil2strline( file_jnl)                    % convert the contents of the jnl file to a single-line string
    
    [x,fval,exitflag,output,population,score] = ... % run the optimization 
          ga(@Objectivefcn,nvars,[],[],[],[],lb,ub,@Constraintfcn,[],options);  
 
    else
    sprintf('please first run abaqus to generate jnl file')
    return;
   
    end


