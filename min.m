clc; clear; close all;


%% Load Data From Excel Files

farmers_to_centers = xlsread('FarmersToCenters.xlsx');      % Distance matrix (20x15)
centers_to_districts = xlsread('CentersToDistricts.xlsx');     % Distance matrix (15x25)
demand = xlsread('DistrictDemand.xlsx');                           % Demand for each district (1x25)
supply = xlsread('FarmerSupply.xlsx');                                % Supply from each farmer (1x20)
center_capacity = xlsread('CenterCapacity.xlsx');                % Capacity of each economic center (1x15)


%% Define the Optimization Problem

prob = optimproblem;


%% Decision Variables

x1 = optimvar('x1', 20, 15, 'LowerBound', 0);       % The amount shiped from Farmer to economic center
x2 = optimvar('x2', 15, 25, 'LowerBound', 0);       % The amount shipped from Economic center to district


%% Constraints

% Get the number of elements in center_capacity
numCenters = numel(center_capacity);

% Corrected supply constraints with the adjusted loop
supply_constraints = optimconstr(numCenters);

for j = 1:numCenters
    % Correctly indexing within the bounds of center_capacity
    supply_constraints(j) = sum(x1(:, j)) == center_capacity(j);
end

% showconstr(supply_constraints)

prob.Constraints.supply_constraints = supply_constraints;



%% Ensure Economic Center's Distribution Meets the District's Demand

demand_constraints = optimconstr(25);

for k = 1:25
    demand_constraints(k) = sum(x2(:, k)) == demand(k);
end

% showconstr(demand_constraints)

prob.Constraints.demand_constraints = demand_constraints;



%% Ensure Total Supply Does not Exceed Farmer's Production

farmer_constraints = optimconstr(20);
for i = 1:20
    farmer_constraints(i) = sum(x1(i, :)) == supply(i);
end

% showconstr(farmer_constraints)

prob.Constraints.farmer_constraints = farmer_constraints;


%% Get the Number of Elements in Center_Capacity

numCenters = numel(center_capacity);

% Correctly define the capacity constraints
capacity_constraints = optimconstr(numCenters);
for j = 1:numCenters
    % Define the constraint that each economic center's capacity must be greater than zero
    % capacity_constraints(j) = sum(x2(j, :)) <= center_capacity(j);
    capacity_constraints(j) = sum(x2(j, :)) == sum(x1(:, j));
end

% showconstr(capacity_constraints)

prob.Constraints.capacity_constraints = capacity_constraints;


%% Objective Function: Minimize the Cost (Cost = Distance)

cost =  sum(sum(farmers_to_centers .* x1)) + sum(sum(centers_to_districts' .* x2)); %-1000*sum(sum( x1));

prob.Objective = cost;

% Solving the Problem
options = optimoptions('linprog', 'MaxTime', 28800);
[sol, fval, eflag, output] = solve(prob, 'Options', options);

% Display results
disp('Optimal Distribution Plan:');
disp(sol);
disp(['Minimum Cost: ', num2str(fval)]);