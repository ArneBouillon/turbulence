dark_blue = [ 0.067, 0.431, 0.541 ];
blue = [ 0.11,0.55,0.69 ];

sizes = [ 50 100 200 400 800 ];
timings = [ 3*60+9 10*60+7 44*60+7 2*3600+20*60+7 9*3600+14*60+22 ];

figure(1); clf;
loglog(sizes, timings, "-x", "Color", dark_blue, "LineWidth", 1.5, "MarkerSize", 12);
hold on
loglog([sizes 1600], [sizes 1600]/sizes(1)*timings(1),"--",  "Color", blue, "LineWidth", 1.1)
loglog(sizes, sizes.^2/sizes(1).^2*timings(1),"--",  "Color", blue,"LineWidth", 1.1)
xlabel("Number of grid points in the X and Y directions", "interpreter", "Latex");
ylabel("Computing time [s]", "interpreter", "Latex");
ylim([min(timings)/1.4 max(timings)*1.4]);
xlim([min(sizes)/1.2 max(sizes)*1.2]);
xticks(sizes);
%xticklabels({'$$\begin{array}{c} 50 \\ \end{array}$$', '$$\begin{array}{c} 100 \\ \end{array}$$', '$$\begin{array}{c} 200 \\  \end{array}$$', '$$\begin{array}{c} 400 \\ \phantom{s} \end{array}$$','$$\begin{array}{c} 800 \\ \end{array}$$'}); set(gca,'TickLabelInterpreter','latex');
%title("Strong scaling", "interpreter", "Latex")
set(gca, 'FontName', 'Times New Roman')
set(gca,'XMinorTick','off')
axis square;
