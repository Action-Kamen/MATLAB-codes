clear;
close all;
clc;

% Define the discrete distribution parameters
values = [1, 2, 3, 4, 5];
probabilities = [0.05, 0.4, 0.15, 0.3, 0.1];

% Define x-values for calculating MAD
x_values = linspace(0, 6, 1000);  % Adjust the range and granularity as needed

% Initialize arrays to store MAD values and N values
N_values = [5, 10, 20, 50, 100, 200, 500, 1000, 5000, 10000];
mad_values = zeros(size(N_values));

for n_idx = 1:length(N_values)
    N = N_values(n_idx);
    nsamp = 6000;
    
    % Generate random variables with specified probabilities
    X = zeros(nsamp, N);
    for i = 1:N
        random_indices = randsample(length(values), nsamp, true, probabilities);
        X(:, i) = values(random_indices);
    end
    
    % Calculate the sample means
    sample_means = mean(X, 2);
    
    % Compute the empirical CDF
    [ecdf_vals, ecdf_x] = ecdf(sample_means);
    
    % Calculate the Gaussian CDF
    mu = mean(sample_means);
    sigma = std(sample_means);
    norm_cdf = normcdf(ecdf_x, mu, sigma);
    
    % Interpolate the Gaussian CDF to match the x-values of the empirical CDF
    %interpolated_norm_cdf = interp1(ecdf_x, norm_cdf, x_values);
    
    % Calculate the MAD for this N
    mad_values(n_idx) = max(abs(ecdf_vals - norm_cdf));
end

% Plot MAD as a function of N
figure;
plot(N_values, mad_values, 'o-');
xlabel('N (Number of Random Variables)');
ylabel('Maximum Absolute Difference (MAD)');
title('Maximum Absolute Difference (MAD) vs. N');
grid on;