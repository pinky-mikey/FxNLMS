function simulationCompletedGUI(FV,DBEX,DBD,DBE,PROCSPEECH,E,D,STRUCT,CMA)

fig = uifigure('Name', 'Simulation Completed', 'Position', [500, 300, 500, 300]);

button1 = uibutton(fig, 'Position', [40, 160, 200, 30], 'Text', 'Plot attennuation', 'FontSize', 14);
button2 = uibutton(fig, 'Position', [40, 210, 200, 30], 'Text', 'Playback audio without ANC', 'FontSize', 14);
button3 = uibutton(fig, 'Position', [260, 210, 200, 30], 'Text', 'Playback audio with ANC', 'FontSize', 14);
button4 = uibutton(fig, 'Position', [260, 160, 200, 30], 'Text', 'Mean Squared Error', 'FontSize', 14);
button5 = uibutton(fig, 'Position', [40, 110, 200, 30], 'Text', 'Error spectrogram', 'FontSize', 14);
button6 = uibutton(fig, 'Position', [260, 110, 200, 30], 'Text','Speech Intelligibility' , 'FontSize', 14);
doneButton = uibutton(fig, 'Position', [400, 30, 50, 30], 'Text', 'Done', 'FontSize', 12, 'ButtonPushedFcn', @(src, event) closereq);

addlistener(button1, 'ButtonPushed', @(src, event)  TriplePlot(FV,DBEX,DBD,DBE,STRUCT));
addlistener(button2, 'ButtonPushed', @(src, event)  soundNOANC(PROCSPEECH,D));
addlistener(button3, 'ButtonPushed', @(src, event)  soundANC(PROCSPEECH,E));
addlistener(button4, 'ButtonPushed', @(src, event)  plotcma(CMA,STRUCT));
addlistener(button5, 'ButtonPushed', @(src, event)  computespectr(E));
addlistener(button6, 'ButtonPushed', @(src, event)  computeinfo(D,E,PROCSPEECH));
addlistener(doneButton, 'ButtonPushed', @(src, event) closereq);

fig.Visible = 'on';
end

function TriplePlot(FV,DBEX,DBD,DBE,STRUCT)
semilogx(FV,-(DBD-DBE),'b','LineWidth',1.5); 
hold on
semilogx(FV,-(DBEX-DBD),'r','LineWidth',1.5); 
hold on;
semilogx(FV,-(DBEX-DBE),'k','LineWidth',1.5);
xlim([20 22050]);
grid on;
hold off;
legend('ANC','PNC','Total','Location','Northwest');
formtitle=sprintf('Triple attenuation plot for %s noise, mu=%.6g, L=%d',STRUCT.noiseType,STRUCT.adaptationStep,STRUCT.filterLength);
title(formtitle);
xlabel('Frequency (Hz)','FontWeight','bold','Color','k');
ylabel('Attenuation (dB)','FontWeight','bold','Color','k'); 
end

function soundNOANC(PROCSPEECH,D)
sound(PROCSPEECH+D,44100);
end

function soundANC(PROCSPEECH,E)
sound(PROCSPEECH+E,44100);
end

function plotcma(CMA,STRUCT)
t=linspace(0,length(CMA)/44100,length(CMA));
plot(t,CMA);
formtitle=sprintf('MSE plot of residual noise for %s noise, mu=%.6g, L=%d',STRUCT.noiseType,STRUCT.adaptationStep,STRUCT.filterLength);
title(formtitle);
grid on;
xlabel('Time (sec)','FontWeight','bold','Color','k');
ylabel('Mean Squared Error (dB)','FontWeight','bold','Color','k'); 
end

function computespectr(E)
[s,f,t] = spectrogram(E,4096,128,4096,44100,'yaxis');
surf(t,f,pow2db(abs(s).^2),'EdgeColor','none');
ylim([20 22050]);
colorbar;
colormap jet;
set(gca,'YScale','log');
axis xy;
axis tight;
xlabel('Time (sec)','FontWeight','bold','Color','k');
ylabel('Frequency (Hz)','FontWeight','bold','Color','k');
view(0,90);
end

function computeinfo(D,E,PROCSPEECH)
[INTELNOISY,INTELCLEAN]=stoi(PROCSPEECH,D,E,44100);
% X = categorical({'ANC ON','ANC OFF'});
% X=reordercats(X,{'ANC ON','ANC OFF'});
% bar(X,[INTELCLEAN,INTELNOISY]);
% title('Short-time objective intelligibility measure');
% ylabel('Intelligibility index','FontWeight','bold','Color','k');
% Define the data
data = [INTELCLEAN, INTELNOISY]; % ANC ON and ANC OFF values
% Define the labels for the bars
labels = {'ANC ON', 'ANC OFF'};

% Create a bar graph with blue and red bars
bar(data);
colormap([0 0 1; 1 0 0]); % Blue and red colors

% Add labels to the x-axis and y-axis
xlabel('Condition'); % X-axis label
ylabel('Index'); % Y-axis label

% Set the x-axis tick labels to be the condition labels
set(gca, 'XTickLabel', labels);

% Set the title of the graph
title('Speech Intelligibility Index');


end
