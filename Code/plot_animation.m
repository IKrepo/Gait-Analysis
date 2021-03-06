function [] = plot_animation(data, T, external_loads, force_LCS,...
                                                      moment_LCS, Mr_Euler)

for pat = 1 %: length(data(:, 1))       % Patients = 1
    for cur_trial = 1 %: trial(1, pat)  % Walking trials
        figure(14)     % Working only on the 1st walking trial of patient 1
                       % for long runtime problems.
        subplot(2,1,1) % Plot the x, y, z forces at everey joint.
        title(['Patient ' num2str(pat) ' Walking - Reaction Forces'])
        hold on
        xlabel('time (s)')
        ylabel('Force Reaction Componetns (%BW)')
        p1 = plot(data{pat, cur_trial}(1,1),...
            data{pat, cur_trial}(1,3), '.r', 'MarkerSize', 10);
        xlim([0 1.2])
        ylim([-120 120])
        p2 = plot(data{pat, cur_trial}(1,1), data{pat, cur_trial}(1,4), '+r');
        p3 = plot(data{pat, cur_trial}(1,1), data{pat, cur_trial}(1,5), 'or');
        % Plot Reaction Forces at Ankle joint at x, y, z.
        p4 = plot(data{pat, cur_trial}(1,1),...
            force_LCS{pat, cur_trial}(1).ankle(1), '.g', 'MarkerSize', 10);
        p5 = plot(data{pat, cur_trial}(1,1),...
            force_LCS{pat, cur_trial}(1).ankle(2), '+g');
        p6 = plot(data{pat, cur_trial}(1,1),...
            force_LCS{pat, cur_trial}(1).ankle(3), 'og');
        % Plot Reaction Forces at Knee joint at x, y, z.
        p7 = plot(data{pat, cur_trial}(1,1),...
            force_LCS{pat, cur_trial}(1).knee(1),...
            '.b', 'MarkerSize', 10);
        p8 = plot(data{pat, cur_trial}(1,1),...
            force_LCS{pat, cur_trial}(1).knee(2), '+b');
        p9 = plot(data{pat, cur_trial}(1,1),...
            force_LCS{pat, cur_trial}(1).knee(3), 'ob');
        % Plot Reaction Forces at Hip joint at x, y, z.
        p10 = plot(data{pat, cur_trial}(1,1),...
            force_LCS{pat, cur_trial}(1).hip(1),...
            '.k', 'MarkerSize', 10);
        p11 = plot(data{pat, cur_trial}(1,1),...
            force_LCS{pat, cur_trial}(1).hip(2), '+k');
        p12 = plot(data{pat, cur_trial}(1,1),...
            force_LCS{pat, cur_trial}(1).hip(3), 'ok');
        set(gcf, 'Units', 'normalized', 'Position', [0, 0, .99, .88]);
        for i = 1 : length(data{1, 1}) % Time discretizations = 201
            
            subplot(2,1,1) 
            % Plot Ground Reaction Forces at x, y, z.
            plot(data{pat, cur_trial}(i,1),...
                data{pat, cur_trial}(i,3), '.r', 'MarkerSize', 10)
            hold on
            xlim([0 1.2])
            ylim([-120 120])
            plot(data{pat, cur_trial}(i,1), data{pat, cur_trial}(i,4), '+r')
            plot(data{pat, cur_trial}(i,1), data{pat, cur_trial}(i,5), 'or')
            % Plot Reaction Forces at Ankle joint at x, y, z.
            plot(data{pat, cur_trial}(i,1),...
                force_LCS{pat, cur_trial}(i).ankle(1),...
                '.g', 'MarkerSize', 10)
            plot(data{pat, cur_trial}(i,1),...
                force_LCS{pat, cur_trial}(i).ankle(2), '+g')
            plot(data{pat, cur_trial}(i,1),...
                force_LCS{pat, cur_trial}(i).ankle(3), 'og')
            % Plot Reaction Forces at Knee joint at x, y, z.
            plot(data{pat, cur_trial}(i,1),...
                force_LCS{pat, cur_trial}(i).knee(1),...
                '.b', 'MarkerSize', 10)
            plot(data{pat, cur_trial}(i,1),...
                force_LCS{pat, cur_trial}(i).knee(2), '+b')
            plot(data{pat, cur_trial}(i,1),...
                force_LCS{pat, cur_trial}(i).knee(3), 'ob')
            % Plot Reaction Forces at Hip joint at x, y, z.
            plot(data{pat, cur_trial}(i,1),...
                force_LCS{pat, cur_trial}(i).hip(1),...
                '.k', 'MarkerSize', 10)
            plot(data{pat, cur_trial}(i,1),...
                force_LCS{pat, cur_trial}(i).hip(2), '+k')
            plot(data{pat, cur_trial}(i,1),...
                force_LCS{pat, cur_trial}(i).hip(3), 'ok')
            
            % At this animation I work on the sagittal plane.
            subplot(2,1,2) % Plot the vector of the forces at each joint.
            quiver(T{pat, cur_trial}(i, 1).LCS.origin(1),...
                T{pat, cur_trial}(i, 1).LCS.origin(3),...
                force_LCS{pat, cur_trial}(i).ankle(1) /...
                norm(force_LCS{pat, cur_trial}(i).ankle),...
                force_LCS{pat, cur_trial}(i).ankle(3) /...
                norm(force_LCS{pat, cur_trial}(i).ankle), 'g')
            hold on
            xlim([-1.0 2.0])
            ylim([-1.0 2.0])
            quiver(T{pat, cur_trial}(i, 2).LCS.origin(1),...
                T{pat, cur_trial}(i, 2).LCS.origin(3),...
                force_LCS{pat, cur_trial}(i).knee(1) /...
                norm(force_LCS{pat, cur_trial}(i).knee),...
                force_LCS{pat, cur_trial}(i).knee(3) /...
                norm(force_LCS{pat, cur_trial}(i).knee), 'b')
            quiver(T{pat, cur_trial}(i, 3).LCS.origin(1),...
                T{pat, cur_trial}(i, 3).LCS.origin(3),...
                force_LCS{pat, cur_trial}(i).hip(1) /...
                norm(force_LCS{pat, cur_trial}(i).hip),...
                force_LCS{pat, cur_trial}(i).hip(3) /...
                norm(force_LCS{pat, cur_trial}(i).hip), 'k')
            quiver(external_loads{pat, cur_trial}(i).r_GRF(1),...
                external_loads{pat, cur_trial}(i).r_GRF(3),...
                data{pat, cur_trial}(i,2) *...                             % At this point I multiply the GRF with the
                external_loads{pat, cur_trial}(i).F_GRF(1) /...            % 2nd column of the THR_patients excel file.
                norm(external_loads{pat, cur_trial}(i).F_GRF(1)),...       % when the left foot does not touch the plate,
                data{pat, cur_trial}(i,2) *...                             % the value is -1. I change the value to 0
                external_loads{pat, cur_trial}(i).F_GRF(3) /...            % only for patient 1 walking trial 1 to
                (norm(external_loads{pat, cur_trial}(i).F_GRF(3))), 'r')   % demonstrate that the vector of force becomes 0.
                                                                           % I did the same for moment animation.
            
            % Here I plot the joint cetre point at every joint.
            % This is the point where the force vector starts.
            plot(T{pat, cur_trial}(i, 1).LCS.origin(1),...
                T{pat, cur_trial}(i, 1).LCS.origin(3),...
                '.g', 'MarkerSize', 20)
            plot(T{pat, cur_trial}(i, 2).LCS.origin(1),...
                T{pat, cur_trial}(i, 2).LCS.origin(3),...
                '.b', 'MarkerSize', 20)
            plot(T{pat, cur_trial}(i, 3).LCS.origin(1),...
                T{pat, cur_trial}(i, 3).LCS.origin(3),...
                '.k', 'MarkerSize', 20)
            plot(external_loads{pat, cur_trial}(i).r_GRF(1),...
                external_loads{pat, cur_trial}(i).r_GRF(3),...
                '.r', 'MarkerSize', 20)
            hold off
            pause(0.1)
        end
        legend([p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12],...
            'GRF-X', 'GRF-Y', 'GRF-Z',...
            'X Force Ankle', 'Y Force Ankle', 'Z Force Ankle',...
            'X Force Knee', 'Y Force Knee', 'Z Force Knee',...
            'X Force Hip', 'Y Force Hip', 'Z Force Hip')
    end
