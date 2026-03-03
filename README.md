# applempeg2_tool
This Windows tool will convert any video file to perfectly encoded mpeg-2 at a reasonable quality with appropriate bitrate in the .mov container with the correct headers for Quicktime 7.7 and below.
MPEG-2 (.mov) is the most efficient format for video on PowerPC G4 systems. It's much easier for the CPU to decode over MPEG-4 or God forbid H264. The file sizes are also very competetive over something like Apple ProRes. 
Using this format will enable flawless playback of 1080p content on even the 1.67GHz PowerBook G4. 60fps playback is also possible on the dual 1.42ghz MDD G4, but QuickTime is the only player that can decode this. iTunes will stutter, as will Real and VLC will refuse all together. It's generally recommended to stick to 23.97. You want to aim for the minimum framerate possible to save disk space. 

Download ffmpeg 7 from the link here: "https://github.com/BtbN/FFmpeg-Builds/releases/tag/latest", extract the zip and move the batch from above to the bin folder. Simply drag your video onto the batch and select your desired options.

Playback of MPEG-2 content on Mac OS X is not supported by default, Apple sold their QuickTime MPEG-2 Codec to editing customers separately. This codec has since become obsolete and unobtainable so I have archived it here: 

"https://archive.org/details/apple-mpeg-2-codec.component"

You need to move the zip to your Mac and extract it there. Then move the .component file to the location below. 
Macintosh HD: /Library/Quicktime/ <--- Paste Here

Thumbnails for your newly generated videos should now display in Finder and you should also be able to import the videos and play them in iTunes for the best experience. 

WARNING! Only convert one video at once, or copy the bin folder to a separate instance.
