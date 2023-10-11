rng(123);
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
[best_LL, best_sigma_idx] = max(LL);
best_sigma = sigmas(best_sigma_idx);

D_values = zeros(size(sigmas));
true_mean = 0;
true_stddev = 4;
p_x = @(x) (1 / (true_stddev * sqrt(2 * pi))) * exp(-(x - true_mean).^2 / (2 * true_stddev^2));

for s = 1:length(sigmas)
    sigma = sigmas(s);
    D = 0;
    
    for j = 1:length(V)
        xi = V(j);
        D = D + (p_x(xi) - calculate_pdf(xi, T, T_size, sigma))^2;
    end
    
    D_values(s) = D;
end
[best_D, best_sigma_idx_D] = min(D_values);
best_sigma_D = sigmas(best_sigma_idx_D);

fprintf('Best sigma value based on D: %.3f\n', best_sigma_D);
fprintf('D value for the σ parameter which yielded the best LL (σ=%.3f): %.3f\n', best_sigma_D, D_values(best_sigma_idx_D));

% Plot D versus log σ
figure;
plot(log(sigmas), D_values, 'bo-');
xlabel('log(\sigma)');
ylabel('D');
title('D vs. log(\sigma)');
grid on;
x_values = -8:0.1:8;
pdf_estimate = zeros(size(x_values));
for j = 1:length(x_values)
    x = x_values(j);
    pdf_value = 0;
    for i = 1:length(T)
        Ti = T(i);
        pdf_value = pdf_value + (1 / (T_size * best_sigma_D * sqrt(2 * pi))) ...
            * exp(-(x - Ti)^2 / (2 * best_sigma_D^2));
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
function pdf = calculate_pdf(x, T, T_size, sigma)
    pdf_value = 0;
    for i = 1:length(T)
        Ti = T(i);
        pdf_value = pdf_value + (1 / (T_size * sigma * sqrt(2 * pi))) ...
            * exp(-(x - Ti)^2 / (2 * sigma^2));
    end
    pdf = pdf_value;
end