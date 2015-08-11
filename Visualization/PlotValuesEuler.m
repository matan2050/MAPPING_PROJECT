function [ figureHandle ] = PlotValuesEuler( euler, time )

% Init
figureHandle = figure;
hold on;


% Euler angles
plot(time, euler(:,1), 'r');
plot(time, euler(:,2), 'g');
plot(time, euler(:,3), 'b');
legend('Omega', 'Phi', 'Kappa');
xlabel('time [sec]');
ylabel('angle [rad]');
title('Euler Angles');
hold off;


end