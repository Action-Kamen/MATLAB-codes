clear;
close all;
clc;

% Define the discrete distribution parameters
values = [1, 2, 3, 4, 5];
probabilities = [0.05, 0.4, 0.15, 0.3, 0.1];

for N = [5, 10, 20, 50, 100, 200, 500, 1000, 5000, 10000]
    nsamp = 6000;
    X = zeros(nsamp, N);
    
    for i = 1:N
        X(:, i) = randsample(values, nsamp, true, probabilities);
    end
    
    % Calculate the sample means
    sample_means = mean(X, 2);
    
    % Compute the empirical CDF
    [ecdf_vals, ecdf_x] = ecdf(sample_means);
    
    % Calculate the mean and standard deviation of the sample means
    mu = mean(sample_means);
    sigma = std(sample_means);
    
    % Compute the Gaussian CDF
    norm_cdf = normcdf(ecdf_x, mu, sigma);
    
    % Plot the empirical CDF and Gaussian CDF
    figure;
    plot(ecdf_x, ecdf_vals, 'b');
    hold on;
    plot(ecdf_x, norm_cdf, 'r');
    title(sprintf('Empirical vs. Gaussian CDF for %d iid random variables', N));
    legend('Empirical CDF', 'Gaussian CDF');
    hold off;
    
    pause(10);
end