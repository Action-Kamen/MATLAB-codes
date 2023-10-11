% Read the data from 'XYZ.txt'
data = dlmread('XYZ.txt');

% Extract X, Y, and Z coordinates from the data
X = data(:, 1);
Y = data(:, 2);
Z = data(:, 3);

% Calculate the required summations
n = length(X);
sum_xi_sq = sum(X.^2);
sum_xi_yi = sum(X.*Y);
sum_xi = sum(X);
sum_yi_sq = sum(Y.^2);
sum_yi = sum(Y);
sum_xi_zi = sum(X.*Z);
sum_yi_zi = sum(Y.*Z);
sum_zi = sum(Z);

% Create coefficient matrix A
A = [sum_xi_sq, sum_xi_yi, sum_xi;
     sum_xi_yi, sum_yi_sq, sum_yi;
     sum_xi, sum_yi, n];

% Create the right-hand side vector B
B = [sum_xi_zi;
     sum_yi_zi;
     sum_zi];

% Solve the linear system to find the coefficients of the plane equation
coefficients = A \ B;

% Extract coefficients for the plane equation
a = coefficients(1);
b = coefficients(2);
c = coefficients(3);

% Calculate the predicted Z values using the plane equation
predicted_Z = a * X + b * Y + c;

% Calculate the residuals
residuals = Z - predicted_Z;

% Calculate the predicted noise variance
predicted_noise_variance = sum(residuals.^2) / (n - 3);

% Display the coefficients of the plane equation
fprintf('Predicted Plane Equation: %.6fx + %.6fy + %.6fz = 0\n', a, b, c);

% Display the predicted noise variance
fprintf('Predicted Noise Variance: %.6f\n', predicted_noise_variance);