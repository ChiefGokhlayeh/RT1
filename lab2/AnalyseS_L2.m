% Regelungstechnik 1 und 2
% (C) 2019 W.Lindermeir, W.Zimmermann
% Hochschule Esslingen
%
% Level-2 MATLAB file S-Function (nach Beispiel msfuntmpl_basic.m)
% zur Ermittlung der Bewertungsgrößen relative Überschwingweite, An- und Ausregelzeit einer Sprungantwort 
%
function AnalyseS_L2(block)
  setup(block);
%endfunction

function setup(block)
  %% Register number of input and output ports
  block.NumInputPorts  = 2;
  block.NumOutputPorts = 0;
  %% Setup functional port properties to dynamically inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
  %% Override input port properties
  block.InputPort(1).Dimensions  = 1;              % sollwert
  block.InputPort(1).DatatypeID  = 0;  % double
  block.InputPort(1).Complexity  = 'Real';
  block.InputPort(1).DirectFeedthrough = false;
  block.InputPort(2).Dimensions  = 1;              % gemessener Istwert
  block.InputPort(2).DatatypeID  = 0;  % double
  block.InputPort(2).Complexity  = 'Real';
  block.InputPort(2).DirectFeedthrough = false;
  %% Register parameters
  block.NumDialogPrms  = 1;
  % Register sample times
  block.SampleTimes = [0 0];          
  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';
  %% Register methods
  block.RegBlockMethod('PostPropagationSetup', @DoPostPropSetup);
  block.RegBlockMethod('Start',                @Start);
  block.RegBlockMethod('Update',               @Update);  
  block.RegBlockMethod('Outputs',              @Output);    % Required
  block.RegBlockMethod('Terminate',            @Terminate); % Required
%endfunction

function DoPostPropSetup(block)
  %% Setup Dwork
  block.NumDworks = 1;
  block.Dwork(1).Name = 'tol';   block.Dwork(1).DatatypeID = 0; % double
  block.Dwork(1).Dimensions      = 1;
  block.Dwork(1).Complexity      = 'Real';
  block.Dwork(1).UsedAsDiscState = false;
%endfunction

function Start(block)
global t__ yist__
  %% Initialize Dwork
  block.Dwork(1).Data = block.DialogPrm(1).Data;  % tol
  t__    = [];
  yist__ = [];
%endfunction

function Update(block)
global t__ yist__
  t__    = [t__    block.InputPort(1).Data];  % w
  yist__ = [yist__ block.InputPort(2).Data];  % yist
%endfunction

function Output(block)
 
%endfunction

function Terminate(block)
global t__ yist__
  tol  = block.Dwork(1).Data;
  Analyse(yist__, t__, tol/100 );
  grid on;
%end Terminate

