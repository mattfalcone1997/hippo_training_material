
from pathlib import Path

import pyvista as pv

def main():
    exo_file = Path("heated_plate_out.e")
    foam_file = Path("fluid-openfoam/viz.foam")
    foam_file.touch()

    solid_reader = pv.get_reader(exo_file)
    fluid_reader = pv.get_reader(foam_file)
    fluid_reader.case_type = 'decomposed'
    times = solid_reader.time_values[:-1]

    Path("images").mkdir(exist_ok=True)

    p = pv.Plotter(off_screen=True, window_size=(2000, 704))
    for i, t in enumerate(times):
        solid_reader.set_active_time_point(i)
        fluid_reader.set_active_time_point(i)

        solid = solid_reader.read()["Element Blocks"][0]
        fluid = fluid_reader.read()["internalMesh"]

        p.clear()
        p.enable_lightkit()

        p.add_mesh(solid, cmap='bwr', clim=(300,310), scalars='T')
        p.add_mesh(solid.extract_feature_edges(), color='k')
        p.add_mesh(fluid, cmap='bwr', clim=(300,310), scalars='T')
        p.enable_parallel_projection()
        p.view_xy()

        fps = list(solid.center)
        fps[1] = 0

        cps = fps.copy()
        cps[2] = 2

        p.camera.focal_point = fps
        p.camera.position = cps

        p.camera.zoom(5)
        p.add_text(f"t = {t:.5g}")

        p.render()
        p.screenshot(f"images/frames_{i}.png")

    p.close()

if __name__ == '__main__':
    main()



