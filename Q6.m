clear
clc

image1_path = 'T1.jpg';
image2_path = 'T2.jpg';

image1_info = imfinfo(image1_path);
image2_info = imfinfo(image2_path);

im1 = double(imread(image1_path));
im2 = double(imread(image2_path));

shift_range = -10:10;

num_shifts = length(shift_range);
correlation_coefficients = zeros(1, num_shifts);
qmi_values = zeros(1, num_shifts);

correlation_coefficients_negative = zeros(1, num_shifts);
qmi_values_negative = zeros(1, num_shifts);

bin_width = 10;

for i = 1:num_shifts
    % Shift the second image along the X direction
    tx = shift_range(i);
    shifted_im2 = imtranslate(im2, [tx, 0]);
    
    % Calculate the joint histogram
    joint_hist = zeros(round(256 / bin_width), round(256 / bin_width));
    for x = 1:image1_info.Height
        for y = 1:image1_info.Width
            i1 = floor(im1(x, y) / bin_width) + 1;
            i2 = floor(shifted_im2(x, y) / bin_width) + 1;
            joint_hist(i1, i2) = joint_hist(i1, i2) + 1;
        end
    end
    
    % Normalize the joint histogram
    joint_hist = joint_hist / sum(joint_hist(:));
    
    % Calculate the marginal histograms
    marginal_hist1 = sum(joint_hist, 2);
    marginal_hist2 = sum(joint_hist, 1);
    
    % Calculate the correlation coefficient
    covar = sum(sum((im1 - mean(im1(:))) .* (shifted_im2 - mean(shifted_im2(:)))));
    std1 = sqrt(sum(sum((im1 - mean(im1(:))).^2)));
    std2 = sqrt(sum(sum((shifted_im2 - mean(shifted_im2(:))).^2)));
    correlation_coefficients(i) = covar / (std1 * std2);
    
    % Calculate the QMI
    qmi = 0;
    for i1 = 1:size(joint_hist, 1)
        for i2 = 1:size(joint_hist, 2)
            pI1I2 = joint_hist(i1, i2);
            pI1 = marginal_hist1(i1);
            pI2 = marginal_hist2(i2);
            qmi = qmi + (pI1I2 - pI1 * pI2)^2;
        end
    end
    qmi_values(i) = qmi;
    
    % Calculate the correlation coefficient for negative image
    negative_im2 = 255 - im1;
    shifted_negative_im2 = imtranslate(negative_im2, [tx, 0]);
    
    % Calculate the joint histogram for negative image
    joint_hist_negative = zeros(round(256 / bin_width), round(256 / bin_width));
    for x = 1:image1_info.Height
        for y = 1:image1_info.Width
            i1 = floor(im1(x, y) / bin_width) + 1;
            i2 = floor(shifted_negative_im2(x, y) / bin_width) + 1;
            joint_hist_negative(i1, i2) = joint_hist_negative(i1, i2) + 1;
        end
    end
    
    % Normalize the joint histogram for negative image
    joint_hist_negative = joint_hist_negative / sum(joint_hist_negative(:));
    
    marginal_hist1 = sum(joint_hist_negative, 2);
    marginal_hist2 = sum(joint_hist_negative, 1);

    % Calculate the correlation coefficient for negative image
    covar_negative = sum(sum((im1 - mean(im1(:))) .* (shifted_negative_im2 - mean(shifted_negative_im2(:)))));
    std1_negative = sqrt(sum(sum((im1 - mean(im1(:))).^2)));
    std2_negative = sqrt(sum(sum((shifted_negative_im2 - mean(shifted_negative_im2(:))).^2)));
    correlation_coefficients_negative(i) = covar_negative / (std1_negative * std2_negative);
    
    % Calculate the QMI for negative image
    qmi_negative = 0;
    for i1 = 1:size(joint_hist_negative, 1)
        for i2 = 1:size(joint_hist_negative, 2)
            pI1I2 = joint_hist_negative(i1, i2);
            pI1 = marginal_hist1(i1);
            pI2 = marginal_hist2(i2);
            qmi_negative = qmi_negative + (pI1I2 - pI1 * pI2)^2;
        end
    end
    qmi_values_negative(i) = qmi_negative;
end

% Plot correlation coefficients versus tx for the original image
figure;
plot(shift_range, correlation_coefficients, '-o');
xlabel('tx (pixels)');
ylabel('Correlation Coefficient (\rho)');
title('Correlation Coefficient vs. Shift (Original Image)');

% Plot QMI values versus tx for the original image
figure;
plot(shift_range, qmi_values, '-o');
xlabel('tx (pixels)');
ylabel('Quadratic Mutual Information (QMI)');
title('QMI vs. Shift (Original Image)');

% Plot correlation coefficients versus tx for the negative image
figure;
plot(shift_range, correlation_coefficients_negative, '-o');
xlabel('tx (pixels)');
ylabel('Correlation Coefficient (\rho)');
title('Correlation Coefficient vs. Shift (Negative Image)');

% Plot QMI values versus tx for the negative image
figure;
plot(shift_range, qmi_values_negative, '-o');
xlabel('tx (pixels)');
ylabel('Quadratic Mutual Information (QMI)');
title('QMI vs. Shift (Negative Image)');