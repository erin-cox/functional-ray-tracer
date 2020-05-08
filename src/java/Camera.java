public class Camera {
    private int width_px, height_px;  // Dimensions of camera view in pixels
    private double width_m, height_m; // Dimensions of camera view in world units
    double aspectRatio;

    double fov = 45; // Horizontal field of view in degrees

    private double x_step_m, y_step_m;

    public Camera(int width, int height) {
        this(width, height, new Vector3(0.0));
    }

    // position and direction currently not implemented
    public Camera(int width, int height, Vector3 position, Vector3 direction) {
        this.width_px = width;
        this.height_px = height;

        this.aspectRatio = ((double) width) / ((double) height);

        this.width_m = 2 * Math.tan(Math.toRadians(this.fov) / 2);
		this.height_m = width_m / aspectRatio;

		this.x_step_m = this.width_m / this.width_px;
		this.y_step_m = this.height_m / this.height_px;
    }

    public Ray castRay(int x, int y) {
        double x_pos = (x_step_m - width_m) / 2 + x * x_step_m;
		double y_pos = (y_step_m + height_m) / 2 - y * y_step_m;
		return new Ray(new Vector3(0, 0, 0), new Vector3(x_pos, y_pos, 1).normalised());
    }
}
