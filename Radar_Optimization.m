clear;
clc;
close all;

% HOW TO USE:
% 1. Put in the area for however many panels you want to test. Write there
%    respective names as well. Since the aircraft is symmetric, you only
%    need to put panels on the right side of the centerline, as the left
%    side will be mirrored.
% 2. Put the starting azimuth and elevation angle for each panel.
% 3. Set the azimuth/elevation ranges that are actually possible for the geometry.
% 4. The script goes panel by panel, finding the best azimuth, and then it
%    takes that best azimuth and uses it to find best elevation. Once its
%    at the last panel, it goes back to the start and repeats process until
%    the improvement amount goes beneath the tolerance




%USER INPUTS
%-----------------------------
panel_areas = [1 1 1]; %area of each panel in m^2, later can input CAD values

panel_names = ["Inlet Right", "Nose Right", "Tail"]; % names for each panel respective to the above areas

panel_azimuth = [20 30 40]; 
% starting azimuth angle for each panel, 0 = pointing forward, 90 =
% pointing right

panel_elevation = [10 20 30]; 
% starting elevation angle for each panel normal, positive value means the 
% panel points upward

panel_azimuth_range = 10:.5:70; 
% the azimuth angles for each panel that are tested during sweep

panel_elevation_range = 0:.5:40;
% the elevation angles for each panel that are tested during sweep

radar_azimuth = 0:0.5:360;
% radar azimuth sweeps in a circle around Wraith, 0 deg = radar in front,

radar_elevation = -30:5:0;
% radar elevation sweeps the elevation rangerelative to Wraith
% negative means the radar is below the aircraft

p = 8;
% exponent used in the calculated score
% higher values punish panels that face the radar more directly

max_passes = 20;
% maximum number of times the entire optimization will repeat

tolerance = 1e-4;
% if the worst-case does not improve by more than this, the optimization
% ends. The code is looking at worst-case score rather than average,
% because this preliminary study is to prevent the panels from being picked up by the radar.
% The average amount of visibility will be addressed later using an EM solver
% such as FEKO

previous_max_score = inf;
% starts at infinity so it will always optimize at least more than once

pass_num = 0;
% how many optimization passes have been occured




%INITIAL SWEEP
%-------------------------------
initial_panel_azimuth = panel_azimuth;
initial_panel_elevation = panel_elevation;

initial_total_scores = zeros(length(radar_azimuth), length(radar_elevation));

for h = 1:length(radar_elevation)
    % checks the starting geometry before optimization

    for j = 1:length(radar_azimuth)

        total_score = 0;

        radar_los = [-cosd(radar_elevation(h))*cosd(radar_azimuth(j)), ...
                     -cosd(radar_elevation(h))*sind(radar_azimuth(j)), ...
                     -sind(radar_elevation(h))];

        for i = 1:length(panel_areas)

            pan_direct = [cosd(initial_panel_elevation(i))*cosd(initial_panel_azimuth(i)), ...
                          cosd(initial_panel_elevation(i))*sind(initial_panel_azimuth(i)), ...
                          sind(initial_panel_elevation(i))];

            alignment = -dot(radar_los, pan_direct);
            alignment = max(0, alignment);

            score = panel_areas(i) * alignment^p;
            total_score = total_score + score;
        end

        initial_total_scores(j,h) = total_score;
    end
end

initial_avg_score = mean(initial_total_scores, 'all');
initial_max_score = max(initial_total_scores, [], 'all');

fprintf("\nInitial average calculated score: %.4f\n", initial_avg_score)
fprintf("Initial worst-case calculated score: %.4f\n", initial_max_score)




% OPTIMIZATION CONTINUATION LOOP
%------------------------------
continue_optimizing = true;

while continue_optimizing
    pass_num = pass_num + 1;
    fprintf("\nOptimization %d\n", pass_num)





