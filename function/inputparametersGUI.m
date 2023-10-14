function answers = inputparametersGUI()
    % Set default parameter values
    defaultNoiseType = 'white';
    defaultAdaptationStep = 0.1;
    defaultFilterLength = 2048;

    % Create a new figure window
    fig = figure('Name', 'System Parameters Input GUI', 'Position', [400, 400, 300, 250]);

    % Change the background color of the figure
    set(fig, 'Color', [0.94, 0.94, 0.94]);

    % Add explanatory text
    explanationText = uicontrol(fig, 'Style', 'text', 'String', 'Please enter the following parameters:', 'Position', [30, 220, 240, 20]);

    % Create a drop-down menu for the first parameter (noise type)
    param1Label = uicontrol(fig, 'Style', 'text', 'String', 'Noise Type:', 'Position', [50, 180, 100, 20]);
    param1DropDown = uicontrol(fig, 'Style', 'popupmenu', 'String', {'white', 'pink', 'brown', 'city'}, 'Position', [150, 180, 100, 20], 'Value', 1);

    % Create two text labels for the remaining parameters
    label2 = uicontrol(fig, 'Style', 'text', 'String', 'Adaptation Step (mu):', 'Position', [50, 150, 150, 20]);
    label3 = uicontrol(fig, 'Style', 'text', 'String', 'Filter Length (L):', 'Position', [50, 120, 120, 20]);

    % Create two edit boxes for the remaining parameters
    editBox2 = uicontrol(fig, 'Style', 'edit', 'Position', [180, 150, 70, 20], 'String', num2str(defaultAdaptationStep));
    editBox3 = uicontrol(fig, 'Style', 'edit', 'Position', [180, 120, 70, 20], 'String', num2str(defaultFilterLength));

    % Create a button to submit the parameters
    submitButton = uicontrol(fig, 'Style', 'pushbutton', 'String', 'Submit', 'Position', [100, 20, 100, 30]);
    set(submitButton, 'Callback', @onSubmit);

    % Initialize answers struct with default values
    answers = struct('noiseType', defaultNoiseType, 'adaptationStep', defaultAdaptationStep, 'filterLength', defaultFilterLength);

    function onSubmit(~, ~)
        % Callback function when the submit button is clicked
        param1Options = {'white', 'pink', 'brown', 'city'};
        param1Idx = get(param1DropDown, 'Value');
        answers.noiseType = param1Options{param1Idx};

        % Get the second and third parameters as strings
        param2Str = get(editBox2, 'String');
        param3Str = get(editBox3, 'String');

        try
            % Convert the second parameter to a double
            answers.adaptationStep = str2double(param2Str);

            % Check if the conversion was successful
            if isnan(answers.adaptationStep)
                error('Adaptation Step (mu) must be a numeric value.');
            end

            % Convert the third parameter to an integer
            answers.filterLength = round(str2double(param3Str));

            % Check if the conversion was successful
            if isnan(answers.filterLength) || answers.filterLength ~= fix(answers.filterLength)
                error('Filter Length (L) must be an integer.');
            end
        catch
            % If an error occurs, display an error message
            errordlg('Invalid input. Please enter valid parameter values.', 'Input Error');
            return;
        end

        % Close the GUI after successful input
        close(fig);
    end

    % Wait for the GUI to close
    waitfor(fig);
end
