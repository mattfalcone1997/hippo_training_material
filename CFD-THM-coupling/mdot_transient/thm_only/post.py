import pyvista as pv


def main():


    thm_reader: pv.ExodusIIReader = pv.get_reader("main_out.e")
    p = pv.Plotter(off_screen=True, window_size=(1504,1504))
    p.open_movie("mdot_transient.mp4", framerate=10, quality=10)

    for i, t in enumerate(thm_reader.time_values):
        print(t)
        p.clear()
        p.enable_lightkit()

        thm_reader.set_active_time_point(i)
        thm_data = thm_reader.read()["Element Blocks"].as_polydata_blocks()

        for thm in thm_data:
            thm.cell_data['U'] = thm.cell_data['vel_']
            thm.cell_data.remove('vel_')

        p.add_mesh(thm_data[0].tube(radius=0.025),
                scalars='U', cmap='jet', clim=(0,4.5))

        p.add_text(f"t = {t:3g}s")
        p.view_zy()

        p.camera.zoom(1.6)
        p.write_frame()


if __name__ == "__main__":
    main()
