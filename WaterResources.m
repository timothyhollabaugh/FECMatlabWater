% NOTE: Copy and paste your section of this ?Start Here? document into MatLab % to get started.
%
% In this document Green is for constants you enter, Lime is for 
% calculations or operations you need to perform, and Blue is for code that 
% should be left unchanged.
%
% Title: Water Pump Energy Systems
%
% Description: 
%
% Author: Lance Guzman, Tim Hollabaugh, Montana Carlozo
%
% Date of last revision: 2018-2-28
%
% Clear variables and close open figures
clear all
close all

%
% ================ Section 1 - Establish Site Parameters ==================
%
% Create Constants for the Latitude and Longitude in degrees
                                                                                                                                                                                                                                                                                                                                                                                                                                          
% Round the values for Latitude and Longitude
 
% Use xlsread to read Earth Skin Temp data and store it in a matrix called Tamb
 
% Use indexing to reduce Tamb to a 1 x 12 vector of temperatures for the site latitude and longitude
 
% Create a constant for the population 
 
% Create a constant for the daily water consumption per person in Liters
 
% Calculate the total daily volume of water consumed in Liters
 
% Convert the daily volume of water consumed to m^3
 
% Calculate the flow rate in m^3/s
 
% Create a constant for the water table depth in feet
 
% Convert the water table depth to meters
 
% Add 5 m to the water table depth to calculate the pump depth 
 

%
% ==================== Section 2 - Determine Daily Load ===================
%
% Pipe parameters (NOTE: You are advised to leave these values unchanged)
D_pipe=4.026; % Diameter (in inches) of nominal 4 inch PVC pipe
D_pipe=D_pipe*0.0254; % Diameter in meters
epsilon=0.0000015;% Absolute roughness of PVC pipe in meters
h_tank=5; % Height of discharge tank in meters.
k_entrance=0.5; % Loss coefficient at the entrance of the PVC pipe
k_elbow=1.1; % Loss coefficient at a sharp 90 degree elbow
n_elbow=4; % Number of elbows
k_exit=1; % Loss coefficient at the exit from the PVC pipe to the storage tank
%
% Calculate cross-sectional area of PVC pipe in square meters
A_pipe = (D_pipe/2)^2*pi
%
nu=0.000001004; % Kinematic viscosity (in m^2/s) of water at 20 C (NOTE: Leave 
% Unchanged)
%
% Calculate the velocity of water (m/s) through the pipe
v = Q/A_pipe
% Calculate the Reynold's number
Re = v*D_pipe/nu
% Use an if/then statement to set f = 0 if flow is zero
if v == 0
    f = 0;
else
    if Re <= 2100
        f = 64/Re;
    else
        ftop = 0.2479-0.0000947(7-log(Re))^4
        flog1 = ((epsilon)/(D_pipe))/3.615
        flog2 = 7.366/Re^(0.9142)
        f = (ftop)/((log(flog1+flog2))^2)
    end
end

% Use indexing or if/then statements to solve for f (for laminar versus 
% non=laminar flow)
% Make sure to end conditional statements
% 
g= 9.8; % acceleration of gravity in m/s^2 (DO NOT CHANGE)
%
%  Solve for Major and minor head losses

% 
rho = 998.2; % Density of water at 20 C in kg/m^3 (DO NOT CHANGE)
efficiency=0.8;% Pump efficiency (NOTE: You are advised to leave these values 
% unchanged)
%
% Solve for the daily energy required in MegaJoules


%
% ============== Section 3 - Determine Daily Solar Insolation =============
%
% Create a 1 x 12 vector for the number of each month of the year
 
%
% NOTE: DO NOT CHANGE MeanDay
MeanDay=[17,47,75,105,135,162,198,228,258,288,318,344]; % Ave day of month (Klein,1977)
%  
% Create a constant for the albedo/Ground reflectivity See 
% https://www.climatedata.info/forcing/albedo/ 
 
% Create a constant for the tilt angle of panels in degrees (Start with Beta 
% equal to the absolute value of the Latitude.  The test different values)
 
% Create a matrix for H values read from excel file for Global Horizontal 
% Solar kWh/m^2/day
 
% Use indexing to reduce H to a 1 X 12 vector for the values at the Latitude 
% and Longitude
 
