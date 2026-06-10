"""Script to visualise the shell and tube heat exchanger example"""

from pathlib import Path

import numpy as np
import pyvista as pv


def visualise_shell_tube(inner, outer, solid, src=None, plotter=None):

    if src is None:
        streamlines, src = outer.streamlines(vectors='U',
                                             return_source=True,
                                             source_center=(0, -0.85, -1.6),
                                             source_radius=0.12,
                                             n_points=50,
                                             integration_direction='forward',
                                             max_steps=5000)
    else:
        streamlines = outer.streamlines_from_source(source=src,
                                                    vectors='U',
                                                    integration_direction='forward',
                                                    max_steps=5000)

    if plotter is None:
        plotter = pv.Plotter()

    kwargs = {'clim': (280, 353),
              'cmap': 'jet',
              'show_scalar_bar': False}
    plotter.add_mesh(solid, scalars='T',
               **kwargs)
    plotter.add_mesh(inner, scalars='T',
               **kwargs)
    plotter.add_mesh(streamlines,
               scalars='T',
               render_lines_as_tubes=True,
               line_width=7.,
               **kwargs)

    plotter.view_xy()
    plotter.camera.up = (0, -1, 0)
    plotter.camera.azimuth = 30
    plotter.camera.elevation = 20
    plotter.camera.zoom(1.5)

    return plotter, src


def main():
    outer_file = Path("fluid-outer-openfoam/outer.foam")
    inner_file = Path("fluid-inner-openfoam/inner.foam")

    # Create OpenFOAM visualisation files
    outer_file.touch()
    inner_file.touch()

    outer_reader = pv.get_reader(outer_file)
    inner_reader = pv.get_reader(inner_file)
    solid_reader = pv.get_reader("solid_out.e")

    # Set visualisation time to be the last available time
    # and make sure the other domains use the closest time
    outer_reader.set_active_time_point(outer_reader.number_time_points - 1)

    target_time = outer_reader.active_time_value
    inner_point = np.argmin(
        abs(target_time - np.array(inner_reader.time_values)))
    inner_reader.set_active_time_point(inner_point)

    solid_point = np.argmin(
        abs(target_time - np.array(solid_reader.time_values)))
    solid_reader.set_active_time_point(solid_point)

    # Read and extract the volume meshes of each
    outer = outer_reader.read()["internalMesh"]
    inner = inner_reader.read()["internalMesh"]
    solid = solid_reader.read()["Element Blocks"]

    p = pv.Plotter(window_size=(1200,600), shape=(1,2))
    p.subplot(0,0)
    # Create the streamlines
    p, src = visualise_shell_tube(inner, outer, solid, plotter=p)
    p.add_text("Hippo")

    reference_results = pv.get_reader("reference_results.vtm").read()
    inner_ref = reference_results['inner']
    outer_ref = reference_results['outer']
    solid_ref = reference_results['solid']

    p.subplot(0,1)

    p, src = visualise_shell_tube(
        inner_ref, outer_ref, solid_ref, src=src, plotter=p)
    p.add_text("preCICE")

    p.link_views()
    p.show()

    p = pv.Plotter()
    inner.point_data['Error'] = abs(inner.point_data['T'] - inner_ref.point_data['T'])/(353-280.)
    outer.point_data['Error'] = abs(outer.point_data['T'] - outer_ref.point_data['T'])/(353 - 280.)

    kwargs = {'scalars' : 'Error',
              'cmap' : 'hot_r',
              'scalar_bar_args': {'title': 'Normalised error'},
              'log_scale': False}

    p.add_mesh(inner.clip('x'), clim=(1e-8,0.2), **kwargs)
    p.add_mesh(outer.clip('x').translate([0,-1.2,0]), clim=(1e-8,0.2), **kwargs)
    p.add_axes()

    p.view_xy()
    p.camera.azimuth = 40
    p.camera.elevation = 20
    p.camera.zoom(2.)
    p.show()

if __name__ == "__main__":
    main()
