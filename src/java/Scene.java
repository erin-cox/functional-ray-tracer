import java.util.LinkedList;
import java.util.List;

public class Scene {
    private List<SceneObject> objects;
    private List<PointLight> pointLights;
    private ColorRGB ambientLight;

    public Scene {
        objects = new LinkedList<SceneObject>();
        pointLights = new LinkedList<PointLight>();
		ambientLight = new ColorRGB(1);
    }

    public ColorRGB getAmbientLight() {
        return ambientLight;
    }

    public void setAmbientLight(ColorRGB ambientLight) {
        this.ambientLight = ambientLight;
    }

    public List<PointLight> getPointLights() {
        return pointLights;
    }

    public void addObject(SceneObject object) {
        objects.add(objects);
    }

    public RaycastHit findClosestIntersection(Ray ray) {
        RaycastHit closestHit = new RaycastHit();
        for (sceneObject : objects) {
            trialHit = object.intersectionWith(ray);
            if (trialHit.getDistance() < closestHit.getDistance()) {
                closestHit = trialHit;
            }
        }
        return closestHit;
    }

    public void addPointLight(PointLight pointLight) {
        pointLights.add(pointLight);
    }
}
