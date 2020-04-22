% Main file for running the program
% If the optimization terminates, try running again ot adjust optimization options.
close all
clear variables 
close all

%% Inputs: In this section, you should modify the string values to enter your desired inputs
%%
% Variables Setting: keywords, Modifiable Parameters in terms of Design Variables,  Output Variables

outputfilename='outputfilename = ''Job-1'';';
keyword='keyword={ ''Extrusion Depth-1'',  ''Extrusion Depth-2'',''Parameter-4'', ''Cut Extrusion Depth-1'',  ''Extrusion Depth-5'',    ''Extrusion Depth-6'',  ''Fillet-1'' ,  ''Fillet-2'' , ''Cut Extrusion Depth-2''  ,  ''Cut Extrusion Depth-3''  , ''Cut Extrusion Depth-4'' ,   ''Cut Extrusion Depth-5'',    ''Cut Extrusion Depth-6'' };';

param_val='y=       [         x(1)+0.001,             x(1)   ,   0.12- x(3),            x(1)-x(2),           x(1)*11/60                  x(1)*11/60,          (x(1)-x(2))/3        x(1)/3             x(2)*0.8     ,              x(2)*0.6 ,                 x(2)*0.4                        x(2)*0.2,                          x(2)*0.1 ]; '  ;

output_variables='output_variables={''Stress Invariant'' };';

%% Inputs of Optimization Functions: 
% Constraints in form of a matrix, Objective function in terms of Design and Output Variables



Constraints={'maxstress=170e6;',...
            'SINV = readFil(strcat(outputfilename,''.fil''),11);',...   % Von mises strain
            'SINVmtx=cell2mat(SINV);',...
            'MISES=max(SINVmtx(:,1))',...
            'a= MISES-maxstress;',...
            'c=a',...
            'ceq = [];'}; % commands which describe how to extract the results and return c and ceq
          
Objective= {'tt=x(1);',...
            'te=x(3);',...
            'tf=x(2);',...
            'density= 2780;',...
            'g=9.81;',...
            'weight= (pi*(0.03^2-0.016^2)*(tt+0.002))...',...
            '+10^(-6)*38954.54*tt ...',...
            '-(-0.74066262*te + 0.03898065)*(tt-tf)...',...
            '+2*0.052*pi*(0.035^2-0.025^2)...',...
            '+10^(-6)*599.16*11*tt/30 ...',...
            '- pi*0.25*tt *(1* 0.06145^2  + 0.8* (0.07145^2-0.06145^2)+   0.6* (0.08145^2-0.07145^2)+0.4* (0.11145^2-0.08145^2)+0.2* (0.12145^2-0.11145^2)+0.1* (0.13145^2-0.12145^2));',...
            'f=density*g*weight'};
      
%%
% Optimization Options of GA
nvars=3;
lb= [0.026 ,0.012 , 0.004];
ub= [0.033 ,0.017, 0.007];
% x0=[ 0.027,0.014 ,0.006];

global library Element_lib Node_lib file_jnl  Entry

global flagg flagg1 flagg2 flagg4 flagg5
flagg=0;
flagg1=0;
flagg2=0;
flagg4=0;
flagg5=0;

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
Create_Confunc(outputfilename,keyword,param_val,output_variables,Constraints)
Create_objfunc(Objective)

%% Input ABAQUS (.jnl) file 
[file_jnl FileFolder]=uigetfile('*.jnl','Open the jnl file');

% if the (.jnl) file  exists, create a single-line string based on the
% ABAQUS input file (.jnl) and run the Optimization 

    if (exist(file_jnl,'file')==2)
    Entry=Fil2strline( file_jnl);
    options=load('options_carm2.mat');
    [x,fval,exitflag,output,population,score] = ...
     ga(@Objectivefcn,nvars,[],[],[],[],lb,ub,@Constraintfcn,[],options);                                     
                
            
            else
    sprintf('please first run abaqus to generate jnl file')
    return;
    end


