%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% File: vrep_interface.m
%
% REMARKS
%
% created with MATLAB ver.: 9.3.0.713579 (R2017b) on Mac OS X  Version: 10.13.2 Build: 17C60c
%
% created by: Dave Kooijman
% DATE: 09-Nov-2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function vrep_visualisation(block)
%%
%% The setup method is used to set up the basic attributes of the
%% S-function such as ports, parameters, etc. Do not add any other
%% calls to the main body of the function.
%%
setup(block);

%endfunction

%% Function: setup ===================================================
%% Abstract:
%%   Set up the basic characteristics of the S-function block such as:
%%   - Input ports
%%   - Output ports
%%   - Dialog parameters
%%   - Options
%%
%%   Required         : Yes
%%   C-Mex counterpart: mdlInitializeSizes
%%
function setup(block)

% Register number of ports
block.NumInputPorts  = 3;
block.NumOutputPorts = 0;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties
block.InputPort(1).Dimensions  = 3;
block.InputPort(1).DatatypeID  = 0;  % double
block.InputPort(1).Complexity  = 'Real';
block.InputPort(1).DirectFeedthrough = true;

block.InputPort(2).Dimensions  = 3;
block.InputPort(2).DatatypeID  = 0;  % double
block.InputPort(2).Complexity  = 'Real';
block.InputPort(2).DirectFeedthrough = true;

block.InputPort(3).Dimensions  = 4;
block.InputPort(3).DatatypeID  = 0;  % double
block.InputPort(3).Complexity  = 'Real';
block.InputPort(3).DirectFeedthrough = true;

% Override output port properties

% Register parameters
block.NumDialogPrms     = 2;

% Register sample times
%  [0 offset]            : Continuous sample time
%  [positive_num offset] : Discrete sample time
%
%  [-1, 0]               : Inherited sample time
%  [-2, 0]               : Variable sample time
block.SampleTimes = [-1, 0];

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'CustomSimState',  < Has GetSimState and SetSimState methods
%    'DisallowSimState' < Error out when saving or restoring the model sim state
block.SimStateCompliance = 'DefaultSimState';

%% -----------------------------------------------------------------
%% The MATLAB S-function uses an internal registry for all
%% block methods. You should register all relevant methods
%% (optional and required) as illustrated below. You may choose
%% any suitable name for the methods and implement these methods
%% as local functions within the same file. See comments
%% provided for each function for more information.
%% -----------------------------------------------------------------

block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Start', @Start);
block.RegBlockMethod('Outputs', @Outputs);     % Required
block.RegBlockMethod('Update', @Update);
block.RegBlockMethod('Derivatives', @Derivatives);
block.RegBlockMethod('Terminate', @Terminate); % Required
block.RegBlockMethod('SetInputPortSamplingMode', @SetInpPortFrameData);
%end setup


%%
%% PostPropagationSetup:
%%   Functionality    : Setup work areas and state variables. Can
%%                      also register run-time methods here
%%   Required         : No
%%   C-Mex counterpart: mdlSetWorkWidths
%%
function DoPostPropSetup(block)
block.NumDworks = 1;
  
  block.Dwork(1).Name            = 'handles';
  block.Dwork(1).Dimensions      = 2;
  block.Dwork(1).DatatypeID      = 6;      % int32
  block.Dwork(1).Complexity      = 'Real'; % real
  block.Dwork(1).UsedAsDiscState = true;

%%
%% InitializeConditions:
%%   Functionality    : Called at the start of simulation and if it is 
%%                      present in an enabled subsystem configured to reset 
%%                      states, it will be called when the enabled subsystem
%%                      restarts execution to reset the states.
%%   Required         : No
%%   C-MEX counterpart: mdlInitializeConditions
%%
function InitializeConditions(block)

%end InitializeConditions


%%
%% Start:
%%   Functionality    : Called once at start of model execution. If you
%%                      have states that should be initialized once, this 
%%                      is the place to do it.
%%   Required         : No
%%   C-MEX counterpart: mdlStart
%%
function Start(block)
global vrep clientID;
vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
vrep.simxFinish(-1); % just in case, close all opened connections
clientID=vrep.simxStart(block.DialogPrm(2).Data,19997,true,true,5000,5);
vrep.simxSynchronous(clientID,true);
vrep.simxSetFloatingParameter(clientID, vrep.sim_floatparam_simulation_time_step, block.DialogPrm(1).Data, vrep.simx_opmode_oneshot_wait);

