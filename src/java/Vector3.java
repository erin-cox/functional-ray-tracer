public class Vector3 {
    public final double x, y, z;

    public Vector3(double uniform) {
        this(uniform, uniform, uniform);
    }

    public Vector3(double x, double y, double z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public Vector3 add(Vector3 other) {
        return new Vector3(x + other.x, y + other.y, z + other.z);
    }

    public Vector3 add(double other) {
        return new Vector3(x + other, y + other, z + other);
    }

    public Vector3 subtract(Vector3 other) {
        return new Vector3(x - other.x, y - other.y, z - other.z);
    }

    public Vector3 subtract(double other) {
        return new Vector3(x - other, y - other, z - other);
    }

    public Vector3 scale(double scalar) {
        return new Vector3(x * other, y * other, z * other);
    }

    public Vector3 scale(Vector3 other) {
        return new Vector3(x * other.x, y * other.y, z * other.z);
    }

    public double dot(Vector3 other) {
        return x * other.x + y * other.y + z * other.z;
    }

    public Vector3 cross(Vector3 other) {
        return new Vector3(y * other.z - z * other.y, z * other.x - x * other.z, x * other.y - y * other.x);
    }

    public Vector3 power(double e) {
		return new Vector3( Math.pow(x,e), Math.pow(y,e), Math.pow(z,e) );
	}

	public Vector3 inv() {
		return new Vector3( 1/x, 1/y, 1/z );
	}

	public double magnitude() {
		return Math.sqrt(x * x + y * y + z * z);
	}

    public Vector3 normalize() {
		double magnitude = this.magnitude();
		return new Vector3(x / magnitude, y / magnitude, z / magnitude);
	}

    // Reflects the vector in the normal N
    public Vector3 reflectIn(Vector3 N) {
		return N.scale(2 * this.dot(N)).subtract(this);
	}

    public static Vector3 randomInsideUnitSphere() {
        double r = Math.random();
        double theta = Math.random() * Math.PI;
        double phi = Math.random() * 2 * Math.PI;

        double x = r * Math.sin(theta) * Math.cos(phi);
        double y = r * Math.sin(theta) * Math.sin(phi);
        double z = r * Math.cos(theta);

        return new Vector3(x, y, z);
    }
}
