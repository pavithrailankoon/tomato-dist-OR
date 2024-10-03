clc; clear all; close all;

% Importing data from Excel files
farmers_to_centers = xlsread('FarmersToCenters.xlsx');
centers_to_districts = xlsread('CentersToDistricts.xlsx');
demand = xlsread('DistrictDemand.xlsx');
supply = xlsread('FarmerSupply.xlsx');
center_capacity = xlsread('CenterCapacity.xlsx');

% Defining the optimization problem
prob = optimproblem;

% Defining variables
%num_farmers = size(farmers_to_centers, 1);
%num_centers = size(farmers_to_centers, 2);
%num_districts = size(centers_to_districts, 1);

num_farmers = 20;
num_centers = 15;
num_districts = 25;

x = optimvar('x', num_farmers, num_centers, 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % Farmers to centers
y = optimvar('y', num_centers, num_districts, 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % Centers to districts
z = optimvar('z', num_farmers, num_districts, 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % Binary variables

% Supply constraints
for i = 1:num_farmers
    prob.Constraints.(['supply_constraint_' num2str(i)]) = sum(x(i, :)) <= supply(i);
end

% Demand constraints
for j = 1:num_districts
    prob.Constraints.(['demand_constraint_' num2str(j)]) = sum(y(:, j)) >= demand(j);
end

% Center capacity constraints
for k = 1:num_centers
    prob.Constraints.(['center_capacity_constraint_' num2str(k)]) = sum(x(:, k)) <= center_capacity(k);
end

% Linking farmers to districts through centers
for i = 1:num_farmers
    for j = 1:num_districts
        % Ensure that z(i,j) is 1 if and only if farmer i is linked to district j
        prob.Constraints.(['linking_constraint_' num2str(i) '_' num2str(j)]) = z(i, j) <= sum(x(i, :)); % Link farmer to any center
        prob.Constraints.(['center_linking_' num2str(j) '_' num2str(k)]) = sum(z(:, j)) <= sum(y(k, j)); % Link centers to districts

        % Ensure that if z(i,j) is 1, then there must be a center used to connect
        %prob.Constraints.(['linking_constraint_2_' num2str(i) '_' num2str(j)]) = sum(x(i, :)) >= z(i, j); % Ensure a center is used if linked
    end
end

%centers_to_districts_new = reshape(centers_to_districts, num_centers, num_farmers);

% Defining the objective function (minimize distance)
distance_farmers_to_centers = sum(sum(farmers_to_centers .* x));
distance_centers_to_districts = sum(sum(centers_to_districts .* y'));
prob.Objective = distance_farmers_to_centers + distance_centers_to_districts;

% Solving the problem
options = optimoptions('intlinprog', 'MaxTime', 28800);
[sol, fval, exitflag, output] = solve(prob, 'Options', options);

% Define linear integer problem (convert to problem struct)
%problem = prob2struct(prob);

% Solve using intlinprog
%[sol, fval, exitflag, output] = intlinprog(problem);

% Display results
disp('Optimal assignment of farmers to centers:');
disp(sol.x);
disp('Optimal assignment of centers to districts:');
disp(sol.y);
disp(['Total minimized distance: ', num2str(fval)]);