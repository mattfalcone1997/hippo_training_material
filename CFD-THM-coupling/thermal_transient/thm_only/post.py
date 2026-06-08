from pathlib import Path

import numpy as np
import pyvista as pv


def main():
    thm_reader: pv.ExodusIIReader = pv.get_reader("main_out.e")
    p = pv.Plotter(off_screen=True, window_size=(1504,1504))
    p.open_movie("thermal_transient.mp4")

    for t in range(thm_reader.number_time_points):
        print(t)
        p.clear()
        p.enable_lightkit()

        thm_reader.set_active_time_point(t)
        thm_data = thm_reader.read()["Element Blocks"].as_polydata_blocks()

        p.add_mesh(thm_data[0].tube(radius=0.025),
                scalars='T', cmap='jet', clim=(300,350))

        p.view_xy(negative=True)
        p.camera.azimuth = 30
        p.camera.elevation = 20
        p.camera.zoom(1.6)
        p.write_frame()


if __name__ == "__main__":
    main()
