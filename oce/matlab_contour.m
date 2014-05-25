clear all;

d = importdata('data.dat');
x = d.data(:,1);
y = d.data(:,2);
z = d.data(:,3);

levels = 0:50:1000;
xg = linspace(0, 6.5, 100); % same as R example
yg = xg;
[XG, YG] = meshgrid(xg, yg);
zg = griddata(x, y, z, XG, YG, 'linear'); % default

subplot(221)
[cs, h] = contour(xg, yg, zg, levels, 'k');
title('linear')
clabel(cs, h)
hold on
scatter(x, y, 20, 'markerfacecolor', 'k', 'markeredgecolor', 'k')
hold off

subplot(222)
zg = griddata(x, y, z, XG, YG, 'cubic');
[cs, h] = contour(xg, yg, zg, levels, 'k');
title('cubic')
clabel(cs, h)
hold on
scatter(x, y, 20, 'markerfacecolor', 'k', 'markeredgecolor', 'k')
hold off

subplot(223)
zg = griddata(x, y, z, XG, YG, 'nearest');
[cs, h] = contour(xg, yg, zg, levels, 'k');
title('nearest')
clabel(cs, h)
hold on
scatter(x, y, 20, 'markerfacecolor', 'k', 'markeredgecolor', 'k')
hold off

subplot(224)
zg = griddata(x, y, z, XG, YG, 'v4');
[cs, h] = contour(xg, yg, zg, levels, 'k');
title('v4')
clabel(cs, h)
hold on
scatter(x, y, 20, 'markerfacecolor', 'k', 'markeredgecolor', 'k')
hold off

print('-dpng', 'matlab.png')
