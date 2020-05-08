import java.awt.image.BufferedImage;
import java.util.List;

public class Renderer {
    // Width and height of the image in pixels
    private int width, height;

    // Bias factor for reflected and shadow rays
    private final double EPSILON = 0.0001;

    // The number of times a ray can bounce for reflection
    private final int bounces = 3;

    // Background color of the image
	private ColorRGB backgroundColor = new ColorRGB(0.001);

    public Renderer(int width, int height) {
		this.width = width;
		this.height = height;
	}

    // Traces a ray through the scene, returning the color to be rendered. The bouncesLeft
    // parameter is for rendering reflective surfaces with recursive calls to trace.
    protected ColorRGB trace(Scene scene, Ray ray, int bouncesLeft) {
        RaycastHit closestHit = scene.findClosestIntersection(ray);
        SceneObject object = closestHit.getObjectHit();
        if (object == null) {
            return backgroundColor;
        }

        Vector3 P = closestHit.getLocation();
        Vector3 N = closestHit.getNormal();
        Vector3 O = ray.getOrigin();

        ColorRGB directIllumination = this.illuminate(scene, object, P, N, O);
        double reflectivity = object.getReflectivity();
        // If no bounces left or surface not reflective
        if (bouncesLeft == 0 || reflectivity == 0.0) {
            return directIllumination;
        }

        // The reflected ray in the normal to the object at the point of contact,
        // adjusted by EPSILON to prevent self-intersection
        Vector3 R = ray.getDirection().reflectIn(N).scale(-1.0);
        Ray reflectedRay = new Ray(P.add(R.scale(EPSILON)), R);

        ColorRGB reflectedIllumination = trace(scene, reflectedRay, bouncesLeft - 1);

        // Scaling the direct and reflected illumination to conserve light
        directIllumination = directIllumination.scale(1.0 - reflectivity);
        reflectedIllumination = reflectedIllumination.scale(reflectivity);

        return directIllumination.add(reflectedIllumination);
    }

    // Illuminates object at position P relative to a ray originating at O
    // using the Phong illumination model.
    private ColorRGB illuminate(Scene scene, SceneObject object, Vector3 P, Vector3 N, Vector3 O) {
		ColorRGB I_a = scene.getAmbientLighting();
		ColorRGB C_diff = object.getColor();
        double k_d = object.getPhong_kD();
		double k_s = object.getPhong_kS();
		double alpha = object.getPhong_alpha();

        ColorRGB colorToReturn = C_diff.scale(I_a);

        List<PointLight> pointLights = scene.getPointLights();
        for (light : pointLights) {
            double distanceToLight = light.getPosition().subtract(P).magnitude();
            ColorRGB C_spec = light.getColor();
            ColorRGB I = light.getIlluminationAt(distanceToLight);

            Vector3 L = light.getPosition().subtract(P).normalize();
			Vector3 R = L.reflectIn(N).normalize();
			Vector3 V = O.subtract(P).normalize();

            // Determines whether point P on the object is in shadow relative to this light
            Ray shadowRay = new Vector3(P.add(L.scale(EPSILON)), L);
            if (scene.findClosestIntersection(shadowRay).getDistance() < distanceToLight) {
                return colorToReturn;
            }

			ColorRGB diffuse_term = C_diff.scale(k_d).scale(I).scale(Math.max(0.0,N.dot(L)));
			ColorRGB specular_term = C_spec.scale(k_s).scale(I).scale(Math.pow(Math.max(0.0,R.dot(V)), alpha));
			colorToReturn = colorToReturn.add(diffuse_term).add(specular_term);
            return colorToReturn;
        }
    }

    // Render image from scene, with camera at origin
	public BufferedImage render(Scene scene) {

		// Set up image
		BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);

		// Set up camera
		Camera camera = new Camera(width, height);

		// Loop over all pixels
		for (int y = 0; y < height; ++y) {
			for (int x = 0; x < width; ++x) {
				Ray ray = camera.castRay(x, y); // Cast ray through pixel
				ColorRGB linearRGB = trace(scene, ray, bounces); // Trace path of cast ray and determine colour
				ColorRGB gammaRGB = tonemap( linearRGB );
				image.setRGB(x, y, gammaRGB.toRGB()); // Set image colour to traced colour
			}
			// Display progress every 10 lines
            if( y % 10 == 0 )
			    System.out.println(String.format("%.2f", 100 * y / (float) (height - 1)) + "% completed");
		}
		return image;
	}

    // Combined tone mapping and display encoding
	public ColorRGB tonemap( ColorRGB linearRGB ) {
		double invGamma = 1./2.2;
		double a = 2;  // controls brightness
		double b = 1.3; // controls contrast

		// Sigmoidal tone mapping
		ColorRGB powRGB = linearRGB.power(b);
		ColorRGB displayRGB = powRGB.scale( powRGB.add(Math.pow(0.5/a,b)).inv() );

		// Display encoding - gamma
		ColorRGB gammaRGB = displayRGB.power( invGamma );

		return gammaRGB;
	}
}
