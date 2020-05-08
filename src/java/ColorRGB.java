public class ColorRGB {
    private Vector3 v;

    public final double r;
    public final double g;
    public final double b;

    public ColorRGB(double uniform) {
		v = new Vector3(uniform);
		r = v.x;
		g = v.y;
		b = v.z;
	}

	public ColorRGB(double red, double green, double blue) {
		v = new Vector3(red, green, blue);
		r = v.x;
		g = v.y;
		b = v.z;
	}

    public ColorRGB(String rgb) {
        rgb = rgb.replace("#", "");
        r = rgb.substring(0,2);
        g = rgb.substring(2,4);
        b = rgb.substring(4,6);
        
    }

	private ColorRGB(Vector3 vec) {
		v = new Vector3(vec.x, vec.y, vec.z);
		r = v.x;
		g = v.y;
		b = v.z;
	}

    public ColorRGB add(ColorRGB other) {
		return new ColorRGB(v.add(other.v));
	}

	public ColorRGB add(double other) {
		return new ColorRGB(v.add(other));
	}

	public ColorRGB subtract(ColorRGB other) {
		return new ColorRGB(v.subtract(other.v));
	}

	public ColorRGB scale(double scalar) {
		return new ColorRGB(v.scale(scalar));
	}

	public ColorRGB scale(ColorRGB other) {
		return new ColorRGB(v.scale(other.v));
	}

	public ColorRGB power(double e) {
        return new ColorRGB(v.power(e));
    }

	public ColorRGB inv() {
        return new ColorRGB(v.inv());
    }

    private static int convertToByte(double value) {
		return (int) (255 * Math.max(0, Math.min(1, value)));
	}

    public int toRGB() {
		return convertToByte(r) << 16 | convertToByte(g) << 8 | convertToByte(b) << 0;
	}
}
