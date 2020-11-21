#!/usr/bin/env python3

import yt # 3.6.0 or higher
import sys
import subprocess

from matplotlib.animation import FuncAnimation, FFMpegWriter
from matplotlib import rc_context

R    = subprocess.check_output('whoami').decode().strip()
name = sys.argv[1]
path = f'/cw/lvs/NoCsBack/vakken/ac2021/G0B30A/{R}/output_{name}'



ts = yt.load(f'{path}/turbulence_*.dat')

data = 'm1'
plot = yt.SlicePlot(ts[0], 'z', data)
plot.set_zlim(data, -1e-5, 1e1)

fig = plot.plots[data].figure

def animate(i):
    ds = ts[i]
    plot._switch_ds(ds)

animation = FuncAnimation(fig, animate, frames=len(ts))

writer = FFMpegWriter(fps=30)
animation.save(f'{path}/{data}_animation.mp4', writer=writer)

