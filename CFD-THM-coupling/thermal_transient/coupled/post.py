from pathlib import Path

import numpy as np
import pyvista as pv


def main():
    foam_file = Path("foam_cfd/viz.foam")
    foam_file.touch()

    foam_reader: pv.POpenFOAMReader = pv.get_reader(foam_file)
    foam_reader.case_type = "decomposed"

    edges = foam_reader.read()["boundary"].combine(merge_points=True).extract_feature_edges()

    thm_reader: pv.ExodusIIReader = pv.get_reader("main_out.e")
    p = pv.Plotter(off_screen=True, window_size=(1504,1504))
    p.open_movie("thermal_transient.mp4")
    assert foam_reader.number_time_points == thm_reader.number_time_points

    for t in range(foam_reader.number_time_points):
        print(t)
        p.clear()
        p.enable_lightkit()

        foam_reader.set_active_time_point(t)
        foam_data = foam_reader.read()['boundary']["pipe"]

        thm_reader.set_active_time_point(t)
        thm_data = thm_reader.read()["Element Blocks"].as_polydata_blocks()

        for thm in thm_data:
            thm.cell_data['U'] = thm.cell_data['vel_']
            thm.cell_data.remove('vel_')

        p.add_mesh(foam_data, scalars='T', cmap='jet', clim=(300,350), preference='cell')
        p.add_mesh(edges, color = 'k', line_width=10)
        p.add_mesh(thm_data[0].tube(radius=0.025),
                scalars='T', cmap='jet', clim=(300,350))
        p.add_mesh(thm_data[1].tube(radius=0.025),
                scalars='T', cmap='jet', clim=(300,350))

        p.view_xy(negative=True)
        p.camera.azimuth = 30
        p.camera.elevation = 20
        p.camera.zoom(1.6)
        p.write_frame()


if __name__ == "__main__":
    main()
