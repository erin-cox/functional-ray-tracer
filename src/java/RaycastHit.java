public class RaycastHit {
    private SceneObject objectHit;
    private double distance; // The distance the ray travelled before hitting an object
    private Vector3 location;
    private Vector3 normal; // The normal to the object at location

    public RaycastHit() { // No hit; ray shoots off to infinity
        this.distance = Double.POSITIVE_INFINITY;
    }

    public RaycastHit(SceneObject sceneObject, double distance, Vector3 location, Vector3 normal) {
        this.distance = distance;
		this.objectHit = objectHit;
		this.location = location;
		this.normal = normal;
    }

    public SceneObject getObjectHit() {
		return objectHit;
	}

	public Vector3 getLocation() {
		return location;
	}

	public Vector3 getNormal() {
		return normal;
	}

	public double getDistance() {
		return distance;
	}
}
