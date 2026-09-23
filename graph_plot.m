%% plot_nav_error.m
% Plots 4 charts from a nav_error_monitor CSV run:
%   1) Position error to goal      (xy_err, m)
%   2) Angle error to goal         (yaw_err_deg, deg)
%   3) Error to planned path       (path_err, m) - cross-track error vs /plan
%   4) Velocity                    (linear_vel m/s, angular_vel rad/s)
%
% Usage: edit csv_file below (or leave as is and use the file picker
% fallback), then just Run this script.

clear; clc; close all;

%% ---- Settings (edit as needed) ----------------------------------------
csv_file      = 'run001_20260923_104852_reached.csv';  % CSV to load
save_figures  = true;  % also save each chart as a PNG next to this script

%% ---- Load data ----------------------------------------------------------
if ~isfile(csv_file)
    [f, p] = uigetfile('*.csv', 'Select a nav_error_monitor run CSV');
    if isequal(f, 0)
        error('No CSV file selected.');
    end
    csv_file = fullfile(p, f);
end

opts = detectImportOptions(csv_file);
opts = setvartype(opts, 'path_err', 'double');  % blank cells -> NaN
T = readtable(csv_file, opts);

%% ---- 1) Position error to goal --------------------------------------
fig1 = figure('Name', 'Position Error to Goal');
plot(T.t, T.xy_err, 'b-', 'LineWidth', 1.4);
xlabel('Time (s)');
ylabel('Position error (m)');
title('Position Error to Goal');
grid on;

%% ---- 2) Angle error to goal -------------------------------------------
fig2 = figure('Name', 'Angle Error to Goal');
plot(T.t, T.yaw_err_deg, 'Color', [0.85 0.33 0.10], 'LineWidth', 1.4);
xlabel('Time (s)');
ylabel('Angle error (deg)');
title('Angle Error to Goal');
grid on;

%% ---- 3) Error to planned path (cross-track error vs /plan) ------------
fig3 = figure('Name', 'Error to Planned Path');
plot(T.t, T.path_err, 'Color', [0.60 0 0], 'LineWidth', 1.4);
xlabel('Time (s)');
ylabel('Cross-track error (m)');
title('Error to Planned Path');
grid on;

%% ---- 4) Velocity (linear + angular) ------------------------------------
fig4 = figure('Name', 'Velocity');

subplot(2, 1, 1);
plot(T.t, T.linear_vel, 'b-', 'LineWidth', 1.4);
xlabel('Time (s)');
ylabel('Linear velocity (m/s)');
title('Linear Velocity');
grid on;

subplot(2, 1, 2);
plot(T.t, T.angular_vel, 'Color', [0 0.5 0], 'LineWidth', 1.4);
xlabel('Time (s)');
ylabel('Angular velocity (rad/s)');
title('Angular Velocity');
grid on;

sgtitle('Velocity');

%% ---- Save PNGs (optional) ----------------------------------------------
if save_figures
    [~, base_name] = fileparts(csv_file);
    saveas(fig1, [base_name, '_position_error.png']);
    saveas(fig2, [base_name, '_angle_error.png']);
    saveas(fig3, [base_name, '_path_error.png']);
    saveas(fig4, [base_name, '_velocity.png']);
    fprintf('Saved 4 PNG files with prefix "%s_"\n', base_name);
end