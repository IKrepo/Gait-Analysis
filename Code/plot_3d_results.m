function [] = plot_3d_results (data, id, n_time_points, output_dir_plots)
    
    %part = [1 2 3]; % part:  foot = 1; shank = 2; thigh = 3;
    
    for pat = 1 : length(data(:, 1))   % Patients = 1
        % I plotted only the first trial due to runtime efficieny purposes.
        for cur = 1 %: trial(1, pat)   % Walking trials = [2]
            for time = 1:n_time_points % Loop over all time points.
                % 3D Scatter Plot of the proximal force acting on foot
                % (red), shank (green) and thigh (blue)
                % The results of every patient are ploted together.
                % Total number of plots = 1
                figure(10)
                subplot(1, 1, pat)
                scatter3(id{pat, cur}(time, 1).F_prox(1),...
                        id{pat, cur}(time, 1).F_prox(2),...
                        id{pat, cur}(time, 1).F_prox(3),...
                        70, '.r')
                hold on
                scatter3(id{pat, cur}(time, 2).F_prox(1),...
                        id{pat, cur}(time, 2).F_prox(2),...
                        id{pat, cur}(time, 2).F_prox(3),...
                        70, '.g')
                scatter3(id{pat, cur}(time, 3).F_prox(1),...
                        id{pat, cur}(time, 3).F_prox(2),...
                        id{pat, cur}(time, 3).F_prox(3),...
                        70, '.b')
            end
        end
        title(['Patient ' num2str(pat) ' Proximal Forces'])
    end
    legend({'Ankle Joint' 'Knee Joint' 'Hip Joint'})
    xlabel('x-component')
    ylabel('y-component')
    zlabel('z-component')
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, .99, .88])
    hold off
    
    
    for pat = 1 : length(data(:, 1))   % Patients = 1
        % I plotted only the first trial due to runtime efficieny purposes.
        for cur = 1 %%: trial(1, pat)  % Walking trials = [2]
            for time = 1:n_time_points % Loop over all time points.
                % 3D Scatter Plot of the proximal moment acting on foot
                % (red), shank (green) and thigh (blue)
                % The results of every patient are ploted together.
                % Total number of plots = 1
                figure(11)
                subplot(1, 1, pat)
                scatter3(id{pat, cur}(time, 1).M_prox(1),...
                        id{pat, cur}(time, 1).M_prox(2),...
                        id{pat, cur}(time, 1).M_prox(3),...
                        70, '.r')
                hold on
                scatter3(id{pat, cur}(time, 2).M_prox(1),...
                        id{pat, cur}(time, 2).M_prox(2),...
                        id{pat, cur}(time, 2).M_prox(3),...
                        70, '.g')
                scatter3(id{pat, cur}(time, 3).M_prox(1),...
                        id{pat, cur}(time, 3).M_prox(2),...
                        id{pat, cur}(time, 3).M_prox(3),...
                        70, '.b')
            end
        end
        title(['Patient ' num2str(pat) ' Proximal Moments'])
    end
    legend({'Ankle Joint' 'Knee Joint' 'Hip Joint'})
    xlabel('x-component')
    ylabel('y-component')
    zlabel('z-component')
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, .99, .88])
    hold off
    
    for i = 10 : 11
        saveas(figure(i), [output_dir_plots 'Figure_' num2str(i) '.png']);
    end    
end