% Convert H from kWh/m^2/day to MJ/m^2/day

% Create a vector called delta for the sun's declination angle in degrees for % each Mean Day
 
% Convert Latitude, Longitude, Beta, and delta from degrees to radians

%
% Sunset hour angle on a horizontal surface for each Mean Day in radians
wsh=acos(-tan(Latitude)*tan(delta)); % DO NOT CHANGE
%
% Calculate the Sunset hour angle on tilted panels in radians

% 
% Ratio of Beam radiation on a tilted to horizontal surface for each Mean Day
% DO NOT CHANGE
if Latitude>=0 % Ratio for North hemisphere
    Rb=(cos(Latitude-Beta)*cos(delta).*sin(ws)+...
    ws*sin(Latitude-Beta).*sin(delta))./...
    (cos(Latitude)*cos(delta).*sin(ws)+...
    ws*sin(Latitude).*sin(delta));
else % Ratio for South hemisphere
    Rb=(cos(Latitude+Beta)*cos(delta).*sin(ws)+...
    ws*sin(Latitude+Beta).*sin(delta))./...
    (cos(Latitude)*cos(delta).*sin(ws)+...
    ws*sin(Latitude).*sin(delta));
end
%
% Clearness Index (DO NOT CHANGE)
Gsc=1.367; % Solar constant in kW/m^2
Gon=Gsc*(1+0.033*cos(MeanDay*2*pi/365)); % Extra-terrestial insolation on a 
% normal surface

Ho=24*Gon/pi.*(cos(Latitude)*cos(delta).*sin(wsh)+...
wsh*sin(Latitude).*sin(delta)); % Daily Extra-terrestial solar energy 
%(kWh/m^2/day) on a horizontal 
% surface
KT=H./(Ho*3.6); % Clearness Index
%
% Hd (Diffuse Radiation) --> Collares, Pereira, Rhal relation (DO NOT CHANGE)
Hd(KT<=0.17)=0.99*H(KT<=0.17);
Hd(KT>0.17 & KT < 0.75)=(1.188-2.272*KT(KT>0.17 & KT<0.75)+...
    9.473*(KT(KT>0.17 & KT<0.75)).^2-21.865*(KT(KT>0.17 & KT<0.75)).^3+...
    14.648*(KT(KT>0.17 & KT<0.75).^4)).*H(KT>0.17 & KT<0.75);
Hd(KT>0.75 & KT < 0.8)=(0.632-0.54*KT(KT>0.75 & KT<0.8)).*H(KT>0.75 & KT<0.8);
Hd(KT>=0.8)=0.2*H(KT>=0.8);
%
% Calculate the average radiation incident on tilted solar panels in MJ


%
% ============== Section 3 - Determine Daily Solar Insolation =============
%
% Month vectors
MonthNumber=linspace(1,12,12); % Months of year
MeanDay=[17,47,75,105,135,162,198,228,258,288,318,344]; % Ave day of month %(Klein,1977)  
%
% Ground reflectivity 
albedo=0.2; % albedo at site See https://www.climatedata.info/forcing/albedo/ 
%
% Tilt angle of panels
Beta = abs(Latitude); % example) tilt angle = absolute value of Latitude     
%
% Vector of values for H  MJ/day
H=xlsread('GlobalHorizontalSolar.xlsx'); % H values worldwide in kW/m^2/day
H=H((H(:,1)==Latitude)& (H(:,2)==Longitude),3:end-1); % H values at site
H=H*3.6; % H values in MJ/m^2/day
%
% Create a vector for the sun's declination angle for each Mean Day
delta=23.45*sin(2*pi*(284+MeanDay)/365); % Declination angle in degrees
%
% Convert angles to radians
delta=delta*pi/180;
Latitude = Latitude*pi/180;
Longitude = Longitude*pi/180;
Beta=Beta*pi/180;
%
% Sunset hour angle on a horizontal surface for each Mean Day
 wsh=acos(-tan(Latitude)*tan(delta)); % Sunset angle on horizontal in radians
 %
 % Sunset hour angle on tilted panels
