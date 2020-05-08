public abstract class SceneObject {
    protected ColorRGB color;
    protected double reflectivity;

    // Co-efficients for calculating Phong illumination
    protected double phongkD, phongkS, alpha;

    protected SceneObject() {
		colour = new ColorRGB(1);
		phong_kD = phong_kS = phong_alpha = reflectivity = 0;
	}

    public abstract RayCastHit intersectionWith(Ray ray);

    public abstract Vector3 getNormalAt(Vector3 position);

    public ColorRGB getColor() {
		return color;
	}

	/*public void setColor(ColorRGB color) {
		this.colour = color;
	}*/

    public double getPhong_kD() {
		return phong_kD;
	}

	public double getPhong_kS() {
		return phong_kS;
	}

	public double getPhong_alpha() {
		return phong_alpha;
	}

	public double getReflectivity() {
		return reflectivity;
	}

    /*public void setReflectivity(double reflectivity) {
		this.reflectivity = reflectivity;
	}*/
}
