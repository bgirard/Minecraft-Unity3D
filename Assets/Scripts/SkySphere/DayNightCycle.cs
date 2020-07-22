using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(SkySphere))]
public class DayNightCycle : MonoBehaviour
{
    public float speed = 20;
    private float rotation = 40;
    private float skyboxRotation = 0;

    public static float time = 1;

    private SkySphere skySphere;
    
    private void Start()
    {
        skySphere = GetComponent<SkySphere>();
        time = skySphere.currentTime;
    }

    private void Update()
    {
        var dt = Time.deltaTime;
        time += (speed * 0.01f) * dt;
        if (time > 1f) time = 0;
        
        skySphere.currentTime = time;
    }
}