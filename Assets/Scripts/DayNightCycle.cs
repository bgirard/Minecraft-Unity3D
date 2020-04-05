using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DayNightCycle : MonoBehaviour
{
    public float speed = 20;
    private float rotation = 40;
    private float skyboxRotation = 0;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        rotation = rotation + Time.deltaTime * speed;
        if (rotation % 356 >= 260)
        {
            rotation = 1;
        }
        transform.eulerAngles = new Vector3(rotation, -30, 0);
        Light light = GetComponent<Light>();
        if (rotation >= 150)
        {
            light.intensity = Mathf.Lerp(1, 0, (rotation - 150) / (180 - 150));
        }
        else if (rotation <= 30)
        {
            light.intensity = Mathf.Lerp(0, 1, (rotation - 0) / (30 - 0));
        }
        else
        {
            light.intensity = 1;
        }
        light.intensity = 0;

        RenderSettings.skybox.SetFloat("_Exposure", light.intensity);
        skyboxRotation += Time.deltaTime * speed / 10f;
        RenderSettings.skybox.SetFloat("_Rotation", skyboxRotation);
    }
}