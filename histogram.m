clear;
close all;
clc;

% Define the discrete distribution parameters
values = [1, 2, 3, 4, 5];
probabilities = [0.05, 0.4,0.15, 0.3, 0.1];

for N = [5, 10, 20, 50, 100, 200, 500, 1000, 5000, 10000]
    nsamp = 6000;
    X = zeros(nsamp, N);
    
    for i = 1:N
        X(:, i) = randsample(values, nsamp, true, probabilities);
    end
    
    % Calculate the sample means
    sample_means = mean(X, 2);
    
    % Plot the histogram of the sample means
    numbins = 50;
    histogram(sample_means, numbins, 'Normalization', 'probability'); 
    title(sprintf('PDF of the average of %d iid random variables', N));
    
    fname = sprintf('histogram_%d.png', N);
    saveas(gcf, fname);
    
    pause(10);
end