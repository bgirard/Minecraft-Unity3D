/* Provided options for UI tab and etc saving.
 * None - if UI should look the same for each display and if it should reset when concealed.
 * ForGameSessionDuration - if UI should keep player adjustments, but could forget them on quit.
 * FullSerialization - if UI should keep adjustments after game session and load them at start. * 
*/
public enum UISaveMode
{
    None,
    GameSessionDuration,
    FullSerialization
}