end

for pat = 1 %: length(data(:, 1))       % Patients = 1
    for cur_trial = 1 %: trial(1, pat)  % Walking trials
        figure(15)
        subplot(2,2,[1,2])
        title(['Patient ' num2str(pat) ' Walking - Reaction Moments'])
        hold on
        xlabel('time (s)')
        ylabel('Moment Reaction Componetns (%BWm)')
        plot(data{pat, cur_trial}(1,1),...
            data{pat, cur_trial}(1,6), '.k', 'MarkerSize', 10)
        xlim([0 1.1])
        ylim([-10 10])
        plot(data{pat, cur_trial}(1,1),...
            moment_LCS{pat, cur_trial}(1).hip(1), '.r', 'MarkerSize', 10)
        plot(data{pat, cur_trial}(1,1),...
            moment_LCS{pat, cur_trial}(1).hip(2), '.g', 'MarkerSize', 10)
        plot(data{pat, cur_trial}(1,1),...
            moment_LCS{pat, cur_trial}(1).hip(3), '.b', 'MarkerSize', 10)
        set(gcf, 'Units', 'normalized', 'Position', [0, 0, .99, .88])
        for i = 1 : length(data{1, 1}) % Time discretizations = 201
            
            subplot(2,2,[1,2])
            plot(data{pat, cur_trial}(i,1),...
                data{pat, cur_trial}(i,6), '.k', 'MarkerSize', 10)
            hold on
            xlim([0 1.1])
            ylim([-10 10])
            plot(data{pat, cur_trial}(i,1),...
                moment_LCS{pat, cur_trial}(i).hip(1),...
                '.r', 'MarkerSize', 10)
            plot(data{pat, cur_trial}(i,1),...
                moment_LCS{pat, cur_trial}(i).hip(2),...
                '.g', 'MarkerSize', 10)
            plot(data{pat, cur_trial}(i,1),...
                moment_LCS{pat, cur_trial}(i).hip(3),...
                '.b', 'MarkerSize', 10)

            subplot(2,2,3)
            quiver(T{pat, cur_trial}(i, 1).LCS.origin(1),...
                T{pat, cur_trial}(i, 1).LCS.origin(3),...
                moment_LCS{pat, cur_trial}(i).ankle(1) /...
                norm(moment_LCS{pat, cur_trial}(i).ankle),...
                moment_LCS{pat, cur_trial}(i).ankle(3) /...
                norm(moment_LCS{pat, cur_trial}(i).ankle), 'r')
            hold on
            xlim([-0.5 1.5])
            ylim([-1.0 1.5])
            quiver(T{pat, cur_trial}(i, 2).LCS.origin(1),...
                T{pat, cur_trial}(i, 2).LCS.origin(3),...
                moment_LCS{pat, cur_trial}(i).knee(1) /...
                norm(moment_LCS{pat, cur_trial}(i).knee),...
                moment_LCS{pat, cur_trial}(i).knee(3) /...
                norm(moment_LCS{pat, cur_trial}(i).knee), 'g')
            quiver(T{pat, cur_trial}(i, 3).LCS.origin(1),...
                T{pat, cur_trial}(i, 3).LCS.origin(3),...
                moment_LCS{pat, cur_trial}(i).hip(1) /...
                norm(moment_LCS{pat, cur_trial}(i).hip),...
                moment_LCS{pat, cur_trial}(i).hip(3) /...
                norm(moment_LCS{pat, cur_trial}(i).hip), 'b')

            quiver(external_loads{pat, cur_trial}(i).r_GRF(1),...
                external_loads{pat, cur_trial}(i).r_GRF(3),...
                data{pat, cur_trial}(i,2) *...
                external_loads{pat, cur_trial}(i).M_GRF(1),...
                data{pat, cur_trial}(i,2) *...
                external_loads{pat, cur_trial}(i).M_GRF(3) /...
                norm(external_loads{pat, cur_trial}(i).M_GRF(3)), 'k')
            
            plot(T{pat, cur_trial}(i, 1).LCS.origin(1),...
                T{pat, cur_trial}(i, 1).LCS.origin(3),...
                'r:.', 'MarkerSize', 20)
            plot(T{pat, cur_trial}(i, 2).LCS.origin(1),...
                T{pat, cur_trial}(i, 2).LCS.origin(3),...
                'g:.', 'MarkerSize', 20)
            plot(T{pat, cur_trial}(i, 3).LCS.origin(1),...
                T{pat, cur_trial}(i, 3).LCS.origin(3),...
                'b:.', 'MarkerSize', 20)
            plot(external_loads{pat, cur_trial}(i).r_GRF(1),...
                external_loads{pat, cur_trial}(i).r_GRF(3),...
                'k:.', 'MarkerSize', 20)
            hold off

            subplot(2,2,4)
            quiver3(T{pat, cur_trial}(i, 1).LCS.origin(1),...
                T{pat, cur_trial}(i, 1).LCS.origin(2),...
                T{pat, cur_trial}(i, 1).LCS.origin(3),...
                moment_LCS{pat, cur_trial}(i).ankle(1) /...
                norm(moment_LCS{pat, cur_trial}(i).ankle),...
                moment_LCS{pat, cur_trial}(i).ankle(2) /...
                norm(moment_LCS{pat, cur_trial}(i).ankle),...
                moment_LCS{pat, cur_trial}(i).ankle(3) /...
                norm(moment_LCS{pat, cur_trial}(i).ankle),...
                'r', 'linewidth', 2)
            hold on
            xlim([-0.5 1.5])
            ylim([-1.0 1.0])
            zlim([-1.0 2.0])
            quiver3(T{pat, cur_trial}(i, 2).LCS.origin(1),...
                T{pat, cur_trial}(i, 2).LCS.origin(2),...
                T{pat, cur_trial}(i, 2).LCS.origin(3),...
                moment_LCS{pat, cur_trial}(i).knee(1) /...
                norm(moment_LCS{pat, cur_trial}(i).knee),...
                moment_LCS{pat, cur_trial}(i).knee(2) /...
                norm(moment_LCS{pat, cur_trial}(i).knee),...
                moment_LCS{pat, cur_trial}(i).knee(3) /...
                norm(moment_LCS{pat, cur_trial}(i).knee),...
                'g', 'linewidth', 2)
            quiver3(T{pat, cur_trial}(i, 3).LCS.origin(1),...
                T{pat, cur_trial}(i, 3).LCS.origin(2),...
                T{pat, cur_trial}(i, 3).LCS.origin(3),...
                moment_LCS{pat, cur_trial}(i).hip(1) /...
                norm(moment_LCS{pat, cur_trial}(i).hip),...
                moment_LCS{pat, cur_trial}(i).hip(2) /...
                norm(moment_LCS{pat, cur_trial}(i).hip),...
                moment_LCS{pat, cur_trial}(i).hip(3) /...
                norm(moment_LCS{pat, cur_trial}(i).hip),...
                'b', 'linewidth', 2)
            quiver3(external_loads{pat, cur_trial}(i).r_GRF(1),...
                external_loads{pat, cur_trial}(i).r_GRF(2),...
                external_loads{pat, cur_trial}(i).r_GRF(3),...
                data{pat, cur_trial}(i,2) *...
                external_loads{pat, cur_trial}(i).M_GRF(1),...
                data{pat, cur_trial}(i,2) *...
                external_loads{pat, cur_trial}(i).M_GRF(2),...
                data{pat, cur_trial}(i,2) *...
                external_loads{pat, cur_trial}(i).M_GRF(3) /...
                norm(external_loads{pat, cur_trial}(i).M_GRF(3)),...
                'k', 'linewidth', 2)
            
            plot3(T{pat, cur_trial}(i, 1).LCS.origin(1),...
                T{pat, cur_trial}(i, 1).LCS.origin(2),...
                T{pat, cur_trial}(i, 1).LCS.origin(3),...
                'r:.', 'MarkerSize', 20)
            plot3(T{pat, cur_trial}(i, 2).LCS.origin(1),...
                T{pat, cur_trial}(i, 2).LCS.origin(2),...
                T{pat, cur_trial}(i, 2).LCS.origin(3),...
                'g:.', 'MarkerSize', 20)
            plot3(T{pat, cur_trial}(i, 3).LCS.origin(1),...
                T{pat, cur_trial}(i, 3).LCS.origin(2),...
                T{pat, cur_trial}(i, 3).LCS.origin(3),...
                'b:.', 'MarkerSize', 20)
            plot3(external_loads{pat, cur_trial}(i).r_GRF(1),...
                external_loads{pat, cur_trial}(i).r_GRF(2),...
                external_loads{pat, cur_trial}(i).r_GRF(3),...
                'k:.', 'MarkerSize', 20)
            hold off
            pause(0.1)
        end
        legend({'GRM-Z' 'X Moment Hip' 'Y Moment Hip' 'Z Moment Hip'})
    end
end