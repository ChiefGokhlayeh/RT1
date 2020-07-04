% Laborversuch: Simulation
% Regelungstechnik 1
% (C) 2019 W.Lindermeir, W.Zimmermann
% Hochschule Esslingen
%
% Level-2 MATLAB file S-Function (nach Beispiel msfuntmpl_basic.m)
% zur Darstellung eines Aufzugs
% (Kann nur einmal in einem Simulink-Blockschaltbild verwendet werden)
%

function AufzugAnimation_L2(block)
  setup(block);
%endfunction

function setup(block)
  %% Register number of input and output ports
  block.NumInputPorts  = 1;
  block.NumOutputPorts = 1;
  %% Setup functional port properties to dynamically inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
  %% Override input port properties
  block.InputPort(1).Dimensions  = 1;
  block.InputPort(1).DatatypeID  = 0;  % double
  block.InputPort(1).Complexity  = 'Real';
  block.InputPort(1).DirectFeedthrough = true;
  % Override output port properties
  block.OutputPort(1).Dimensions  = 1;
  block.OutputPort(1).DatatypeID  = 0; % double
  block.OutputPort(1).Complexity  = 'Real';
  %% Register parameters
  block.NumDialogPrms  = 1;
  % Register sample times
  block.SampleTimes = [block.DialogPrm(1).Data 0];
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
  block.NumDworks = 0;
%endfunction

function Start(block)
  global aufzuganimationsfigure h__ xout
  xout = 10; % this is the default start position normally used in the block diagramms
  aufzuganimationsfigure = findobj('Type','figure','Name','AufzugAnimationsFigure');
  if ~isempty(aufzuganimationsfigure)
     close(aufzuganimationsfigure);
  end
  aufzuganimationsfigure=figure;
  set(aufzuganimationsfigure,'Name','AufzugAnimationsFigure');
  clf
  axis equal;
  axis([0 2 0 20]);
  % elevator cage
  h__ = rectangle('Position',[0,10,2,2], 'Curvature',[0.1,0.1], 'FaceColor','b');
  title('AufzugAnimationsFigure');
  ylabel('Position x [m]');
  pos=0.11; delta=0.12;
  uicontrol('Style','pushbutton','Units','normalized','Position',[0.7 pos+0*delta 0.2 0.1],'String','EG - 1m',        'Interruptible','off','Callback',{@Button_update_fkt,1} );
  uicontrol('Style','pushbutton','Units','normalized','Position',[0.7 pos+1*delta 0.2 0.1],'String','1. STOCK - 4m',  'Interruptible','off','Callback',{@Button_update_fkt,2} );
  uicontrol('Style','pushbutton','Units','normalized','Position',[0.7 pos+2*delta 0.2 0.1],'String','2. STOCK - 7m',  'Interruptible','off','Callback',{@Button_update_fkt,3} );
  uicontrol('Style','pushbutton','Units','normalized','Position',[0.7 pos+3*delta 0.2 0.1],'String','3. STOCK - 10m', 'Interruptible','off','Callback',{@Button_update_fkt,4} );
  uicontrol('Style','pushbutton','Units','normalized','Position',[0.7 pos+4*delta 0.2 0.1],'String','4. STOCK - 13m', 'Interruptible','off','Callback',{@Button_update_fkt,5} );
  uicontrol('Style','pushbutton','Units','normalized','Position',[0.7 pos+5*delta 0.2 0.1],'String','5. STOCK - 16m', 'Interruptible','off','Callback',{@Button_update_fkt,6} );
  hold on
%endfunction

function Update(block)
  global aufzuganimationsfigure h__ 
  persistent uold 
  u = block.InputPort(1).Data;
  if any(get(0,'Children')==aufzuganimationsfigure),
     if strcmp(get(aufzuganimationsfigure,'Name'),'AufzugAnimationsFigure'),
        set(0,'currentfigure',aufzuganimationsfigure);
        if u~=uold
            set(h__, 'Position',[0, u, 2, 2]);
        end
        uold=u;
     end
  end
%endfunction

function Output(block)
global xout
  block.OutputPort(1).Data = xout;
%endfunction

function Terminate(block)
  global aufzuganimationsfigure 
  if any(get(0,'Children')==aufzuganimationsfigure),
     if strcmp(get(aufzuganimationsfigure,'Name'),'AufzugAnimationsFigure'),
        set(0,'currentfigure',aufzuganimationsfigure);
        hold off
     end
  end
%end Terminate


function Button_update_fkt(src,event,but_pressed)
global xout
if     but_pressed == 1
  xout = 1;  % will be output as xsoll position
elseif but_pressed == 2
  xout = 4;  % will be output as xsoll position
elseif but_pressed == 3
  xout = 7;  % will be output as xsoll position
elseif but_pressed == 4
  xout = 10; % will be output as xsoll position
elseif but_pressed == 5
  xout = 13; % will be output as xsoll position
elseif but_pressed == 6
  xout = 16; % will be output as xsoll position
end
