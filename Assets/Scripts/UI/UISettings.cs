using System;
using System.IO;
using UnityEngine;
using SharpConfig;

//Main settings component. Able to save and load configuration.
[RequireComponent(typeof(UIVideoSettings))]
public class UISettings : MonoBehaviour
{
    public string settingsFileName = "settings";
    private UIVideoSettings uiVideoSettings;
    private string settingsFilePath;

    public static Configuration settingsData;

    private void Start()
    {
        Configuration.SpaceBetweenEquals = true;
        
        uiVideoSettings = GetComponent<UIVideoSettings>();
        
        //Debug.Log(Application.persistentDataPath);
        //Debug.Log(Application.dataPath);
        settingsFilePath = Path.Combine(Application.persistentDataPath, settingsFileName) + ".ini";

        if (File.Exists(settingsFilePath))
        {
            Load();
        }
        else
        {
            Debug.Log($"Settings file wasn't found, creating new at {Application.persistentDataPath}");
            Grab();
            Save();
        }
    }

    private void Load()
    {
        settingsData = Configuration.LoadFromFile(settingsFilePath);
    }

    private void Grab()
    {
        var settings = new Configuration();
        settings.Add("Game Options");
        settings.Add("Audio Settings");
        settings.Add("Video Settings");
        settings.Add("Controls");

        #region Video Settings

        settings["Video Settings"]["Antialiasing"].PreComment         = "PostProcessing.";
        settings["Video Settings"]["Antialiasing"].IntValue           = uiVideoSettings.antialiasing.value;
        settings["Video Settings"]["Antialiasing"].Comment            = "0 - none, 1 - FastApproximateAntialiasing, 2 - SubpixelMorphologicalAntialiasing, 3 - TemporalAntialiasing.";
        
        settings["Video Settings"]["Underwater Effects"].BoolValue    = uiVideoSettings.underwaterEffects.isOn;
        settings["Video Settings"]["Bloom"].BoolValue                 = uiVideoSettings.bloom.isOn;
        settings["Video Settings"]["Auto Exposure"].BoolValue         = uiVideoSettings.autoExposure.isOn;
        settings["Video Settings"]["Color Grading"].BoolValue         = uiVideoSettings.colorGrading.isOn;
        settings["Video Settings"]["Depth Of Field"].BoolValue        = uiVideoSettings.depthOfField.isOn;
        settings["Video Settings"]["Ambient Occlusion"].BoolValue     = uiVideoSettings.ambientOcclusion.isOn;
        settings["Video Settings"]["Vignette"].BoolValue              = uiVideoSettings.vignette.isOn;
        settings["Video Settings"]["Motion Blur"].BoolValue           = uiVideoSettings.motionBlur.isOn;

        #endregion
        
        settingsData = settings;
    }

    public void Save()
    {
        Grab();
        
        if (File.Exists(settingsFilePath))
        {
            File.Delete(settingsFilePath);
        }

        settingsData.SaveToFile(settingsFilePath);
    }
    
    #if UNITY_EDITOR
    //Return default settings to keep local changes made by configuration out of git.
    public void OnApplicationQuit()
    {
        settingsFilePath = Path.Combine(Application.dataPath, "defaultSettings") + ".ini";
        settingsData = Configuration.LoadFromFile(settingsFilePath);
        
        uiVideoSettings.Load();
    }
    #endif
}