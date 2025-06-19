function casio_ae1200wh_sim()
    % Casio AE-1200WH Advanced Simulator
    f = figure('Name', 'Casio AE-1200WH Simulator By Amit Kumar', ...
               'Color', [0 0 0], ...
               'Position', [500 300 400 320], ...
               'NumberTitle', 'off', 'Resize', 'off');

    % Clock Display
    hTime = uicontrol('Style', 'text', 'FontSize', 24, 'FontWeight', 'bold', ...
        'ForegroundColor', 'green', 'BackgroundColor', 'black', ...
        'Position', [90 230 220 40]);

    % Day and Date
    hDate = uicontrol('Style', 'text', 'FontSize', 12, ...
        'ForegroundColor', 'cyan', 'BackgroundColor', 'black', ...
        'Position', [140 205 120 20]);

    % World Map Dummy
    hMap = uicontrol('Style', 'text', 'String', '[ WORLD MAP ]', 'FontSize', 10, ...
        'ForegroundColor', 'white', 'BackgroundColor', 'black', ...
        'Position', [150 185 100 20]);

    % Stopwatch Display
    hStopwatch = uicontrol('Style', 'text', 'FontSize', 18, ...
        'ForegroundColor', 'yellow', 'BackgroundColor', 'black', ...
        'Position', [110 150 180 30], 'String', '00:00.0', 'Visible', 'off');

    % Countdown Display (advanced feature)
    hCountdown = uicontrol('Style', 'text', 'FontSize', 18, ...
        'ForegroundColor', 'magenta', 'BackgroundColor', 'black', ...
        'Position', [110 150 180 30], 'String', '01:00.0', 'Visible', 'off');

    % Buttons
    uicontrol('Style', 'pushbutton', 'String', 'Mode', 'Position', [30 80 70 30], ...
              'Callback', @switchMode);
    uicontrol('Style', 'pushbutton', 'String', 'Start/Stop', 'Position', [110 80 80 30], ...
              'Callback', @toggleAction);
    uicontrol('Style', 'pushbutton', 'String', 'Reset', 'Position', [200 80 70 30], ...
              'Callback', @resetAction);
    uicontrol('Style', 'pushbutton', 'String', 'Light', 'Position', [280 80 70 30], ...
              'Callback', @toggleBacklight);

    % Timers and States
    clockTimer = timer('ExecutionMode', 'fixedRate', 'Period', 1, 'TimerFcn', @updateClock);
    swTimer = timer('ExecutionMode', 'fixedRate', 'Period', 0.1, 'TimerFcn', @updateStopwatch);
    cdTimer = timer('ExecutionMode', 'fixedRate', 'Period', 0.1, 'TimerFcn', @updateCountdown);
    swTime = 0;
    cdTime = 60;
    swRunning = false;
    cdRunning = false;
    modes = {'Time', 'World Time', 'Stopwatch', 'Countdown'};
    modeIndex = 1;

    % Start Clock
    start(clockTimer);

    % Callback: Clock
    function updateClock(~, ~)
        t = datetime('now');
        timeStr = datestr(t, 'hh:MM:SS AM');
        dateStr = datestr(t, 'ddd dd-mmm-yyyy');
        set(hTime, 'String', timeStr);
        set(hDate, 'String', dateStr);
    end

    % Callback: Mode Switch
    function switchMode(~, ~)
        modeIndex = mod(modeIndex, length(modes)) + 1;
        current = modes{modeIndex};

        set(hStopwatch, 'Visible', 'off');
        set(hCountdown, 'Visible', 'off');

        switch current
            case 'Stopwatch'
                set(hStopwatch, 'Visible', 'on');
            case 'Countdown'
                set(hCountdown, 'Visible', 'on');
        end
        set(f, 'Name', ['Casio AE-1200WH - ' current ' Mode']);
    end

    % Callback: Start/Stop
    function toggleAction(~, ~)
        mode = modes{modeIndex};
        switch mode
            case 'Stopwatch'
                swRunning = ~swRunning;
                if swRunning
                    start(swTimer);
                else
                    stop(swTimer);
                end
            case 'Countdown'
                cdRunning = ~cdRunning;
                if cdRunning
                    start(cdTimer);
                else
                    stop(cdTimer);
                end
        end
    end

    % Callback: Stopwatch Update
    function updateStopwatch(~, ~)
        swTime = swTime + 0.1;
        m = floor(swTime / 60);
        s = floor(mod(swTime, 60));
        t = floor(mod(swTime * 10, 10));
        set(hStopwatch, 'String', sprintf('%02d:%02d.%d', m, s, t));
    end

    % Callback: Countdown Update
    function updateCountdown(~, ~)
        cdTime = cdTime - 0.1;
        if cdTime <= 0
            cdTime = 0;
            stop(cdTimer);
            cdRunning = false;
            msgbox('Time''s up!', 'Countdown Timer');
        end
        m = floor(cdTime / 60);
        s = floor(mod(cdTime, 60));
        t = floor(mod(cdTime * 10, 10));
        set(hCountdown, 'String', sprintf('%02d:%02d.%d', m, s, t));
    end

    % Callback: Reset
    function resetAction(~, ~)
        mode = modes{modeIndex};
        switch mode
            case 'Stopwatch'
                swTime = 0;
                set(hStopwatch, 'String', '00:00.0');
            case 'Countdown'
                cdTime = 60;
                set(hCountdown, 'String', '01:00.0');
        end
    end

    % Callback: Backlight
    function toggleBacklight(~, ~)
        if f.Color(1) == 0
            f.Color = [0.3 0.5 0.6];
        else
            f.Color = [0 0 0];
        end
    end

    % On close
    f.CloseRequestFcn = @(src, event) cleanup();
    function cleanup()
        stop(clockTimer);
        delete(clockTimer);
        if isvalid(swTimer), stop(swTimer); delete(swTimer); end
        if isvalid(cdTimer), stop(cdTimer); delete(cdTimer); end
        delete(f);
    end
end
