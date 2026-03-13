# Retime-Re-encode-Tool
This batch file is a simple tool for preparing clips for editing challenges or sharing clips in a format that is easy for others to use.

What the tool does:

- re-encodes clips to .mp4
- optionally retime clips (e.g. turn 60fps at 0.1 timescale to 600fps)
- set output framerate
- uses Vegas friendly encoding settings for smoother editing (no more vdub)

It supports the following input file types:
.mp4
.avi
.mov
.m4v

It outputs:
.mp4
(I can add more if needed)


FFmpeg must be installed
This batch file uses FFmpeg to process video files.
It will not work unless FFmpeg is installed and accessible from the Windows command line.

FFmpeg install steps:

1. you can download the latest FFmpeg here:
https://www.gyan.dev/ffmpeg/builds/
essentials should be fine


2. Extract the files
After downloading, extract the FFmpeg folder somewhere permanent, for example:
C:\ffmpeg

Inside that folder, you should have a path similar to:
C:\ffmpeg\bin\ffmpeg.exe


3. Add FFmpeg to your system PATH
Adding FFmpeg to PATH allows you to type ffmpeg in Command Prompt from any folder.

	1. Press the Windows key
	2. Search for: Environment Variables
	3. Open Edit the system environment variables
	4. Click Environment Variables
	5. Under System variables, find Path
	6. Click Edit
	7. Click New
	8. Add the FFmpeg bin folder, for example: C:\ffmpeg\bin
	9. Click OK on everything to save


4. Test FFmpeg
Open Command Prompt and type: ffmpeg -version
If FFmpeg is installed correctly, you should see version information.


How to use the batch file

1. Put the batch file in the same folder as your clips
Example folder:

	clip1/
    		pov.avi
    		cine1.avi
    		cine2.avi
		tool.bat


2. Run the batch file
Double click the .bat file


3. Answer the prompt
Do the clips need retiming? (Y/N)
Y if the clip timing is wrong and needs to be restored
N if the clip timing is already correct and you only want re-encoding


3.5 Enter retime multiplier
Example: 10 
the clip will be sped up by 10x
This is for clips recorded at 0.1 timescale
so 60fps at 0.1 timescale becomes 600fps


4. Enter final output FPS
This sets the final framerate of the exported .mp4 files
typical Examples:
600
1000
1200


Example workflow:
.avi clips recorded at 0.1 timescale at 60fps

Settings:
	Retime: Y
	Multiplier: 10
	Output FPS: 600

Result:
	properly timed
	re-encoded
	exported as MP4 ready for smooth velocity in Vegas

Note:
I recommend calculating in advance the math for your clip retiming
don't just put 10 in the multiplier expecting it to work for all cases
especially if its not the typical 0.1 timescale 60fps going to 600fps
