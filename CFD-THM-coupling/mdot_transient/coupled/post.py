from pathlib import Path

import pyvista as pv


def main():
    foam_file = Path("foam_cfd/viz.foam")
    foam_file.touch()

    foam_reader: pv.POpenFOAMReader = pv.get_reader(foam_file)
    foam_reader.case_type = "decomposed"

    edges = foam_reader.read()["boundary"].combine(True).extract_feature_edges()

    thm_reader = pv.get_reader("main_out.e")
    p = pv.Plotter(off_screen=True, window_size=(1500,1500))
    p.open_movie("mdot_transient.mp4", framerate=10, quality=10)
    assert foam_reader.number_time_points == thm_reader.number_time_points

    for i, t in enumerate(thm_reader.time_values):
        print(t)
        p.clear()
        p.enable_lightkit()

        foam_reader.set_active_time_point(i)
        foam_data = foam_reader.read()['internalMesh']

        thm_reader.set_active_time_point(i)
        thm_data = thm_reader.read()["Element Blocks"].as_polydata_blocks()

        for thm in thm_data:
            thm.cell_data['U'] = thm.cell_data['vel_']
            thm.cell_data.remove('vel_')
        p.add_mesh(foam_data.slice('x'), scalars='U', cmap='jet', clim=(0,4.5), preference='cell')
        p.add_mesh(edges, color = 'k', line_width=10)
        p.add_mesh(thm_data[0].tube(radius=0.025),
                scalars='U', cmap='jet', clim=(0,4.5))
        p.add_mesh(thm_data[1].tube(radius=0.025),
                scalars='U', cmap='jet', clim=(0,4.5))
        p.add_text(f"t = {t:3g}s")
        p.view_zy()

        p.camera.zoom(1.6)
        p.write_frame()


if __name__ == "__main__":
    main()
