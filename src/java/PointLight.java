public class PointLight {
	private Vector3 position;
	private ColorRGB color;
	private double intensity;

    public PointLight(Vector3 position, ColorRGB colour, double intensity) {
		this.position = position;
		this.colour = colour;
		this.intensity = intensity;
	}

	public Vector3 getPosition() {
		return position;
	}

	public ColorRGB getColour() {
		return colour;
	}

	public double getIntensity() {
		return intensity;
	}

    public ColorRGB getIlluminationAt(double distance) {
        return color.scale(intensity / (4 * Math.PI * distance * distance));
    }
}
