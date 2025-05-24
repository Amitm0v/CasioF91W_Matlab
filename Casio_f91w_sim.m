function casio_f91w_sim()
    % Create main figure
    f = figure('Name', 'Casio F91W Simulator By Amit Kumar', ...
               'Color', [0 0 0], ...
               'Position', [500 300 300 250], ...
               'NumberTitle', 'off', ...
               'Resize', 'off');

    % Clock display
    hTime = uicontrol('Style', 'text', ...
                      'FontSize', 24, ...
                      'FontWeight', 'bold', ...
                      'ForegroundColor', 'green', ...
                      'BackgroundColor', 'black', ...
                      'Position', [50 160 200 50]);

    % Date display
    hDate = uicontrol('Style', 'text', ...
                      'FontSize', 12, ...
                      'ForegroundColor', 'cyan', ...
                      'BackgroundColor', 'black', ...
                      'Position', [100 135 100 30]);

    % Stopwatch display
    hStopwatch = uicontrol('Style', 'text', ...
                           'FontSize', 18, ...
                           'ForegroundColor', 'yellow', ...
                           'BackgroundColor', 'black', ...
                           'Position', [80 100 140 30], ...
                           'String', '00:00.0');

    % Stopwatch control buttons
    uicontrol('Style', 'pushbutton', 'String', 'Start/Stop', ...
              'Position', [30 60 80 30], ...
              'Callback', @toggleStopwatch);
    uicontrol('Style', 'pushbutton', 'String', 'Reset', ...
              'Position', [120 60 60 30], ...
              'Callback', @resetStopwatch);
    uicontrol('Style', 'pushbutton', 'String', 'Light', ...
              'Position', [190 60 60 30], ...
              'Callback', @toggleBacklight);

    % Timer for clock
    clockTimer = timer('ExecutionMode', 'fixedRate', ...
                       'Period', 1, ...
                       'TimerFcn', @updateClock);
    start(clockTimer);

    % Timer for stopwatch
    swTimer = timer('ExecutionMode', 'fixedRate', ...
                    'Period', 0.1, ...
                    'TimerFcn', @updateStopwatch);
    swRunning = false;
    swTime = 0;

    % Toggle stopwatch start/stop
    function toggleStopwatch(~, ~)
        swRunning = ~swRunning;
        if swRunning
            start(swTimer);
        else
            stop(swTimer);
        end
    end
    

    % Reset stopwatch
    function resetStopwatch(~, ~)
        swTime = 0;
        set(hStopwatch, 'String', '00:00.0');
    end

    % Update stopwatch display
    function updateStopwatch(~, ~)
        swTime = swTime + 0.1;
        minutes = floor(swTime / 60);
        seconds = floor(mod(swTime, 60));
        tenths = floor(mod(swTime * 10, 10));
        swStr = sprintf('%02d:%02d.%d', minutes, seconds, tenths);
        set(hStopwatch, 'String', swStr);
    end

    % Update clock every second
    function updateClock(~, ~)
        t = datetime('now');
        timeStr = datestr(t, 'HH:MM:SS');
        dateStr = datestr(t, 'dd-mmm-yyyy');
        set(hTime, 'String', timeStr);
        set(hDate, 'String', dateStr);
    end

    % Toggle backlight
    lightOn = false;
    function toggleBacklight(~, ~)
        lightOn = ~lightOn;
        if lightOn
            f.Color = [0.2 0.5 0.6];  % Light on (blue-ish)
        else
            f.Color = [0 0 0];        % Light off (black)
        end
    end

    % Clean up timers when window is closed
    f.CloseRequestFcn = @(src, event) cleanup();

    function cleanup()
        stop(clockTimer);
        delete(clockTimer);
        if isvalid(swTimer)
            stop(swTimer);
            delete(swTimer);
        end
        delete(f);
    end
end
