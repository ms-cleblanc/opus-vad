package com.nuance.opusvad.jni;

/* IMPORTANT NOTE:
 * The native functions in this class will expect the functions
 * prefixed with "Java_com_nuance_opusvad_jni_OpusVAD_".
 * If you move this class to another package, you much change
 * the function signatures in the native library.
 */

import java.nio.ByteBuffer;

public class OpusVAD {
    public static final int OPUSVAD_BIT_RATE_TYPE_VBR = 0;
    public static final int OPUSVAD_BIT_RATE_TYPE_CVBR = 1;
    public static final int OPUSVAD_BIT_RATE_TYPE_CBR = 2;

    public static final int DEFAULT_COMPLEXITY = 3;
    public static final int DEFAULT_BIT_RATE_TYPE = OPUSVAD_BIT_RATE_TYPE_CVBR;
    public static final int DEFAULT_SOS_WINDOW_MS = 220;
    public static final int DEFAULT_EOS_WINDOW_MS = 900;
    public static final int DEFAULT_SPEECH_DETECTION_SENSITIVITY = 20;

    public static final int SAMPLE_BYTES = 2;
    public static final int AUDIO_FREQ = 16000;

    ByteBuffer ctx = null; // Will be modified by native init()
    final ByteBuffer audioBuffer;
    final ByteBuffer encodedBuffer;
    final int frame_size;
    boolean useAdpcm = false;
    int high_nibble_first = 0;

    public interface Listener {
        void onStartOfSpeech(String ctx, int pos);
        void onEndOfSpeech(String ctx, int pos);
    };
    private Listener mVADListener = null;
    
    native final int init(OpusVADOptions options);
    public native final int processAudio(ByteBuffer audiobuf, int num_samples);
    public native final int processAudioAdpcm(ByteBuffer audiobuf, int num_samples, int high_nibble_first);
    native final int getFrameSize();
    public native final int getMaxBufferSamples();
    native final int getOpusEncoded(ByteBuffer outbuf);
    
    void onStartOfSpeech(String ctx, int pos)
    {
	    if (this.mVADListener != null)
	        this.mVADListener.onStartOfSpeech(ctx, pos);
    }
    
    void onEndOfSpeech(String ctx, int pos)
    {
	if (this.mVADListener != null)
	    this.mVADListener.onEndOfSpeech(ctx, pos);
    }
    
    public OpusVAD(boolean useAdpcm, OpusVADOptions options, OpusVAD.Listener listener) throws Exception {
        int res = init(options);
        if (res != 0) {
            throw new Exception("Error with Init: " + res);
        }
        this.useAdpcm = useAdpcm;
	    this.mVADListener = listener;
	
        frame_size = getFrameSize();
        audioBuffer = (useAdpcm) ? ByteBuffer.allocateDirect(frame_size / 2) : ByteBuffer.allocateDirect(frame_size * SAMPLE_BYTES);
        encodedBuffer = (useAdpcm) ? ByteBuffer.allocateDirect(frame_size / 2) : ByteBuffer.allocateDirect(frame_size * SAMPLE_BYTES);
    }

    public void setHighNibbleFirst() {
        high_nibble_first = 1;
    }

    public void setLowNibbleFirst() {
      high_nibble_first = 0;
    }

    public int processAudioByteArray(byte[] audiobuf, int offset, int len)
    {
        audioBuffer.position(0);
        audioBuffer.put(audiobuf, offset, len);

        return ( (useAdpcm) ? processAudioAdpcm(audioBuffer, len * 2, high_nibble_first) : processAudio(audioBuffer, len / SAMPLE_BYTES) );
    }

    public int getFrameSamples()
    {
        return frame_size;
    }

    public int getFrameBytes() {
          return ( (useAdpcm) ? getFrameSamples() / 2 : getFrameSamples() * SAMPLE_BYTES );
    }

    public int getOpusEncodedBytes(byte[] out, int pos, int maxlen) {
       encodedBuffer.position(0);
       int res = getOpusEncoded(encodedBuffer);
       if (res >= 0) {
           if (maxlen < res) {
               return -1;
           }
           encodedBuffer.get(out, pos, res);
       }
       return res;
    }
}
