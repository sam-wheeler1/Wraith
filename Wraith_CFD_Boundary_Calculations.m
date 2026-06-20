clear
clc
close all

% Author: Sam Wheeler

% This script is designed to calculate the inlet and outlet pressure
% that will be applied in CFD on the inlet and thrust tube system

%---------------------
% Part 1: Inlet Geometry Study
%---------------------

% Parameters
altitude = [0, 300, 10000]; % m; three altitudes: testing, rc flight, intended operation
temperature_F = 70; % Farenheit; assume room temperature at 0 m altutitude
temperature_C = (temperature_F-32)*(5/9) - 6.5*(altitude./1000); % Celsius
temperature_K = temperature_C + 273.15; % Kelvin
mi_per_hr = 300; % mi/hr
m_per_s = mi_per_hr/2.237; %m/s
speed_of_sound = 331 * sqrt(1 + (temperature_C/273.15)); %m/s
freestream_Mach = m_per_s./speed_of_sound; % unitless
specific_heat_ratio = 1.4; % assuming dry air


% Equations

% Static pressure does not include edf fan suction, which is not needed for geometric comparion
static_pressure = 101325*(1 - 0.0065*altitude/288.15).^5.2559;

% Since subsonic speeds, we assume isentropic flow and use the following equation to calculate
% total pressure at the inlet face. By using Pressure Far-Field in ANSYS, 
% total pressure will be auto calculated, however for research purposes the values are found manually

total_pressure = static_pressure.*(1 + ((specific_heat_ratio - 1)/2)*freestream_Mach.^2).^(specific_heat_ratio/(specific_heat_ratio-1));

%---------------------------------------
% Step 2: Finding pressure drop from EDF
%---------------------------------------

% Using the data given by the manufacturer to find mass flow rate of the EDF

% Manufacturer Information

% Note: Thrust assumed to be found in a static test, future work will
% feature true tested fan performance

thrust = (3790/1000)*9.81; % N; at full throttle
radius_outer = 45.1/1000;
radius_inner = 17.65/1000;

% Parameters
R_air = 287; % J/(kg*K)
rho = static_pressure./(R_air * temperature_K);
fan_swept_area = pi*(radius_outer^2 - radius_inner^2);

% Mass flow rate at edf face found using thrust momentum equation
% T = mdot(v_exit - v_in)
v_static = 0;
v_exit = sqrt((2*thrust)./(rho.*fan_swept_area) + v_static.^2);
mdot_edf = rho.*fan_swept_area.*((v_exit + v_static)./2);

%----------------
%Print Statements
%----------------

for i = 1:length(altitude)

    fprintf("---------------------------------\n")
    fprintf("Altitude: %.0f m\n", altitude(i))
    fprintf("---------------------------------\n\n")

    fprintf("Part 1: Inlet Geometry Study\n")
    fprintf("  Inlet Boundary: Pressure Far-Field\n")
    fprintf("    Static Pressure: %.1f Pa\n", static_pressure(i))
    fprintf("    Static Temperature: %.2f K\n", temperature_K(i))
    fprintf("    Freestream Mach Number: %.3f\n", freestream_Mach(i))
    fprintf("    Freestream Total Pressure: %.1f Pa\n", total_pressure(i))
    fprintf("  Exit Boundary: Mass Flow Outlet\n")
    fprintf("    Mass Flow Rate: %.3f kg/s\n\n", mdot_edf(i))

    fprintf("Part 2: EDF Study\n")
    fprintf("  EDF Boundary: Mass Flow at Fan Faces\n")
    fprintf("    Mass Flow Rate In: %.3f kg/s\n", mdot_edf(i))
    fprintf("    Mass Flow Rate Out: %.3f kg/s\n\n", mdot_edf(i))

    fprintf("Part 3: Thrust Tube Study\n")
    fprintf("  Inlet Boundary: Mass Flow Inlet\n")
    fprintf("    Mass Flow Rate: %.3f kg/s\n", mdot_edf(i))
    fprintf("  Exit Boundary: Pressure Outlet\n")
    fprintf("    Static Pressure: %.1f Pa\n\n\n", static_pressure(i))

end
