function [] = plot_2d_results (data, data_healthy, trial, force_LCS,...
                                              moment_LCS, output_dir_plots)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           !!! IMPORTANT !!!                             %
%    !!!SOS!!! Figures 4, 5, 6 and 7 make extensive use of scatter plot   %
%              and they take way too long to be computed.                 %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                2d Representation of Ground Reaction Forces              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for pat = 1 : length(data(:, 1)) % Patients = 4
        for cur = 1 : trial(1, pat)  % Walking trials = [8, 5, 8, 6]
            % Plot the 3 components of the GRFs (columns 3-5) for all the
            % patients as a function of time (1st column).
            % The results of every patient are ploted together.
            % Total number of plots = 4
            
            figure(1)
            subplot(2, 2, pat)
            plot(data{pat, cur}(:, 1), data{pat, cur}(:, 3), 'c')
            hold on
            plot(data{pat, cur}(:, 1), data{pat, cur}(:, 4), 'm')
            plot(data{pat, cur}(:, 1), data{pat, cur}(:, 5), 'k')
            title(['Patient ' num2str(pat) ' Walking'])
        end
    end
    legend({'Anterior-Posterior' 'Medio-Lateral' 'Vertical'})
    xlabel('time (s)')
    ylabel('Force Componetns of GRF (%BW)')
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, .99, .88])
    hold off
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     2d Representation of Intersegmental Resultant Force at the Hip      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for pat = 1 : length(data(:, 1)) % Patients = 4
        for cur = 1 : trial(1, pat)  % Walking trials = [8, 5, 8, 6]
            % Plot the 3 components of the Hip Contact Forces for all the
            % patients (columns 10-12) as a function of time (1st column).
            % The results of every patient are ploted together.
            % Total number of plots = 4
            figure(2)
            subplot(2, 2, pat)
            plot(data{pat, cur}(:,1), data{pat, cur}(:, 13), 'r',...
                data{pat, cur}(:,1), data{pat, cur}(:, 14), 'g',...
                data{pat, cur}(:,1), data{pat, cur}(:, 15), 'b')
            hold on
            if (cur == 1)
                for i = 1 : length(data{1, 1}) % Time discretizations = 201
                    scatter(data{pat, cur}(i, 1),...
                        force_LCS{pat, cur}(i).hip(1), 'k', '.')
                    scatter(data{pat, cur}(i, 1),...
                        force_LCS{pat, cur}(i).hip(2), 'm', '.')
                    scatter(data{pat, cur}(i, 1),...
                        force_LCS{pat, cur}(i).hip(3), 'c', '.')
                end
            end
        end
        title(['Patient ' num2str(pat)...
            ' Walking - Intersegmental Resultant Force at Hip'])
    end
    legend({'Provided Anterior-Posterior'...
            'Provided Medio-Lateral'...
            'Provided Vertical'...
            'Calculated Anterior-Posterior'...
            'Calculated Medio-Lateral'...
            'Calculated Vertical'}, 'FontSize', 10, 'Location',...
                                                    'southeast')
    xlabel('time (s)')
    ylabel('Force Componetns at Hip (%BW)')
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, .99, .88])
    hold off
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     2d Representation of Intersegmental Resultant Moment at the Hip     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for pat = 1 : length(data(:, 1)) % Patients = 4
        for cur = 1 : trial(1, pat)  % Walking trials = [8, 5, 8, 6]
            % Plot the 3 components of the Hip Contact Moments for all the
            % patients (columns 10-12) as a function of time (1st column).
            % The results of every patient are ploted together.
            % Total number of plots = 4
            figure(3)
            subplot(2, 2, pat)
            plot(data{pat, cur}(:,1), data{pat, cur}(:, 16), 'r',...
                data{pat, cur}(:,1), data{pat, cur}(:, 17), 'g',...
                data{pat, cur}(:,1), data{pat, cur}(:, 18), 'b')
            hold on
            if (cur == 1)
                for i = 1 : length(data{1, 1}) % Time discretizations = 201
                    scatter(data{pat, cur}(i, 1),...
                        moment_LCS{pat, cur}(i).hip(1), 'k', '.')
                    scatter(data{pat, cur}(i, 1),...
                        moment_LCS{pat, cur}(i).hip(2), 'm', '.')
                    scatter(data{pat, cur}(i, 1),...
                        moment_LCS{pat, cur}(i).hip(3), 'c', '.')
                end
            end
        end
        title(['Patient ' num2str(pat)...
            ' Walking - Intersegmental Resultant Moment at Hip']);
    end
    legend({'Provided Flexion-Extension'...
            'Provided Ab-Adduction'...
            'Provided Internal-External Rotation'...
            'Calculated Flexion-Extension'...
            'Calculated Ab-Adduction'...
            'Calculated Internal-External Rotation'}, 'FontSize', 10,...
                                                      'Location',...
                                                      'southeast')
    xlabel('time (s)')
    ylabel('Moment Componetns at Hip (%BWm)')
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, .99, .88])
    hold off
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     2d Representation of Intersegmental Resultant Force at the Knee     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for pat = 1 : length(data(:, 1)) % Patients = 4
        for cur = 1 : trial(1, pat)  % Walking trials = [8, 5, 8, 6]
            % Plot the 3 components of the Knee Contact Forces for all the
            % patients as a function of time (1st column).
            % The results of every patient are ploted together.
            % Total number of plots = 4
            figure(4)
            subplot(2, 2, pat)
            for i = 1 : length(data{1, 1}) % Time discretizations = 201
                scatter(data{pat, cur}(i, 1),...
                    force_LCS{pat, cur}(i).knee(1), 'k', '.')
                hold on
                scatter(data{pat, cur}(i, 1),...
                    force_LCS{pat, cur}(i).knee(2), 'm', '.')
                scatter(data{pat, cur}(i, 1),...
                    force_LCS{pat, cur}(i).knee(3), 'c', '.')
            end
        end
        title(['Patient ' num2str(pat)...
            ' Walking - Intersegmental Resultant Force at Knee'])
    end
    legend({'Calculated Anterior-Posterior'...
            'Calculated Medio-Lateral'...
            'Calculated Vertical'}, 'Location', 'southeast')
    xlabel('time (s)')
    ylabel('Force Componetns at Knee (%BW)')
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, .99, .88])
    hold off
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     2d Representation of Intersegmental Resultant Moment at the Knee    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for pat = 1 : length(data(:, 1)) % Patients = 4
        for cur = 1 : trial(1, pat)  % Walking trials = [8, 5, 8, 6]
            % Plot the 3 components of the Knee Contact Moments for all the
            % patients as a function of time (1st column).
            % The results of every patient are ploted together.
            % Total number of plots = 4
            figure(5)
            subplot(2, 2, pat)
            for i = 1 : length(data{1, 1}) % Time discretizations = 201
                scatter(data{pat, cur}(i, 1),...
                    moment_LCS{pat, cur}(i).knee(1), 'k', '.')
                hold on
                scatter(data{pat, cur}(i, 1),...
                    moment_LCS{pat, cur}(i).knee(2), 'm', '.')
                scatter(data{pat, cur}(i, 1),...
                    moment_LCS{pat, cur}(i).knee(3), 'c', '.')
            end
        end
        title(['Patient ' num2str(pat)...
            ' Walking - Intersegmental Resultant Moment at Knee'])
    end
    legend({'Calculated Flexion-Extension'...
            'Calculated Ab-Adduction'...
            'Calculated Internal-External Rotation'}, 'Location',...
                                                      'southeast')
    xlabel('time (s)')
    ylabel('Moment Componetns at Knee (%BWm)')
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, .99, .88])
    hold off
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     2d Representation of Intersegmental Resultant Force at the Ankle    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for pat = 1 : length(data(:, 1)) % Patients = 4
        for cur = 1 : trial(1, pat)  % Walking trials = [8, 5, 8, 6]
            % Plot the 3 components of the Ankle Contact Forces for all the
            % patients as a function of time (1st column).
            % The results of every patient are ploted together.
            % Total number of plots = 4
            figure(6)
            subplot(2, 2, pat)
            for i = 1 : length(data{1, 1}) % Time discretizations = 201
                scatter(data{pat, cur}(i, 1),...
                    force_LCS{pat, cur}(i).ankle(1), 'k', '.')
                hold on
                scatter(data{pat, cur}(i, 1),...
                    force_LCS{pat, cur}(i).ankle(2), 'm', '.')
                scatter(data{pat, cur}(i, 1),...
                    force_LCS{pat, cur}(i).ankle(3), 'c', '.')
            end
        end
        title(['Patient ' num2str(pat)...
            ' Walking - Intersegmental Resultant Force at Ankle'])
    end
    legend({'Calculated Anterior-Posterior'...
            'Calculated Medio-Lateral'...
            'Calculated Vertical'}, 'Location', 'southeast')
    xlabel('time (s)')
    ylabel('Force Componetns at Ankle (%BW)')
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, .99, .88])
    hold off
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     2d Representation of Intersegmental Resultant Moment at the Ankle   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for pat = 1 : length(data(:, 1)) % Patients = 4
        for cur = 1 : trial(1, pat)  % Walking trials = [8, 5, 8, 6]
            % Plot the 3 components of the Ankle Contact Moments for all
            % the patients as a function of time (1st column).
            % The results of every patient are ploted together.
            % Total number of plots = 4
            figure(7)
            subplot(2, 2, pat)
            hold on
            for i = 1 : length(data{1, 1}) % Time discretizations = 201
                scatter(data{pat, cur}(i, 1),...
                    moment_LCS{pat, cur}(i).ankle(1), 'k', '.')
                scatter(data{pat, cur}(i, 1),...
                    moment_LCS{pat, cur}(i).ankle(2), 'm', '.')
                scatter(data{pat, cur}(i, 1),...
                    moment_LCS{pat, cur}(i).ankle(3), 'c', '.')
            end
        end
        title(['Patient ' num2str(pat)...
            ' Walking - Intersegmental Resultant Moment at Ankle'])
    end
    legend({'Calculated Flexion-Extension'...
            'Calculated Ab-Adduction'...
            'Calculated Internal-External Rotation'}, 'Location',...
                                                      'southeast')
    xlabel('time (s)')
    ylabel('Moment Componetns at Ankle (%BWm)')
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, .99, .88])
    hold off
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  2d Representation of the Force Components of the Measured Hip Contact  %
%   Force, based on data collected using Telemetric Femoral Componetns    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for pat = 1 : length(data(:, 1)) % Patients = 4
        for cur = 1 : trial(1, pat)  % Walking trials = [8, 5, 8, 6]
            % Plot the 3 components of the Hip Contact Forces for all the
            % patients (columns 10-12)as a function of time (1st column).
            % The results of every patient are ploted together.
            % Total number of plots = 4
            figure(8)
            subplot(2, 2, pat)
            plot(data{pat, cur}(:,1), data{pat, cur}(:,13), 'r',...
                data{pat, cur}(:,1), data{pat, cur}(:,14), 'g',...
                data{pat, cur}(:,1), data{pat, cur}(:,15), 'b')
            hold on
            if (cur == 1)
                for i = 1 : length(data{1, 1}) % Time discretizations = 201
                    scatter(data{pat, cur}(i, 1),...
                        force_LCS{pat, cur}(i).hip(1), 'k', '.')
                    scatter(data{pat, cur}(i, 1),...
                        force_LCS{pat, cur}(i).hip(2), 'm', '.')
                    scatter(data{pat, cur}(i, 1),...
                        force_LCS{pat, cur}(i).hip(3), 'c', '.')
                end
            end
        end
        title(['Patient ' num2str(pat) ' Walking - Hip Resultant Force'])
    end
    legend({'Provided Anterior-Posterior'...
            'Provided Medio-Lateral'...
            'Provided Vertical'...
            'Calculated Anterior-Posterior'...
            'Calculated Medio-Lateral'...
            'Calculated Vertical'}, 'FontSize', 10, 'Location', 'southeast')
    xlabel('time (s)')
    ylabel('Force Componetns at Hip (%BW)')
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, .99, .88])
    hold off
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     GRF of Young Male and Momnets of the Young Male and the Patients    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for pat = 1 : length(data(:, 1)) % Patients = 4 (+ 1)
        for cur = 1 : trial(1, pat)  % Walking trials = [8, 5, 8, 6]
            % Plot the component of the External Moments for all
            % the patients as a function of time (1st column).
            % The results of every patient are ploted together.
            % Plot of the 3 components of the External Moments of the
            % Young Healthy Male and the GRF in a separate plot.
            % Total number of plots = 2
            figure(9)
            subplot(2, 1, 1)
            plot(data{pat, cur}(:, 1),...
                data{pat, cur}(:, 6), 'k')
            hold on
            if (pat == 1 && cur < 4)
                plot(data_healthy{cur}(:, 1),...
                data_healthy{cur}(:, 9), 'r')
                plot(data_healthy{cur}(:, 1),...
                data_healthy{cur}(:, 10), 'g')
                plot(data_healthy{cur}(:, 1),...
                data_healthy{cur}(:, 11), 'b')
            end
        end
    end
    title('External Moment of Patients vs Young Healthy Male')
    legend({'Patients Internal-External Rotation'...
            'Healthy Male Flexion-Extension'...
            'Healthy Male Ab-Adduction'...
            'Healthy Male Internal-External Rotation'}, 'Location',...
                                                        'southeast')
    xlabel('time (s)')
    ylabel('External Moments (%BWm)')
    
    for i = 1 : 3
        subplot(2,1,2)
        plot(data_healthy{i}(:,1),...
        data_healthy{i}(:,3), 'r')
        hold on
        plot(data_healthy{i}(:,1),...
        data_healthy{i}(:,4), 'g')
        plot(data_healthy{i}(:,1),...
        data_healthy{i}(:,5), 'b')
    end
    title('GRF of Young Healthy Male')
    legend({'Healthy Male Anterior-Posterior'...
            'Healthy Male Medio-Lateral'...
            'Healthy Male Vertical'})
    xlabel('time (s)')
    ylabel('External Forces (%BW)')
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, .99, .88])
    hold off
    
   for i = 1 : 9
    saveas(figure(i), [output_dir_plots 'Figure_' num2str(i) '.png']);
   end
end