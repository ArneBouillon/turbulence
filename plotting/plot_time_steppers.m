dark_blue = [ 0.067, 0.431, 0.541 ];
blue = [ 0.11,0.55,0.69 ];

steps = [ 1 3 5 ];
timings = [ 3*3600+57*60+29 4*3600+28*60+29 ];

figure(1);
semilogx(cores, timings, "-x", "Color", dark_blue, "LineWidth", 1.5, "MarkerSize", 12);
xlabel("Number of steps (method)", "interpreter", "Latex");
ylabel("Computing time [s]", "interpreter", "Latex");
ylim([0 4750]);
xlim([min(cores)/1.2 max(cores)*1.2]);
xticks(cores);
xticklabels({'$$\begin{array}{c} 1 \\ () \\ \end{array}$$', '$$\begin{array}{c} 2 \\ \end{array}$$', '$$\begin{array}{c} 4 \\  \end{array}$$', '$$\begin{array}{c} 8 \\ \phantom{s} \end{array}$$','$$\begin{array}{c} 16 \\ \end{array}$$'}); set(gca,'TickLabelInterpreter','latex');
%title("Strong scaling", "interpreter", "Latex")
set(gca, 'FontName', 'Times New Roman')
set(gca,'XMinorTick','off')
axis square;