%% plotParavsFreq
% 
% used for api sensitivity studies
% 
% author: john braley
% create date: 13-Sep-2016 
%
% dw 11302016
% modified plotPropVsFreq.m
% allows plotting dashed lines
% includes parameter axis labels
%
function plotParaVsFreq(model,Para,unit)
	
    fh = figure('PaperPositionMode','auto');
    ah = axes;
    hold on
    steps = length(model);
    
    lins = {'--ob','--or','--ok','--om','--xb','--xr','--xk','--xm'};
  
    for jj = 1:length(model(1).solvers.freq) % loop modes
        mode = jj;
        for ii = 1:steps
            % get x value - material field value
            beam = model(ii).params.obj;
            results = model(ii).solvers;
            xx(ii,:) = beam.(model(ii).params.name);  % plot material property value on x - axis
            
            % get y value - freq
            freq = results.freq;
            yy(ii,jj) = freq(mode);
        end
    end
    
    % plot results
    for ii = 1:mode
        hold on
        plot(xx,yy(:,ii),char(lins(ii)));
    end
    
    % attach plot labels, grid, legend
    xlabel([Para.name ' (' unit ')'])
    ylabel('f (Hz)')
    % ylim([0 30])
    grid on
    hold off
    legend ('Mode 1', 'Mode 2', 'Mode 3', 'Mode 4', 'Mode 5', 'Mode 6', 'Mode 7', 'Mode 8','Location','EastOutside');
    
    % logarithmic scale condition
    if strcmp(model(1).params.scale,'log')
        set(ah,'XScale','log')
    end

end