% AZIMUTH OPTIMIZATION LOOP
%------------------------------
for panel_num = 1:length(panel_areas)
    % checks each panel one at a time

    avg_score_az = zeros(size(panel_azimuth_range));
    max_score_az = zeros(size(panel_azimuth_range));

    for k = 1:length(panel_azimuth_range)
        % tests each possible azimuth angle in the testing range 
        % for the current panel

        test_azimuth = panel_azimuth;
        test_elevation = panel_elevation;

        test_azimuth(panel_num) = panel_azimuth_range(k);
        % only the current panel's azimuth changes
        % the other panels stay put

        total_scores = zeros(length(radar_azimuth), length(radar_elevation));

        for h = 1:length(radar_elevation)
            % loops through the radar elevation angles

            for j = 1:length(radar_azimuth)
                % loops through the radar azimuth angles to go around
                % Wraith in a circle

                total_score = 0;
                % resets the total score for this radar direction

                radar_los = [-cosd(radar_elevation(h))*cosd(radar_azimuth(j)), ...
                             -cosd(radar_elevation(h))*sind(radar_azimuth(j)), ...
                             -sind(radar_elevation(h))];
                % direction the radar wave travels toward Wraith

                for i = 1:length(panel_areas)
                    % loops through every panel and adds each panel's score

                    pan_direct = [cosd(test_elevation(i))*cosd(test_azimuth(i)), ...
                                  cosd(test_elevation(i))*sind(test_azimuth(i)), ...
                                  sind(test_elevation(i))];
                    % direction this panel is facing

                    alignment = -dot(radar_los, pan_direct);
                    % dot product to show how much the radar and panel are 
                    % facing each other

                    alignment = max(0, alignment);
                    % if the panel is facing away, it gets counted as zero
                    % prevents negative scores which would mess up data

                    score = panel_areas(i) * alignment^p;
                    % finds score for each panel

                    total_score = total_score + score;
                    % takes the score for the panel and adds it to the
                    % combined configuration score
                end

                total_scores(j,h) = total_score;
                % stores the total score for this radar azimuth and elevation pair
            end
        end

        avg_score_az(k) = mean(total_scores, 'all');
        % average calculated score for this tested azimuth angle

        max_score_az(k) = max(total_scores, [], 'all');
        % worst-case calculated score for this tested azimuth angle
    end

[~, best_az_index] = min(max_score_az);
% finds the azimuth angle with the lowest worst-case score
panel_azimuth(panel_num) = panel_azimuth_range(best_az_index);
% sets the current panel to be its best azimuth angle

    


 % ELEVATION OPTIMIZATION LOOP
 %-------------------------------
 % does the same exact things as the azmiuth loop, but now for elevation
 avg_score_el = zeros(size(panel_elevation_range));
 max_score_el = zeros(size(panel_elevation_range));

    for k = 1:length(panel_elevation_range)
        % tests each possible elevation angle for the current panel
    
        test_azimuth = panel_azimuth;
        test_elevation = panel_elevation;
    
        test_elevation(panel_num) = panel_elevation_range(k);
        % only the current panel's elevation changes
        % azmiuth is already set to be the best angle found in the previous
        % loop
    
        total_scores = zeros(length(radar_azimuth), length(radar_elevation));
    
        for h = 1:length(radar_elevation)
            % loops through the radar elevation angles
    
            for j = 1:length(radar_azimuth)
                % loops around Wraith in a circle
    
                total_score = 0;
                % resets the total score for this radar direction
    
                radar_los = [-cosd(radar_elevation(h))*cosd(radar_azimuth(j)), ...
                             -cosd(radar_elevation(h))*sind(radar_azimuth(j)), ...
                             -sind(radar_elevation(h))];
                % direction the radar wave travels toward Wraith
    
                for i = 1:length(panel_areas)
                    % loops through every panel and adds each panel's score
    
                    pan_direct = [cosd(test_elevation(i))*cosd(test_azimuth(i)), ...
                                  cosd(test_elevation(i))*sind(test_azimuth(i)), ...
                                  sind(test_elevation(i))];
                    % direction this panel is facing
    
                    alignment = -dot(radar_los, pan_direct);
                    % dot product finding how much radar and panel face
                    % each other
    
                    alignment = max(0, alignment);
                    % if the panel is facing away, it gets counted as zero
                    % prevents negative values
    
                    score = panel_areas(i) * alignment^p;
                    % calculates score for panel
    
                    total_score = total_score + score;
                    % adds panel score to total aircraft configuration
                    % score
                end
    
                total_scores(j,h) = total_score;
                % stores the total score for this radar azimuth/elevation pair
            end
        end
    
        avg_score_el(k) = mean(total_scores, 'all');
        % average calculated score for this tested elevation angle
    
        max_score_el(k) = max(total_scores, [], 'all');
        % worst-case calculated score for this tested elevation angle
    end

    [~, best_el_index] = min(max_score_el);
    % finds the elevation angle with the lowest worst-case score
    
    panel_elevation(panel_num) = panel_elevation_range(best_el_index);
    % sets the current panel to be the best elevation angle
    
    fprintf("Optimized %s values: azimuth = %.2f deg, elevation = %.2f deg\n", ...
    panel_names(panel_num), panel_azimuth(panel_num), panel_elevation(panel_num));
