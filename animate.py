#!/usr/bin/env python3

import yt # 3.6.0 or higher

from matplotlib.animation import FuncAnimation, PillowWriter
from matplotlib import rc_context

ts = yt.load('output/turbulence_*.dat')

plot = yt.SlicePlot(ts[0], 'z', 'm1')
plot.set_zlim('m1', -1e-5, 5e0)

fig = plot.plots['m1'].figure

def animate(i):
    ds = ts[i]
    plot._switch_ds(ds)

animation = FuncAnimation(fig, animate, frames=len(ts))

gif_writer = PillowWriter(fps=30)
animation.save('animation.gif', writer=gif_writer)

