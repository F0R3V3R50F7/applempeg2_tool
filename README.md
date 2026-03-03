# AppleMPEG2_Tool (PowerPC G4 Optimized)

**AppleMPEG2_Tool** is a specialized Windows utility designed to bridge the gap between modern high-definition video and vintage PowerPC hardware. It converts any modern video into high-bitrate, AltiVec-friendly MPEG-2 within a `.mov` container, specifically tuned for **QuickTime 7.7** and older.

### Why MPEG-2?
While H.264 and MPEG-4 are "efficient" in terms of disk space, they are devastatingly heavy on G4 CPUs. MPEG-2 provides the perfect balance: it is computationally "cheap" to decode, allowing even a **1.67GHz PowerBook G4** to achieve flawless 1080p playback. This tool produces files that are significantly more manageable than Apple ProRes while maintaining "competitive" file sizes.

### Key Features
* **Intelligent BPP Scaling:** Unlike standard converters, this tool uses a custom Bits-Per-Pixel (BPP) algorithm that automatically increases data density for 720p and 480p downscales to prevent macroblocking.
* **2-Pass Motion Prediction:** Utilizes a first-pass analysis log with `qcomp` and `qblur` smoothing (similar to Handbrake) to intelligently distribute bits during high-motion scenes.
* **G4 Stability Cap:** All encodes are hardware-limited to **26Mbps** to ensure they stay within the sustainable bandwidth of the PowerBook’s ATA-100 bus and G4 decoding limits.
* **QuickTime Native:** Correct headers and `-vtag m2v1` flags ensure immediate compatibility with the QuickTime engine, iTunes, and Finder thumbnails.

---

### Installation & Usage
1.  **Download FFmpeg 7:** Get the latest builds from [BtbN/FFmpeg-Builds](https://github.com/BtbN/FFmpeg-Builds/releases/tag/latest).
2.  **Setup:** Extract the FFmpeg zip and place the `MPEG-2_PowerPC.bat` file into the `bin` folder.
3.  **Convert:** Simply drag and drop your video file onto the batch script.
4.  **Options:** Follow the on-screen prompts for resolution and framerate. 
    * *Note: While 60fps is possible on high-end Dual 1.42GHz MDD systems, 23.97fps is recommended for the best balance of quality and disk space.*

---

### Mac OS X Setup (Crucial)
Playback of MPEG-2 content on Mac OS X is not supported by default. Apple originally sold the **QuickTime MPEG-2 Component** separately. Since this is now obsolete and unobtainable from Apple, it has been archived here:

**[Download Apple MPEG-2 Codec (Archive.org)](https://archive.org/details/apple-mpeg-2-codec.component)**

**To Install:**
1.  Copy the zip to your Mac and extract it.
2.  Move the `.component` file to: `/Library/Quicktime/`
3.  Restart QuickTime or iTunes. Thumbnails should now appear in Finder, and files will play natively.

---

**WARNING:** To avoid temporary file conflicts with the 2-pass log, only convert one video at a time per folder instance.
