function checkForInfinityError(variable)
    % Check if the variable contains NaN values
    if any(isnan(variable(:)))
        % Open an error dialog to inform the user about the error
        errordlg('A NaN error occurred:The algorithm cannot converge.Wait for simulation to exit', 'MATLAB Error');
    end
end