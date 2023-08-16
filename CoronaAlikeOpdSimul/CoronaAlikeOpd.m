




% powerSimulation(num_OPEs, intensity0_mW, pitches);

for num_OPEs = OPE_start : OPE_step : OPE_start + OPE_step*(OPE_span-1)
    a = a + 1;
    b = 0;
    c = 0;
%    for intensity0_dBm = 15:23
    for intensity0_mW = intensity_start : intensity_step : intensity_start+intensity_step*(intensity_span-1)
        b = b + 1;
        c = 0;
        if(~use_OPE_pitch)
            OPE_pitch_start = (waveguide_length_start - OPI_OPE_pitch) / (num_OPEs - 1);    % This accounts for the configured OPI_OPE_pitch length
            OPE_pitch_step = waveguide_length_step / (num_OPEs - 1);
%             OPE_pitch_start = waveguide_length_start / num_OPEs;
%             OPE_pitch_step = waveguide_length_step / num_OPEs;
            OPE_pitch_span = waveguide_length_span;
        end
        for OPE_pitch = OPE_pitch_start : OPE_pitch_step : OPE_pitch_start+OPE_pitch_step*(OPE_pitch_span-1)
            c = c + 1;
            pitches = [OPI_OPE_pitch OPE_pitch];
            [OPE_power_out, linearLosses(a,b,c,:)] = powerSimulation(num_OPEs, intensity0_mW, pitches);
            meanValue(a,b,c) = mean(OPE_power_out);
            overallEfficiency(a,b,c) = sum(OPE_power_out) / intensity0_mW;
            positiveError(a,b,c) = max(OPE_power_out) - meanValue(a,b,c);
            negativeError(a,b,c) = meanValue(a,b,c) - min(OPE_power_out);
        end
    end
end