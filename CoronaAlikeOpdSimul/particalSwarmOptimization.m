% num_OPEs = 5;
function OPE_dividing_ratio = particalSwarmOptimization(num_OPEs, intensity0_mW, pitches, isNonlinearModelEnabled)
root = "D:/OneDrive - HKUST Connect/Documents/MATLAB/CoronaAlikeOpdSimul/runtime/DividingRatio_v0.0.4/";
if (isNonlinearModelEnabled)
    model = "nonlinear";
else 
    model = "linear";
end
filename = root + num_OPEs + "_" + intensity0_mW + "mW_" + pitches(1) + "cm_" + pitches(2) + "cm_" + model + ".mat";
if isfile(filename)
    load(filename,'OPE_dividing_ratio');
else 
    num_particles = 20;
%     inertia = 0.729;
%     c1 = 1.8; c2 = 1.8;
    inertia = 0.5;
    c1 = 2; c2 = 2;
    vmax = 2;
    vmin = -0.5;

    v = rand([num_particles num_OPEs-1]);
    current_state = [v ones(num_particles,1)];      % current OPE_dividing_ratio of all particals under test
%     current_state = ones(num_particles,num_OPEs) * [0.0784051538541123 0.106967211465410 0.142981102975350 0.193527347541547 0.276895065450523 0.450483841101694 1]';
    local_min = inf(1,num_particles);
    local_min_state = [zeros(num_particles,num_OPEs-1) ones(num_particles,1)];
    local_min_stash = inf(1,num_particles);
    local_min_state_stash = [zeros(num_particles,num_OPEs-1) ones(num_particles,1)];
    
    global_min = inf;
    global_min_state = [zeros(1,num_OPEs-1) 1];
    global_min_stash = inf;
    global_min_state_stash = [zeros(1,num_OPEs-1) 1];
    
%     for iter = 1: 150
    obj = inf;
    iter = 0;
%    while (global_min > 1e-3)
%     while (global_min > 1e-3)
   while (global_min > 1e-1)
        iter = iter + 1;
        if mod(iter, 13) == 0
            display("The " + iter + "th iteration gives objective variable: " + global_min);
        end
        for i = 1: num_particles
            OPE_dividing_ratio = current_state(i,:);
            OPE_power_out = powerSimulation(num_OPEs, intensity0_mW, pitches, isNonlinearModelEnabled, OPE_dividing_ratio);
            obj = max(OPE_power_out) - min(OPE_power_out);
            if (obj < local_min(i))
                local_min_stash(i) = obj;
                local_min_state_stash(i,:) = current_state(i,:);
            end
            if(obj < global_min)
                global_min_stash = obj;
                global_min_state_stash = current_state(i,:);
            end
            
            % update the next state for particle i
            r1 = rand([1 num_OPEs-1]);
            r2 = rand([1 num_OPEs-1]);
            v(i,:) = ...
                inertia*v(i,:) + ...
                c1*r1.*(local_min_state(i,1:end-1) - current_state(i,1:end-1)) + ...
                c2*r2.*(global_min_state(1:end-1) - current_state(i,1:end-1));
            for p_index = 1:length(current_state(i,:))
                if current_state(i,p_index) > 1
                    current_state(i,p_index) = 1;
                end
                if current_state(i,p_index) < 0
                    current_state(i,p_index) = 0;
                end
            end
            % Clamp the velocity
            v(v>vmax) = vmax;
            v(v<vmin) = vmin;
            current_state(i,:) = current_state(i,:) + [v(i,:) 0];
        end

%         display("output mean is: " + mean(OPE_power_out) + "mW");
        % update local\global min
        local_min = local_min_stash;
        local_min_state = local_min_state_stash;
        global_min = global_min_stash;
        global_min_state = global_min_state_stash;
   end
    OPE_dividing_ratio = global_min_state;
    % "numOfOPEs_initialPower_OPEPitch"
    save(filename,'OPE_dividing_ratio');
end
