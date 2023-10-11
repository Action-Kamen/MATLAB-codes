clear;
n = 1000;
mu = 0;
sigma = sqrt(16);
data = normrnd(mu, sigma, n, 1);
T_size = 750;
rand_indices = randperm(n);
T_indices = rand_indices(1:T_size);
V_indices = rand_indices(T_size+1:end);
T = data(T_indices);
V = data(V_indices);
sigmas = [0.001, 0.1, 0.2, 0.9, 1, 2, 3, 5, 10, 20, 100];
LL = zeros(size(sigmas));
for s = 1:length(sigmas)
    sigma = sigmas(s);
    log_likelihood = 0;
     for j = 1:length(V)
        x = V(j);
        likelihood = 0;
         for i = 1:length(T)
                Ti = T(i);
                likelihood = likelihood + (1 / (750 * sigma * sqrt(2 * pi))) ...
                    * exp(-(x - Ti)^2 / (2 * sigma^2));
         end
         log_likelihood = log_likelihood + log(likelihood);
     end
     LL(s) = log_likelihood;
end
figure;
plot(log(sigmas), LL, '-o');
xlabel('log(\sigma)');
ylabel('Log Likelihood (LL)');
title('Log Likelihood vs. log(\sigma)');
grid on;
[best_LL, best_sigma_idx] = max(LL);
best_sigma = sigmas(best_sigma_idx);
fprintf('Best sigma value: %.3f\n', best_sigma);
fprintf('Corresponding LL value: %.3f\n', best_LL);
x_values = -8:0.1:8;

% Calculate the estimated PDF using the best sigma
pdf_estimate = zeros(size(x_values));
for j = 1:length(x_values)
    x = x_values(j);
    pdf_value = 0;
    for i = 1:length(T)
        Ti = T(i);
        pdf_value = pdf_value + (1 / (T_size * best_sigma * sqrt(2 * pi))) ...
            * exp(-(x - Ti)^2 / (2 * best_sigma^2));
    end
    pdf_estimate(j) = pdf_value;
end

% Calculate the true density (N(0, 4)) for the same x values
true_density = normpdf(x_values, 0, 4); % Mean = 0, Standard Deviation = 4

% Plot the estimated PDF and the true density
figure;
plot(x_values, pdf_estimate, 'b', 'LineWidth', 2);
hold on;
plot(x_values, true_density, 'r', 'LineWidth', 2);
xlabel('x');
ylabel('Probability Density');
title('Estimated PDF vs. True Density');
legend('Estimated PDF', 'True Density');
grid on;
hold off;