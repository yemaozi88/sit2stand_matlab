load('E:\McRoberts\OneDrive\Projects\Sit2Stand\mat\old\errorFeatures.mat');

load('E:\McRoberts\OneDrive\Projects\Sit2Stand\mat\X.mat');
load('E:\McRoberts\OneDrive\Projects\Sit2Stand\mat\y.mat');

x1 = errorFeatures;
clear errorFeatures
x2 = [y(:, 1:2), y(:, 4), y(:, 3), X];


requestID = 17852;
trialNum  = 3;
x1_ = x1(find(x1(:, 1) == requestID & x1(:, 2) == trialNum), :);
x2_ = x2(find(x2(:, 1) == requestID & x2(:, 2) == trialNum), :);
isequal(x1_, x2_)