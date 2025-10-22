% Example 1: Plot y = sin(x)
x = -2*pi : 0.1 : 2*pi;   % Define x values
y = sin(x);                % Compute y = sin(x)
plot(x, y, 'b', 'LineWidth', 2) % Plot the curve
xlabel('x'); ylabel('sin(x)');
title('Sine Function');
grid on;
