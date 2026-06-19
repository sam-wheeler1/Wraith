clear
clc
close all

%---------------------
% Pressure Calculations
%---------------------

% This script is designed to calculate the inlet and outlet pressure
% that will be applied in CFD on the inlet.

%---------------------
% Inlet Geometry Study
%---------------------

% The first step of our CFD process is creating a Latin Hypercube model
% of the inlet with parameterized dimensions on inlet face, length,
% curvature, and other design points


%--------------
% Parameters
%--------------

temperature_F = 70; %Farenenheit; we are assuming room temperature
temperature_C = (temperature_F-32)*(5/9); %Celsius
mi_per_hr = 300;
m_per_s = mi_per_hr/2.237;
speed_of_sound = 331 * sqrt(1 + (temperature_C/273.15));
Freestream_Mach = m_per_s/speed_of_sound; % unitless
Altitude = [0, 300, 10000]; % m; three altitudes: testing, rc flight, intended operation
specific_heat_ratio = 1.4; % assuming dry air

%---------------------
% Equations
%---------------------

% Static pressure does not include edf fan suction, which is not needed for
% geometric comparion. This will be included later, however.
static_pressure = 101325*(1 - 0.0065*Altitude/288.15).^5.2559; % not including change in pressure due to suction of edf, since part 1 is purely comparing geometry

% Since the aircraft will be moving at subsonic speeds, we assume isentropic
% flow and use the following equation to calculate the total pressure at the
% inlet face

total_pressure = static_pressure.*(1 + ((specific_heat_ratio - 1)/2)*Freestream_Mach.^2)^(specific_heat_ratio/(specific_heat_ratio-1));

fprintf("The total pressure at the testing altitude is %.1f pa and the static pressure is %.1f pa \n", total_pressure(1),static_pressure(1))
fprintf("The total pressure at the RC flight altitude is %.1f pa and the static pressure is %.1f pa \n", total_pressure(2),static_pressure(2))
fprintf("The total pressure at the intended operation flight altitude is %.1f pa and the static pressure is %.1f pa \n", total_pressure(3),static_pressure(3))

