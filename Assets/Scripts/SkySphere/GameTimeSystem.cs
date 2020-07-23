using UnityEngine;

//Counts current game time and provide it for the rest of the game.
[RequireComponent(typeof(SkySphere))]
public class GameTimeSystem : MonoBehaviour
{
    public float speed = 1;
    private SkySphere skySphere;
    
    public static float time = 1;
    public static int daysSinceStart = 0;
    
    private void Start()
    {
        skySphere = GetComponent<SkySphere>();
        time = skySphere.currentTime;
    }

    private void Update()
    {
        if(PauseMenu.pause)    
            return;
        
        var dt = Time.deltaTime;
        time += (speed * 0.01f) * dt;
        if (time > 1f)
        {
            time = 0;
            daysSinceStart++;
        }
        
        skySphere.currentTime = time;
    }
}