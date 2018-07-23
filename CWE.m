classdef CWE < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure       matlab.ui.Figure
        ControlsPanel  matlab.ui.container.Panel
        scrollPane     matlab.ui.container.Panel
    end


    properties (Access = private)
        ControlHandles
        NCONTROLS = 10
        COLORMAP = parula(2^8)
        CONTROLDIMS = [360,190] % w,h
        CONTROL_INTERNAL_PADDING = [15,15] % botoom, left
        WEBWINDOW
    end

    methods (Access = private)
    
        function h = getViewHeight(app)
            % need to modify scrollPane height to make sure it doesnt block the title
            h = app.ControlsPanel.Position(4)-40;
        end
        
        
        %a callback for the knobs
        function knobChangingFcn(app,event)
            changingValue = event.Value;
            index = event.Source.UserData;
            app.ControlHandles(index,4).Value = changingValue;
            %map to color
            colorValue = fix(changingValue/100 * 2^8);
            if ~colorValue
                lampColor = [0,0,0];
            else
                lampColor = app.COLORMAP(colorValue,:);
            end
            app.ControlHandles(index,3).Color = lampColor;
        end
        
    end


    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            %% Inject CSS in head
            app.WEBWINDOW = mlapptools.getWebWindow(app.UIFigure);
            cssText = [...
                '''<style>\n', ...
                '    /* Stars modified from: http://lea.verou.me/css3patterns/#carbon-fibre */\n', ...
                '  .scrollpane {\n', ...
                '    background:\n',...
                '    radial-gradient(black 15%, transparent 16%) 0 0,\n',...
                '    radial-gradient(black 15%, transparent 16%) 8px 8px,\n',...
                '    radial-gradient(rgba(255,255,255,.1) 15%, transparent 20%) 0 1px,\n',...
                '    radial-gradient(rgba(255,255,255,.1) 15%, transparent 20%) 8px 9px;\n',...
                '    background-color:#484858 !important;\n',...
                '    background-size:16px 16px !important;\n',...
                '  }\n', ...
                '  .controlbox {\n', ...
                '    border-radius: 15px 5px 5px 15px !important;\n', ...
                '    background:\n',...
                '    radial-gradient(circle farthest-side at 0% 50%,rgba(17,119,187,0.3) 23.5%,rgba(240,166,17,0) 0)21px 30px,\n',...
                '    radial-gradient(circle farthest-side at 0% 50%,rgba(19,65,52,0.5) 24%,rgba(240,166,17,0) 0)19px 30px,\n',...
                '    linear-gradient(rgba(17,119,187,0.3) 14%,rgba(240,166,17,0) 0, rgba(240,166,17,0) 85%,rgba(17,119,187,0.3) 0)0 0,\n',...
                '    linear-gradient(150deg,rgba(17,119,187,0.3) 24%,rgba(19,65,52,0.5) 0,rgba(19,65,52,0.5) 26%,rgba(240,166,17,0) 0,rgba(240,166,17,0) 74%,rgba(19,65,52,0.5) 0,rgba(19,65,52,0.5) 76%,rgba(17,119,187,0.3) 0)0 0,\n',...
                '    linear-gradient(30deg,rgba(17,119,187,0.3) 24%,rgba(19,65,52,0.5) 0,rgba(19,65,52,0.5) 26%,rgba(240,166,17,0) 0,rgba(240,166,17,0) 74%,rgba(19,65,52,0.5) 0,rgba(19,65,52,0.5) 76%,rgba(17,119,187,0.3) 0)0 0,\n',...
                '    linear-gradient(90deg,rgba(19,65,52,0.5) 2%,rgba(17,119,187,0.3) 0,rgba(17,119,187,0.3) 98%,rgba(19,65,52,0.5) 0%)0 0 rgba(17,119,187,0.3) !important;\n',...
                '    background-size:40px 60px !important;\n',...
                '  }\n', ...
                '  .controlbox::after {\n',...
                '    opacity: 0.5 !important;\n', ...
                '  }\n',...
                '</style>\n''' ...
                ];
            app.WEBWINDOW.executeJS(['document.head.innerHTML += ', cssText]);
            
            %% Build Controls from top to bottom and set inline styles
            totalHeight = app.NCONTROLS * app.CONTROLDIMS(2) + 40; %pad top/bottom 20/20
            % set scrollPanel height
            app.scrollPane.Position(4) = totalHeight;
            
            % add .scrollpane class to scrollPane div
            [~,scrollID] = mlapptools.getWebElements(app.scrollPane);
            scrollClassString = sprintf(...
              'dojo.addClass(dojo.query("[%s = ''%s'']")[0], "%s")',...
              scrollID.ID_attr, scrollID.ID_val, 'scrollpane');
            app.WEBWINDOW.executeJS(scrollClassString);
            
            % locate bottom left pixel for first control element
            startY = totalHeight - 20 - app.CONTROLDIMS(2);
            
            %% Loop and create controls
            % Control Handle index map
            % 1= panel
            % 2= knob
            % 3= lamp
            % 4= edit
            % 5= knobLabel
            app.ControlHandles = gobjects(app.NCONTROLS,5);
            
            for i = 1:app.NCONTROLS
                currentY = startY - (i-1) * app.CONTROLDIMS(2);
                % Create panel
                app.ControlHandles(i,1) = uipanel(app.scrollPane);
                app.ControlHandles(i,1).AutoResizeChildren = 'off';
                app.ControlHandles(i,1).Position = [15 currentY+15 320 160];
                app.ControlHandles(i,1).BorderType = 'none';
                
                % Create Knob
                app.ControlHandles(i,2) = uiknob(app.ControlHandles(i,1), 'continuous');
                app.ControlHandles(i,2).UserData = i; % add index for tracking callbacks
                app.ControlHandles(i,2).FontWeight = 'bold';
                app.ControlHandles(i,2).FontColor = [1 1 1];
                app.ControlHandles(i,2).Position = [58 53 73 73];
                app.ControlHandles(i,2).ValueChangingFcn = @(s,e)app.knobChangingFcn(e);
                
                % Create Lamp
                app.ControlHandles(i,3) = uilamp(app.ControlHandles(i,1));
                app.ControlHandles(i,3).Position = [156 23 25 25];
                app.ControlHandles(i,3).Color = [0 0 0];
                
                % Create EditField
                app.ControlHandles(i,4) = uieditfield(app.ControlHandles(i,1), 'numeric');
                app.ControlHandles(i,4).Limits = [0 100];
                app.ControlHandles(i,4).ValueDisplayFormat = '%.3f';
                app.ControlHandles(i,4).Editable = 'off';
                app.ControlHandles(i,4).FontSize = 28;
                app.ControlHandles(i,4).FontWeight = 'bold';
                app.ControlHandles(i,4).FontColor = [0.9294 0.6902 0.1294];
                app.ControlHandles(i,4).BackgroundColor = [0 0.2 0.4392];
                app.ControlHandles(i,4).Position = [178 74 120 34];
                
                % Create KnobLabel
                app.ControlHandles(i,5) = uilabel(app.ControlHandles(i,1));
                app.ControlHandles(i,5).HorizontalAlignment = 'center';
                app.ControlHandles(i,5).FontWeight = 'bold';
                app.ControlHandles(i,5).FontColor = [1 1 1];
                app.ControlHandles(i,5).Position = [52 12 51 22];
                app.ControlHandles(i,5).Text = sprintf('Knob #%d', i);
                
                % MAKE SURE MLAPPTOOLS IS ON THE MATLAB PATH!
                [~,panelID] = mlapptools.getWebElements(app.ControlHandles(i,1));
                setClassString = sprintf(...
                  'dojo.addClass(dojo.query("[%s = ''%s'']")[0], "%s")',...
                  panelID.ID_attr, panelID.ID_val, 'controlbox');
                
                % add class to DOM element
                app.WEBWINDOW.executeJS(setClassString);
            end
            % set the HTML to activate the scrollbar
            mlapptools.setStyle(app.scrollPane, 'overflow-y', 'scroll');
            mlapptools.setStyle(app.scrollPane, 'height', sprintf('%dpx',app.getViewHeight()));
            mlapptools.setStyle(app.scrollPane, 'width', '360px');
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 800 600];
            app.UIFigure.Name = 'UI Figure';
            app.UIFigure.Resize = 'off';

            % Create ControlsPanel
            app.ControlsPanel = uipanel(app.UIFigure);
            app.ControlsPanel.AutoResizeChildren = 'off';
            app.ControlsPanel.TitlePosition = 'righttop';
            app.ControlsPanel.Title = 'Controls';
            app.ControlsPanel.BackgroundColor = [1 1 1];
            app.ControlsPanel.FontSize = 26;
            app.ControlsPanel.Position = [431 11 360 580];

            % Create scrollPane
            app.scrollPane = uipanel(app.ControlsPanel);
            app.scrollPane.AutoResizeChildren = 'off';
            app.scrollPane.BorderType = 'none';
            app.scrollPane.Position = [1 1 360 540];
        end
    end

    methods (Access = public)

        % Construct app
        function app = CWE

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end