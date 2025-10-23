classdef IrisClassifierApp_2 < matlab.apps.AppBase
    % IrisClassifierApp
    % Interactive Iris prediction demo using MATLAB App Designer components
    
    properties (Access = public)
        UIFigure        matlab.ui.Figure
        TitleLabel      matlab.ui.control.Label
        Slider1Label    matlab.ui.control.Label
        Slider2Label    matlab.ui.control.Label
        Slider3Label    matlab.ui.control.Label
        Slider4Label    matlab.ui.control.Label
        Slider1         matlab.ui.control.Slider
        Slider2         matlab.ui.control.Slider
        Slider3         matlab.ui.control.Slider
        Slider4         matlab.ui.control.Slider
        PredictButton   matlab.ui.control.Button
        ResultLabel     matlab.ui.control.Label
        UIAxes          matlab.ui.control.UIAxes
        ModelData       struct
    end
    
    methods (Access = private)
        
        % Update numeric label beside slider
        function updateSliderLabel(app, sliderNum)
            switch sliderNum
                case 1
                    app.Slider1Label.Text = sprintf('Sepal Length: %.1f', app.Slider1.Value);
                case 2
                    app.Slider2Label.Text = sprintf('Sepal Width: %.1f', app.Slider2.Value);
                case 3
                    app.Slider3Label.Text = sprintf('Petal Length: %.1f', app.Slider3.Value);
                case 4
                    app.Slider4Label.Text = sprintf('Petal Width: %.1f', app.Slider4.Value);
            end
        end
        
        % Predict button callback
        function PredictButtonPushed(app, ~)
            % Prepare input vector
            inputData = [app.Slider1.Value, app.Slider2.Value, ...
                         app.Slider3.Value, app.Slider4.Value];
            
            % Train kNN (k=3)
            mdl = fitcknn(app.ModelData.meas, app.ModelData.species, 'NumNeighbors', 3);
            
            % Predict species
            predictedCategory = predict(mdl, inputData);
            
            % Update label
            app.ResultLabel.Text = ['Predicted: ', char(predictedCategory)];
            
            % Update plot
            app.updatePlot(inputData, predictedCategory);
        end
        
        % Update scatter plot
        function updatePlot(app, inputData, predictedCategory)
            cla(app.UIAxes);
            
            % Extract dataset
            meas = app.ModelData.meas;
            species = app.ModelData.species;
            
            % Define petal length and width for plotting
            x = meas(:,3); % Petal Length
            y = meas(:,4); % Petal Width
            
            % Plot species
            scatter(app.UIAxes, x(strcmp(species, 'setosa')), y(strcmp(species, 'setosa')), ...
                36, 'r', 'filled'); hold(app.UIAxes, 'on');
            scatter(app.UIAxes, x(strcmp(species, 'versicolor')), y(strcmp(species, 'versicolor')), ...
                36, 'g', 'filled');
            scatter(app.UIAxes, x(strcmp(species, 'virginica')), y(strcmp(species, 'virginica')), ...
                36, 'b', 'filled');
            
            % Highlight predicted sample
            scatter(app.UIAxes, inputData(3), inputData(4), 100, 'kx', 'LineWidth', 2);
            
            % Axis and legend
            xlabel(app.UIAxes, 'Petal Length');
            ylabel(app.UIAxes, 'Petal Width');
            title(app.UIAxes, sprintf('Predicted: %s', char(predictedCategory)));
            legend(app.UIAxes, {'setosa', 'versicolor', 'virginica', 'Prediction'}, 'Location', 'best');
            grid(app.UIAxes, 'on');
            hold(app.UIAxes, 'off');
        end
        
        % Slider callbacks
        function Slider1ValueChanged(app, ~)
            app.updateSliderLabel(1);
        end
        
        function Slider2ValueChanged(app, ~)
            app.updateSliderLabel(2);
        end
        
        function Slider3ValueChanged(app, ~)
            app.updateSliderLabel(3);
        end
        
        function Slider4ValueChanged(app, ~)
            app.updateSliderLabel(4);
        end
    end
    
    methods (Access = private)
        % Create UI Components
        function createComponents(app)
            % === Create Figure ===
            app.UIFigure = uifigure('Position', [100 100 600 500], 'Name', 'Iris Classifier Demo');
            
            % === Title ===
            app.TitleLabel = uilabel(app.UIFigure, ...
                'Text', 'Iris Classifier Demo', ...
                'FontSize', 18, ...
                'FontWeight', 'bold', ...
                'HorizontalAlignment', 'center', ...
                'Position', [150 450 300 30]);
            
            % === Sliders and Labels (Left Side) ===
            sliderY = [370, 310, 250, 190];
            labels = {'Sepal Length', 'Sepal Width', 'Petal Length', 'Petal Width'};
            for i = 1:4
                app.(['Slider' num2str(i)]) = uislider(app.UIFigure, ...
                    'Position', [50 sliderY(i) 200 3], ...
                    'Limits', [0 8], ...
                    'Value', 4);
                app.(['Slider' num2str(i) 'Label']) = uilabel(app.UIFigure, ...
                    'Text', sprintf('%s: 4.0', labels{i}), ...
                    'Position', [260 sliderY(i)-10 150 22]);
            end
            
            % === Predict Button ===
            app.PredictButton = uibutton(app.UIFigure, 'push', ...
                'Text', 'Predict', ...
                'FontSize', 14, ...
                'Position', [100 120 120 40], ...
                'ButtonPushedFcn', @(src, event) PredictButtonPushed(app, event));
            
            % === Result Label ===
            app.ResultLabel = uilabel(app.UIFigure, ...
                'Text', 'Predicted: -', ...
                'FontSize', 14, ...
                'FontWeight', 'bold', ...
                'Position', [80 80 200 30]);
            
            % === Axes (Right Side) ===
            app.UIAxes = uiaxes(app.UIFigure, ...
                'Position', [350 80 230 350]);
            title(app.UIAxes, 'Petal Length vs Petal Width');
            xlabel(app.UIAxes, 'Petal Length');
            ylabel(app.UIAxes, 'Petal Width');
            grid(app.UIAxes, 'on');
            
            % === Set Callbacks ===
            app.Slider1.ValueChangedFcn = @(src, event) Slider1ValueChanged(app, event);
            app.Slider2.ValueChangedFcn = @(src, event) Slider2ValueChanged(app, event);
            app.Slider3.ValueChangedFcn = @(src, event) Slider3ValueChanged(app, event);
            app.Slider4.ValueChangedFcn = @(src, event) Slider4ValueChanged(app, event);
        end
    end
    
methods (Access = public)
    % Constructor
    function app = IrisClassifierApp_2
        % Load dataset
        load fisheriris.mat
        
        % Initialize structure properly before assigning fields
        app.ModelData = struct();
        app.ModelData.meas = meas;
        app.ModelData.species = species;
        
        % Create components
        createComponents(app);
        
        % Initial plot
        app.updatePlot([4 3 1.4 0.2], 'setosa');
    end
end

end
