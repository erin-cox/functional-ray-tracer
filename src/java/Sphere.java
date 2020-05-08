public class Sphere extends SceneObject {
    // Default sphere co-efficients
    private final double SPHERE_KD = 0.8;
	private final double SPHERE_KS = 1.2;
	private final double SPHERE_ALPHA = 10;
	private final double SPHERE_REFLECTIVITY = 0.3;

    private Vector3 position;
    private double radius;

    public Vector3 getPosition() {
		return position;
	}

    public Sphere(Vector3 position, double radius, ColorRGB color) {
        this.position = position;
        this.radius = radius;
        this.color = color;

        this.phong_kD = SPHERE_KD;
		this.phong_kS = SPHERE_KS;
		this.phong_alpha = SPHERE_ALPHA;
		this.reflectivity = SPHERE_REFLECTIVITY;
    }

    public Sphere(Vector3 position, double radius, ColorRGB color, double kD, double kS, double alphaS, double reflectivity) {
		this.position = position;
		this.radius = radius;
		this.color = color;

		this.phong_kD = kD;
		this.phong_kS = kS;
		this.phong_alpha = alphaS;
		this.reflectivity = reflectivity;
	}

    public RaycastHit intersectionWith(Ray ray) {
        Vector3 O = ray.getOrigin();
        Vector3 D = ray.getDirection();

        Vector3 C = position;
        double r = radius;

        // Calculate quadratic coefficients
        double a = D.dot(D);
        double b = 2 * D.dot(O.subtract(C));
		double c = (O.subtract(C)).dot(O.subtract(C)) - r * r;

        double discriminant = b * b - 4 * a * c;
		RaycastHit hit = new RaycastHit();

        if (discriminant > 0) {
            // As a ~= 1, s1 <= s2
            double s1 = (-b - Math.sqrt(discriminant)) / (2 * a);
            double s2 = (-b + Math.sqrt(discriminant)) / (2 * a);
            Vector3 p;
            if (s2 >= 0) {
                if (s1 >= 0) {
                    p = ray.evaluateAt(s1);
                    hit = new RaycastHit(this, s1, p, getNormalAt(p));
                } else {
                    p = ray.evaluateAt(s2);
                    hit = new RaycastHit(this, s2, p, getNormalAt(p));
                }
            }
        }

        return hit;
    }

    public Vector3 getNormalAt(Vector position) {
        return position.subtract(this.position).normalize();
    }
}
