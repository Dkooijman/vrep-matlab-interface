%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% File: Initialize_Visualisation
%
% REMARKS
%
% created with MATLAB ver.: 9.3.0.713579 (R2017b) on Mac OS X  Version: 10.13.3 Build: 17D102 
%
% created by: Dave Kooijman
% DATE: 13-Mar-2018
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; close all; clear all;

dt_ll = 1/200;
dt_hl = 1/20;
dt_visual = 1/20;

g = 9.81;       %gravitational constant
mass = 1.05;    %mass of the quadrotor
MomInertia = diag([0.005 0.005 0.008]); %inertia of the quadrotor