%get ObjectHandles
[~, quad_base] = vrep.simxGetObjectHandle(clientID,'Quadricopter',vrep.simx_opmode_blocking);
[~, target] = vrep.simxGetObjectHandle(clientID,'Quadricopter_target',vrep.simx_opmode_blocking);
%set streaming mode
%vrep.simxGetObjectPosition(clientID,quad_base,-1,vrep.simx_opmode_streaming);
%vrep.simxGetObjectVelocity(clientID,quad_base,vrep.simx_opmode_streaming);
%vrep.simxGetObjectOrientation(clientID,quad_base,-1,vrep.simx_opmode_streaming);

block.Dwork(1).Data = [quad_base; target];

vrep.simxStartSimulation(clientID,vrep.simx_opmode_blocking);

%end Start

%%
%% Outputs:
%%   Functionality    : Called to generate block outputs in
%%                      simulation step
%%   Required         : Yes
%%   C-MEX counterpart: mdlOutputs
%%
function Outputs(block)
global vrep clientID;
%[~, pos] = vrep.simxGetObjectPosition(clientID,block.Dwork(1).Data(1),-1,vrep.simx_opmode_buffer);
%[~, vel, ang_vel] = vrep.simxGetObjectVelocity(clientID,block.Dwork(1).Data(1),vrep.simx_opmode_buffer);
%[~, euler] = vrep.simxGetObjectOrientation(clientID,block.Dwork(1).Data(1),-1,vrep.simx_opmode_buffer);
%[~, quaternion] = vrep.simxGetObjectGroupData(clientID,block.Dwork(1).Data(1),-1,vrep.simx_opmode_buffer);

%block.OutputPort(1).Data = double(pos);
%block.OutputPort(2).Data = double(vel);
%block.OutputPort(3).Data = double(euler);
%block.OutputPort(4).Data = double(ang_vel);

%end Outputs

%%
%% Update:
%%   Functionality    : Called to update discrete states
%%                      during simulation step
%%   Required         : No
%%   C-MEX counterpart: mdlUpdate
%%
function Update(block)
global vrep clientID;
vrep.simxSynchronousTrigger(clientID);
[~] = vrep.simxSetObjectPosition(clientID,block.Dwork(1).Data(2),-1,block.InputPort(1).Data,vrep.simx_opmode_oneshot);
[~] = vrep.simxSetObjectPosition(clientID,block.Dwork(1).Data(1),-1,block.InputPort(2).Data,vrep.simx_opmode_oneshot);
[~] = vrep.simxSetObjectQuaternion(clientID,block.Dwork(1).Data(1),-1,block.InputPort(3).Data,vrep.simx_opmode_oneshot);
%[~] = vrep.simxSetFloatSignal(clientID, 'Roll', block.InputPort(2).Data(1), vrep.simx_opmode_oneshot);
%[~] = vrep.simxSetFloatSignal(clientID, 'Pitch', block.InputPort(2).Data(2), vrep.simx_opmode_oneshot);
%[~] = vrep.simxSetFloatSignal(clientID, 'Yaw', block.InputPort(2).Data(3), vrep.simx_opmode_oneshot);
%end Update

%%
%% Derivatives:
%%   Functionality    : Called to update derivatives of
%%                      continuous states during simulation step
%%   Required         : No
%%   C-MEX counterpart: mdlDerivatives
%%
function Derivatives(block)

%end Derivatives

%%
%% Terminate:
%%   Functionality    : Called at the end of simulation for cleanup
%%   Required         : Yes
%%   C-MEX counterpart: mdlTerminate
%%
function Terminate(block)
global vrep clientID;
vrep.simxStopSimulation(clientID,vrep.simx_opmode_oneshot);
pause(0.1);
vrep.simxFinish(clientID);
vrep.delete(); % call the destructor!

%end Terminate

function SetInpPortFrameData(block, idx, fd)
block.InputPort(idx).SamplingMode = fd;
