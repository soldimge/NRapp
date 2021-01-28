package org.soldimge.radiod;

import org.qtproject.qt5.android.QtNative;
import android.content.Context;
import android.media.AudioManager;
import android.media.AudioFocusRequest;


    /** Manages a volume level of output stream  */
public class AndroidSDG
{
    private static Context c = QtNative.activity().getApplicationContext();

    private static AudioManager manager = (AudioManager)c.getSystemService(c.AUDIO_SERVICE);

        /** Common method to get Android audio manager object */
  private static AudioManager am()
  {
    return manager;
  }

        /** Displays native Android out volume control */
  public static void show() {
    am().adjustStreamVolume(AudioManager.STREAM_MUSIC, AudioManager.ADJUST_SAME, AudioManager.FLAG_SHOW_UI);
  }

        /** Maximal value of volume (depends on device) */
  public static int maxStreamVolume() {
    return am().getStreamMaxVolume(AudioManager.STREAM_MUSIC);
  }

        /** Current volume */
  public static int streamVolume() {
    return am().getStreamVolume(AudioManager.STREAM_MUSIC);
  }

        /** Sets volume */
  public static void setStreamVolume(int v) {
    am().setStreamVolume(AudioManager.STREAM_MUSIC, v, 0);
  }

  public static void registerMediaReceiver() {
        if(manager != null)
        {
            manager.requestAudioFocus(new AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN)
            .setAcceptsDelayedFocusGain(true)
            .setWillPauseWhenDucked(true)
            .setOnAudioFocusChangeListener(new AudioManager.OnAudioFocusChangeListener() {
                    @Override
                    public void onAudioFocusChange(int focusChange) {
                        if (focusChange == AudioManager.AUDIOFOCUS_LOSS_TRANSIENT) {
                            audioFocusLoss();
                        } else if (focusChange == AudioManager.AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK) {
                            audioFocusLoss();
                        } else if (focusChange == AudioManager.AUDIOFOCUS_GAIN) {
                            audioFocusGain();
                        } else if (focusChange == AudioManager.AUDIOFOCUS_LOSS) {
                            audioFocusLoss();
                        }
                    }
                }).build());
        }
}
    private static native void audioFocusLoss();
    private static native void audioFocusGain();
}