if Latitude>=0
    ws=min(acos(-tan(Latitude)*tan(delta)),...
    acos(-tan((Latitude-Beta))*tan(delta))); % Sunset angle on panels in North 
% hemisphere
else
    ws=min(acos(-tan(Latitude)*tan(delta)),...
    acos(-tan(Latitude+Beta)*tan(delta))); % Sunset angle on panels in South 
% hemisphere
end
%
% Ratio of Beam radiation on a tilted to horizontal surface for each Mean Day
if Latitude>=0 % Ratio for North hemisphere
    Rb=(cos(Latitude-Beta)*cos(delta).*sin(ws)+...
    ws*sin(Latitude-Beta).*sin(delta))./...
    (cos(Latitude)*cos(delta).*sin(ws)+...
    ws*sin(Latitude).*sin(delta));
else % Ratio for South hemisphere
    Rb=(cos(Latitude+Beta)*cos(delta).*sin(ws)+...
    ws*sin(Latitude+Beta).*sin(delta))./...
    (cos(Latitude)*cos(delta).*sin(ws)+...
    ws*sin(Latitude).*sin(delta));
end
%
% Clearness Index
Gsc=1.367; % Solar constant in kW/m^2
Gon=Gsc*(1+0.033*cos(MeanDay*2*pi/365)); % Extra-terrestial insolation on a 
% normal surface
Ho=24*Gon/pi.*(cos(Latitude)*cos(delta).*sin(wsh)+wsh*sin(Latitude).*sin(delta)); % Daily Extra-terrestial solar energy (kWh/m^2/day) on a horizontal surface
KT=H./(Ho*3.6); % Clearness Index
%
% Hd (Diffuse Radiation) --> Collares, Pereira, Rhal relation
Hd(KT<=0.17)=0.99*H(KT<=0.17);
Hd(KT>0.17 & KT < 0.75)=(1.188-2.272*KT(KT>0.17 & KT<0.75)+...
    9.473*(KT(KT>0.17 & KT<0.75)).^2-21.865*(KT(KT>0.17 & KT<0.75)).^3+...
    14.648*(KT(KT>0.17 & KT<0.75).^4)).*H(KT>0.17 & KT<0.75);
Hd(KT>0.75 & KT < 0.8)=(0.632-0.54*KT(KT>0.75 & KT<0.8)).*H(KT>0.75 & KT<0.8);
Hd(KT>=0.8)=0.2*H(KT>=0.8);
%
% Average radiation incident on tilted solar panels
Ht=H.*(1-Hd./H).*Rb+Hd*(1+cos(Beta))/2+H*albedo*(1-cos(Beta))/2;
%
% ================= Section 4 - Size Solar Solar Array ====================
%
% PV panel parameters: (Jinko Solar JKM260PP-60 used here)
Pmax=260; % maximum power (STC) in Watts    
alpha=-0.004; % Temperature coefficient (Change in power per cell temp. above 
% 25 C)
Eta=0.1588; % Panel Efficiency    
Apanel=1.650*0.992; % Panel area in meters squared    
UnitCost_Panel=295; % Dollars per solar panel    
% 
% Number of Solar Panels needed
N_Panels=max(ceil(Load./(Ht.*(1+alpha*(Tamb-25))*Eta*Apanel)));
%


%
% ================== Section 5 - Size Battery Storage =====================
%
% NOTE: You are advised to leave these values unchanged)
DOD = 0.5; % Depth of Discharge (Use 50% for longer life)
RTE= 0.80; % Round trip efficiency - Assume ~80%
%
% Select a battery and record its nominal voltage, its capacity, and cost
 
 

% Select a number of storage days (how long the system will last w/o sun)
 
% Calculate the available energy per battery and the required number of
% batteries (Round up to a whole number)
 
 


%
% ============== Section 6 - Calculate Electric Generator Size ============
%
% 
RunTime_Estimated= 10; %Estimated Run Time in hours (DO NOT CHANGE)
% Estimated the Required power in Watts assuming a run time of 10 hours
 
%
% Select a generator and set constants for the actual power, actual
% runtime, fuel tank capacity, and cost
 
 

 
% Calculate the fuel used daily
 


