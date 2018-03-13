vrep-matlab-interface

Setup:
- Copy the appropriate remote API library: "remoteApi.dll" (Windows), "remoteApi.dylib" (Mac) or "remoteApi.so" (Linux) from the vrep folder to this folder.

Run example:
- load the "vrep_drone_model_visualisation.ttt" scene into V-REP.
- execute "Initialize_Visualisation.m" in matlab.
- Run "Drone_example.slx" in simulink.

FAQ:
Q: My simulation runs way to fast, how can I slow it down.
A: There are muttiple solutions, easiest is to togle real-time mode on in V-REP, this wil force Simulink to slow down.
