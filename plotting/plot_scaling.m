dark_blue = [ 0.067, 0.431, 0.541 ];
blue = [ 0.11,0.55,0.69 ];

%% strong scaling

cores = [ 1 2 4 8 16 ];
timings = [ (54*60+28) (59*60+26) (58*60+26) (71*60+11) (75*60+52) ];

figure(1);
semilogx(cores, timings, "-x", "Color", dark_blue, "LineWidth", 1.5, "MarkerSize", 12);
xlabel("Number of cores", "interpreter", "Latex");
ylabel("Computing time [s]", "interpreter", "Latex");
ylim([0 4750]);
xlim([min(cores)/1.2 max(cores)*1.2]);
xticks(cores);
xticklabels({'$$\begin{array}{c} 1 \\ \end{array}$$', '$$\begin{array}{c} 2 \\ \end{array}$$', '$$\begin{array}{c} 4 \\  \end{array}$$', '$$\begin{array}{c} 8 \\ \phantom{s} \end{array}$$','$$\begin{array}{c} 16 \\ \end{array}$$'}); set(gca,'TickLabelInterpreter','latex');
%title("Strong scaling", "interpreter", "Latex")
set(gca, 'FontName', 'Times New Roman')
set(gca,'XMinorTick','off')
axis square;

%% weak scaling

cores = [ 1 4 16 ];
timings = [ (4*60+44) (3*60+47) (4*60+45) ];

figure(1);
semilogx(cores, timings, "-x", "Color", dark_blue, "LineWidth", 1.5, "MarkerSize", 12);
xlabel("Number of cores and grid size", "interpreter", "Latex");
ylabel("Total elapsed time [s]", "interpreter", "Latex");
ylim([0 350]);
xlim([min(cores)/1.2 max(cores)*1.2]);
xticks(cores);
xticklabels({'$$\begin{array}{c} 1 \\ (200 \times 200) \end{array}$$', '$$\begin{array}{c} 4 \\ (400 \times 400) \end{array}$$','$$\begin{array}{c} 16 \\ (800 \times 800) \end{array}$$'}); set(gca,'TickLabelInterpreter','latex');
%title("Weak scaling", "interpreter", "Latex")
set(gca, 'FontName', 'Times New Roman')
set(gca,'XMinorTick','off')
axis square;

