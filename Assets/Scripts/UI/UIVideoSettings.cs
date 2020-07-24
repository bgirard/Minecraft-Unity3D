using TMPro;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using UnityEngine.UI;

//Able to read, write and apply video-settings.  
[RequireComponent(typeof(UISettings))]
public class UIVideoSettings : MonoBehaviour
{
    public PostProcessLayer postProcessLayer;
    public PostProcessProfile defaultPostProcessProfile;
    public PostProcessVolume underwaterEffectsVolume;

    [Space(10)] 
    public TMP_Dropdown antialiasing;
    
    [Space(10)]
    public Toggle   underwaterEffects;
    public Toggle   bloom,
                    ambientOcclusion,
                    vignette,
                    motionBlur,
                    depthOfField,
                    colorGrading,
                    autoExposure;

    private UISettings uiSettings;
        
    private void Start()
    {
        uiSettings = GetComponent<UISettings>();

        Load();
        Local();
    }

    //Call if settings ready for apply.
    public void ChangeSettings()
    {
        Local();
        uiSettings.Save();
    }

    //Load settings from configuration. Use UISettings Load() to load configuration from file.
    public void Load()
    {
        antialiasing.value     = UISettings.settingsData["Video Settings"]["Antialiasing"].IntValue;
        underwaterEffects.isOn = UISettings.settingsData["Video Settings"]["Underwater Effects"].BoolValue;
        
        bloom.isOn            = UISettings.settingsData["Video Settings"]["Bloom"].BoolValue;
        ambientOcclusion.isOn = UISettings.settingsData["Video Settings"]["Ambient Occlusion"].BoolValue;
        vignette.isOn         = UISettings.settingsData["Video Settings"]["Vignette"].BoolValue;
        motionBlur.isOn       = UISettings.settingsData["Video Settings"]["Motion Blur"].BoolValue;
        depthOfField.isOn     = UISettings.settingsData["Video Settings"]["Depth Of Field"].BoolValue;
        autoExposure.isOn     = UISettings.settingsData["Video Settings"]["Auto Exposure"].BoolValue;
        colorGrading.isOn     = UISettings.settingsData["Video Settings"]["Color Grading"].BoolValue;

        Local();
    }

    //Apply settings to game.
    private void Local()
    {
        postProcessLayer.antialiasingMode = (PostProcessLayer.Antialiasing) antialiasing.value;
        underwaterEffectsVolume.enabled = underwaterEffects.isOn;
        
        defaultPostProcessProfile.GetSetting<Bloom>().enabled.value            = bloom.isOn;
        defaultPostProcessProfile.GetSetting<AmbientOcclusion>().enabled.value = ambientOcclusion.isOn;
        defaultPostProcessProfile.GetSetting<Vignette>().enabled.value         = vignette.isOn;
        defaultPostProcessProfile.GetSetting<MotionBlur>().enabled.value       = motionBlur.isOn;
        defaultPostProcessProfile.GetSetting<DepthOfField>().enabled.value     = depthOfField.isOn;
        defaultPostProcessProfile.GetSetting<AutoExposure>().enabled.value     = autoExposure.isOn;
        defaultPostProcessProfile.GetSetting<ColorGrading>().enabled.value     = colorGrading.isOn;
    }
    
    
}
