classdef IrisClassifierApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure      matlab.ui.Figure
        Slider1       matlab.ui.control.Slider
        Slider2       matlab.ui.control.Slider
        Slider3       matlab.ui.control.Slider
        Slider4       matlab.ui.control.Slider
        PredictButton matlab.ui.control.Button
        ResultLabel   matlab.ui.control.Label
        TitleLabel    matlab.ui.control.Label
    end

    methods (Access = private)

        % Button pushed function: PredictButton
        function PredictButtonPushed(app, event)
            % Load the Fisher Iris dataset
            load fisheriris.mat

            % Prepare the input data
            inputData = [app.Slider1.Value, app.Slider2.Value, ...
                         app.Slider3.Value, app.Slider4.Value];

            % Train a simple model (e.g., k-NN)
            mdl = fitcknn(meas, species, 'NumNeighbors', 3);

            % Predict the category
            predictedCategory = predict(mdl, inputData);

            % Update the result label
            app.ResultLabel.Text = ['Predicted: ' char(predictedCategory)];
        end
    end

    methods (Access = public)

        % Construct app
        function app = IrisClassifierApp
            createComponents(app)
            app.UIFigure.Visible = 'on';
        end

        % Create UI components
        function createComponents(app)

            % Main Figure
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 500 480];
            app.UIFigure.Name = 'Iris Classifier';
            app.UIFigure.Color = [0.97 0.97 0.97];

            % Title Label
            app.TitleLabel = uilabel(app.UIFigure);
            app.TitleLabel.Text = 'Iris Classifier Demo';
            app.TitleLabel.FontSize = 18;
            app.TitleLabel.FontWeight = 'bold';
            app.TitleLabel.HorizontalAlignment = 'center';
            app.TitleLabel.Position = [125 430 250 30];

            % --- Slider 1 ---
            uilabel(app.UIFigure, 'Text', 'Sepal Length', ...
                'Position', [60 380 80 22], 'HorizontalAlignment', 'right');
            app.Slider1 = uislider(app.UIFigure);
            app.Slider1.Limits = [0 8];
            app.Slider1.Position = [160 390 280 3];
            app.Slider1.Value = 3.5;

            % --- Slider 2 ---
            uilabel(app.UIFigure, 'Text', 'Sepal Width', ...
                'Position', [60 320 80 22], 'HorizontalAlignment', 'right');
            app.Slider2 = uislider(app.UIFigure);
            app.Slider2.Limits = [0 8];
            app.Slider2.Position = [160 330 280 3];
            app.Slider2.Value = 3.0;

            % --- Slider 3 ---
            uilabel(app.UIFigure, 'Text', 'Petal Length', ...
                'Position', [60 260 80 22], 'HorizontalAlignment', 'right');
            app.Slider3 = uislider(app.UIFigure);
            app.Slider3.Limits = [0 8];
            app.Slider3.Position = [160 270 280 3];
            app.Slider3.Value = 4.0;

            % --- Slider 4 ---
            uilabel(app.UIFigure, 'Text', 'Petal Width', ...
                'Position', [60 200 80 22], 'HorizontalAlignment', 'right');
            app.Slider4 = uislider(app.UIFigure);
            app.Slider4.Limits = [0 8];
            app.Slider4.Position = [160 210 280 3];
            app.Slider4.Value = 1.5;

            % --- Predict Button ---
            app.PredictButton = uibutton(app.UIFigure, 'push');
            app.PredictButton.Position = [200 140 100 35];
            app.PredictButton.Text = 'Predict';
            app.PredictButton.FontWeight = 'bold';
            app.PredictButton.ButtonPushedFcn = @(src, event) PredictButtonPushed(app, event);

            % --- Result Label ---
            app.ResultLabel = uilabel(app.UIFigure);
            app.ResultLabel.Position = [150 80 200 30];
            app.ResultLabel.Text = 'Predicted: ';
            app.ResultLabel.FontSize = 14;
            app.ResultLabel.FontWeight = 'bold';
            app.ResultLabel.HorizontalAlignment = 'center';
        end
    end
end
