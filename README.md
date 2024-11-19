
# MATLAB Optimization Research Project: Tomato Distribution in Sri Lanka

## Overview

This MATLAB project aims to minimize the cost of distributing tomatoes across Sri Lanka, from farmers to economic centers and then to district centers. The distribution cost is calculated based on the distance between these locations, and the code optimizes the routes to meet demand while adhering to capacity constraints.

The project uses MATLAB's `optimproblem` and `optimvar` functions to set up and solve the optimization problem.

## Files and Data Requirements

The project relies on four `.xlsx` files as input data. Ensure these files are in the same directory as the MATLAB script or update the code to point to their specific location.

1. `farmers_to_centers.xlsx` – Contains the distance matrix between farmers and economic centers.
2. `centers_to_districts.xlsx` – Contains the distance matrix between economic centers and each district centers.
3. `district_demand.xlsx` – Lists the tomato demand (in metric tons) for each district.
4. `farmer_supply.xlsx` – Lists the supply capacity (in metric tons) of each farmer.

## Instructions for Running the Code

### 1. Load the Data

The code will load data from the `.xlsx` files and initialize it as matrices in MATLAB. Ensure the file names in the code match the actual file names.

```matlab
farmers_to_centers = xlsread('FarmersToCenters.xlsx'); 
centers_to_districts = xlsread('CentersToDistricts.xlsx');  
demand = xlsread('DistrictDemand.xlsx');                           
supply = xlsread('FarmerSupply.xlsx');   
center_capacity = xlsread('CenterCapacity.xlsx');  
```


## 2. Define Optimization Variables

The code uses MATLAB’s `optimvar` function to define two main matrices:

- **Matrix 1**: Represents the amount shiped from Farmer to economic center
- **Matrix 2**: Represents the amount shipped from Economic center to district

```matlab
% Define optimization variables
x1 = optimvar('x1', 20, 15, 'LowerBound', 0);  
x2 = optimvar('x2', 15, 25, 'LowerBound', 0);  
```

## 3. Set Constraints

The code includes constraints based on:

- **Supply Constraints**: Tomatoes transported to each economic center should be less or equal to its supply capacity

- **Demand Constraint**: Total amount of tomatoes delivered to each economic center should satisfy its demand

- **Capacity Constraint 1**: Total amount of tomatoes from cultivation areas should satisfied economic center capacity

- **Capacity Constraint 2**: Total amount of tomatoes delivered to each districts should satisfied economic center capacities

Make sure these constraints align with your data by modifying or adjusting the values in `farmer_supply` and `district_demand` as needed to accurately reflect real-world requirements.

## 4. Define and Solve the Optimization Problem

The `optimproblem` function is used to set up the optimization problem. The objective is to minimize distribution costs, which are assumed to be directly proportional to the distance between farmers, economic centers, and districts.

```matlab
%% Objective Function: Minimize the Cost (Cost = Distance)
cost =  sum(sum(farmers_to_centers .* x1)) + sum(sum(centers_to_districts' .* x2)); 

prob.Objective = cost;

% Solving the Problem
options = optimoptions('linprog', 'MaxTime', 28800);
[sol, fval, eflag, output] = solve(prob, 'Options', options);
```

## 5. Analyze Results

Once the code is executed, the `solution` variable will contain the optimized distribution flow and the minimum cost. Use this variable to examine:

- The flow from farmers to economic centers
- The flow from economic centers to district centers

This analysis can help you understand the optimal distribution of resources and the associated costs.

## Requirements

- MATLAB R2021a or later
- Optimization Toolbox for MATLAB
- `.xlsx` files for data input, formatted as described above

## Notes

- Adjust parameters, constraints, or variable bounds as needed to meet specific project requirements.
- Review and validate the loaded data to ensure it accurately reflects real-world constraints.

## License

This project is open for use and modification in non-commercial applications. Please credit the original author(s) when using or adapting this code.