end




%SWEEPING
%-------------------------------
pass_total_scores = zeros(length(radar_azimuth), length(radar_elevation));

for h = 1:length(radar_elevation)
    % checks the current optimized geometry after this pass

    for j = 1:length(radar_azimuth)

        total_score = 0;

        radar_los = [-cosd(radar_elevation(h))*cosd(radar_azimuth(j)), ...
                     -cosd(radar_elevation(h))*sind(radar_azimuth(j)), ...
                     -sind(radar_elevation(h))];

        for i = 1:length(panel_areas)

            pan_direct = [cosd(panel_elevation(i))*cosd(panel_azimuth(i)), ...
                          cosd(panel_elevation(i))*sind(panel_azimuth(i)), ...
                          sind(panel_elevation(i))];

            alignment = -dot(radar_los, pan_direct);
            alignment = max(0, alignment);

            score = panel_areas(i) * alignment^p;
            total_score = total_score + score;
        end

        pass_total_scores(j,h) = total_score;
    end
end

current_max_score = max(pass_total_scores, [], 'all');
% worst-case score after this full optimization pass

improvement = previous_max_score - current_max_score;
% checks how much the worst-case score improved from the last pass

fprintf("Worst-case score: %.4f\n", current_max_score)
fprintf("Improvement from last pass: %.6f\n", improvement)

if improvement < tolerance || pass_num >= max_passes
    continue_optimizing = false;
else
    previous_max_score = current_max_score;
end

end




%FINAL SWEEP
%-------------------------------
fprintf("\nFinal optimized panel angles:\n")
for i = 1:length(panel_areas)
    fprintf("%s: azimuth = %.2f deg, elevation = %.2f deg\n", ...
        panel_names(i), panel_azimuth(i), panel_elevation(i));
end
final_total_scores = zeros(length(radar_azimuth), length(radar_elevation));

for h = 1:length(radar_elevation)
    % final radar elevation sweep using the optimized panel angles
    for j = 1:length(radar_azimuth)
        % final radar azimuth sweep using the optimized panel angles
        total_score = 0;

        radar_los = [-cosd(radar_elevation(h))*cosd(radar_azimuth(j)), ...
                     -cosd(radar_elevation(h))*sind(radar_azimuth(j)), ...
                     -sind(radar_elevation(h))];
        for i = 1:length(panel_areas)
            % calculates the final score using all optimized panels
            pan_direct = [cosd(panel_elevation(i))*cosd(panel_azimuth(i)), ...
                          cosd(panel_elevation(i))*sind(panel_azimuth(i)), ...
                          sind(panel_elevation(i))];

            alignment = -dot(radar_los, pan_direct);
            alignment = max(0, alignment);
            score = panel_areas(i) * alignment^p;
            total_score = total_score + score;
        end
        final_total_scores(j,h) = total_score;
    end
end

final_avg_score = mean(final_total_scores, 'all');
final_max_score = max(final_total_scores, [], 'all');




% RESULTS
%---------------------------------
fprintf("\nFinal average calculated score: %.4f\n", final_avg_score)
fprintf("Final worst-case calculated score: %.4f\n", final_max_score)

avg_improvement = initial_avg_score - final_avg_score;
max_improvement = initial_max_score - final_max_score;

fprintf("\nAverage score improvement: %.4f\n", avg_improvement)
fprintf("Worst-case score improvement: %.4f\n", max_improvement)




%PLOTTING
%---------------------------------
abs_radar_elevation = abs(radar_elevation);
% removes the negative sign from the legend since ground radar is below Wraith

figure
plot(radar_azimuth, initial_total_scores(:,end), '--', 'LineWidth', 1.5)
hold on
plot(radar_azimuth, final_total_scores(:,end), 'LineWidth', 1.5)
hold off

legend('Initial Geometry', 'Optimized Geometry', 'Location', 'best')
xlabel('Radar Azimuth Angle, deg')
ylabel('Total Score')
title('Initial vs Optimized Geometry Return Score at 0 deg Radar Elevation')
xlim([0 360])
grid on

figure
plot(radar_azimuth, final_total_scores)
legend(string(abs_radar_elevation) + " deg elevation", 'Location', 'best')
xlabel('Radar Azimuth Angle, deg')
ylabel('Total Score')
title('Final Optimized Geometry Return Score')
xlim([0 360])
grid on