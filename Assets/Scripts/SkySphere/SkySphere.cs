using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[ExecuteInEditMode]
public class SkySphere : MonoBehaviour
{

    [Range(0, 1)] public float currentTime = 0f;

    public Light sunLight;
    
    public GameObject sun;
    public GameObject moon;

    public Material stars;
    public Material atmosphere;
    public Material clouds;
    public Material water;

    public AnimationCurve starsFade = new AnimationCurve();
    public AnimationCurve fogFade = new AnimationCurve();
    public AnimationCurve lightFade = new AnimationCurve();
    
    public Gradient cloudColor = new Gradient();
    public Gradient horizonColor = new Gradient();
    public Gradient waterColor = new Gradient();
    public Gradient environmentColor = new Gradient();
    
    private void Start()
    {
        
    }

    private void Update()
    {
        if(sun != null) {
            sun.transform.rotation = Quaternion.AngleAxis(currentTime * 360, Vector3.right); //rotate the sun based on the time
        }

        if(stars != null) {
            stars.SetFloat("_StarsFade", starsFade.Evaluate(currentTime));
            //since the atmosphere is additive, we need to fade the stars out during the day otherwise they will show through the blue sky atmoshphere.  
            //The actually black sky behind the stars is fine though, because black doesn't add.  If you had some kind of galaxy texture or something that wasn't pure black, you'd need to fade that too.
        }


        //setting shader vars for the sun
        if(sun != null) Shader.SetGlobalVector("SunDirLightDirection", new Vector4(sunLight.transform.forward.x, sunLight.transform.forward.y, sunLight.transform.forward.z, sunLight.intensity));
        if(sun != null) Shader.SetGlobalColor("SunDirLightColor", sunLight.color);

        Shader.SetGlobalColor("CloudColor", cloudColor.Evaluate(currentTime));
        Shader.SetGlobalColor("_HorizonColor", horizonColor  .Evaluate(currentTime));
        water.SetColor("_FarColor", waterColor.Evaluate(currentTime));
        RenderSettings.ambientSkyColor = environmentColor.Evaluate(currentTime);

        RenderSettings.fogDensity = fogFade.Evaluate(currentTime);
        sunLight.intensity = lightFade.Evaluate(currentTime);
    }
}