% ================= Section 7 - Calculate System Costs ====================
%
% Photovoltaic System:
InitialCost_Solar=N_Panels*UnitCost_Panel+N_Batteries*UnitCost_Battery;
%
% Electric Generator:
UnitCost_Fuel=3.56;% average cost per gallon in US    %EXAMPLE
DailyCost_Fuel=UnitCost_Fuel*Fuel_Daily;
YearlyCost_Fuel=DailyCost_Fuel*365;
%
d=0.02; % discount rate of money
%
% Calculate the Number of years for generator NPV to equal solar system NPV
%
syms n % Identify variable for Matlab summation
%
% Initialize Variables for Year and Costs
AccumulatedCost_Generator=InitialCost_Generator;
N=0;
Year(1)=0;
YearlyCost_Solar(1)=InitialCost_Solar;
AccumulatedCost_Solar(1)=InitialCost_Solar;
YearlyCost_Generator(1)=InitialCost_Generator;
AccumulatedCost_Generator(1)=YearlyCost_Generator(1);
% Sum the costs until the initial PV system cost equals the generated
% accumulated cost
while AccumulatedCost_Generator(end)<InitialCost_Solar(end)
    N=N+1; % When the loop end the value of N is the years until the generator  
% NPV is equal or greater than the solar system NPV
    Year(N+1)=N; % Increment year by 1
    YearlyCost_Solar(N+1)=0; % Assume no yearly solar costs
    AccumulatedCost_Solar(N+1)=AccumulatedCost_Solar(N)+YearlyCost_Solar(N+1); % Solar
    YearlyCost_Generator(N+1)=YearlyCost_Fuel^N; % Yearly 
% of fuel with discounted value of money    AccumulatedCost_Generator(N+1)=AccumulatedCost_Generator(N)+YearlyCost_Generator(N+1); %accumulated generator cost
end
%
% ================== Section 8 - Display Results ==========================
%
fprintf('\n The Latitude is %d degrees and the Longitude is %d degrees\n',Latitude*180/pi,Longitude*180/pi)
fprintf('\n The population is: %d \n',Population)
fprintf('\n The tilt angle of the panels is: %d degrees \n',Beta*180/pi)
fprintf('\n The required number of solar panels is: %d \n',N_Panels)
fprintf('\n The power of each solar panel is: %d W \n',Pmax)
fprintf('\n The system is designed for %d Storage Days \n',StorageDays)
fprintf('\n The required number of batteries is: %d \n',N_Batteries)
fprintf('\n The voltage of each battery is: %d Volts \n',V_Battery)
fprintf('\n The capacity of each battery is: %d Amp-hour \n',Capacity)
fprintf('\n The total cost of the solar energy system is: $%d \n',InitialCost_Solar)
fprintf('\n The power of the electric generator is: %.2f kW \n',P_Gen_Rated)
fprintf('\n The cost of the electric generator is: $%.2f \n',InitialCost_Generator)
fprintf('\n The year fuel cost to run the generator is: $%.2f \n',YearlyCost_Fuel)
fprintf('\n In %.1f years, the accumulated generator system cost will equal the ?
 solar energy system costs\n',N)
%
% Display yearly costs of both systems in a table
Year=Year';
YearlyCost_Solar=YearlyCost_Solar';
AccumulatedCost_Solar=AccumulatedCost_Solar';
YearlyCost_Generator=YearlyCost_Generator';
AccumulatedCost_Generator=AccumulatedCost_Generator';
T = table(Year,YearlyCost_Solar,AccumulatedCost_Solar,YearlyCost_Generator,AccumulatedCost_Generator)
%
% Plot solar energy produced versus month
Energy_Solar=N_Panels*(Ht.*(1+alpha*(Tamb-25))*Eta*Apanel);
bar(MonthNumber,Energy_Solar)
hold on
plot(MonthNumber,Load*ones(1,12),'r') % Display the load voltage on the plot
title({['\fontsize{12} Solar Energy Generated Per Month for Beta = ',...
    num2str(Beta*180/pi),'^o'];['\fontsize{10} Latitude = ',...
    num2str(Latitude*180/pi),'^o,  Longitude = ', ...
    num2str(Longitude*180/pi),'^o']},'FontWeight','Normal')
xlabel('Month')
ylabel('Energy in MJ')
legend('Solar Energy','Load')

