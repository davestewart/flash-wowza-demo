flash-wowza-demo
================

OO version of the Wowza record / play demo






Wowza Setup
===========

Contents

	* Install Java
	* Sign-up and download Wowza
	* Install Wowza
	* Start Wowza
	* Test the EngineManager
	* Set up an application to record videos	
	* Start to record video
	* Wowza folders

Install Java
------------

You need to have the correct version of Java installed. I have both 32 and 64 bit Java installed.

	http://www.java.com/en/download/manual.jsp

For more info, see:

	http://www.wowza.com/forums/content.php?217#installJava


Sign-up and download Wowza
--------------------------

Go to the Wowza site and sign up fo a developer licence:

	http://www.wowza.com/media-server/developers/license

This will send you an email with a licence key

Download and run the installer at:

	http://www.wowza.com/pricing/installer



Install Wowza
-------------

Run the installer
	
	Pick a directory
	Enter the licence key

Pick a username and password. You will need these to access the browser-based admin panel.

	username: wowza
	password: wowza

If you're developing, choose to start the wowza engine with the system.

Any issues, go here:

	http://www.wowza.com/forums/content.php?217



Start Wowza
-----------

Go to:

	http://localhost:1935/

and see if you get the message "Wowza Streaming Engine 4 Trial Edition (Expires: Mar 04, 2015) 4.1.0 build12602"

If you do, everything is great. If not, it's likely that the service isn't running for some reason. There are several ways (at least) round this:


**Restart your machine**

If you've just installed, a machine restart can get things running.


**Check that the services are set to run automatically**

It may be that the servces are not set to run automatically.

Do this by running the Windows Services console via your start menu, or by running services.msc from the command line.  

Find the Wowza services, open thier property panels, ensure their startup types are set to "Automatic", and if they're paused, start them.


**Run the service as a named user**

If that doesn't work, you may need to run the service as a named user:

Again, you'll need to open the Windows Services console, then find the Wowza services, open thier property panels.

In each of the panels:

	If the service is paused, click "Stop" to stop it
	Switch to the "Log On" tab
	Switch from "Local System account" to "This account"
	In the first "Select User" popup, click "Browse..."
	In the second "Select User" popup, Click "Find now"
	In the "Search results" list, douible-click your user name, to select and confirm
	Return to the "Log On" tab by clicking "OK"
	Enter your logon passwords in the fields
	Click "Apply"
	Switch to the "General" tab
	Click "Start" to start the service
	Click "OK" to exit
	
The service should now start, and will run automatically each time Windows runs.


**Reconfigure the port**

If you think the issue is a conflicting port, you can check this by running Windows' resmon.exe:

	http://stackoverflow.com/questions/48198/how-can-you-find-out-which-process-is-listening-on-a-port-on-windows#answer-23718720

If you want to change the port the Engine listens on, check this post:

	http://www.wowza.com/forums/showthread.php?37103-Page-not-Found


**Run the standalone server**

Finally, if any of the above doesn't work, you can start the standalone server, by running:

	C:\Program Files (x86)\Wowza Streaming Engine\bin\startup.bat
	
That will start the server, but you'll need to leave the console open whilst you use it.




Test the EngineManager
----------------------

Connect to the engine manager on

	http://localhost:8088/enginemanager

If you see a "This webpage is not available" message, then you probably need to start the service, as above.

If the service won't run, then you can start it manually, by running:

	C:\Program Files (x86)\Development\Wowza\manager\bin\startmgr.bat

Again, you'll need to keep the console open for the duration.






Set up an application to record videos
--------------------------------------

To record videos, you need create an app. This can be done in one of 3 ways:

	1. through the EngineManager console
	2. by tailoring one of the example apps
	3. by manually creating and copying files and folders

Each app only needs a couple of files and folders to run:

	`wowza\applications\<app>\
	wowza\conf\<app>\Application.xml
	wowza\content\(<app>\)
	`

The folders / files are:

	- The applications folder tells the engine there is a named app.
	- The conf folder holds all the configuration data about the app
	- The optional content subfolder siloes all content from your app

Now, how to create the apps:

###Via the console

	- Log in to the console at: http://localhost:8088/enginemanager
	- Click Applications / Add Application
	- Click the first option "Live", Single server or origin
	
This will now start the Add Application process.

	- Enter a new name for your application, such as "demo"

When the new screen is ready, start editing the options:

	- Add an application description, such as "Webcam recording demo"
	- Edit the supported playback types if you like (for testing, we only need Adobe RTMP)
	- Under "Streaming File Directory" select "Application-specific directory" to record content to a subfolder
	- Click "Save"


###Via tailoring an existing example app

This is most easily done using the example "Webcam Recording" app. To set it up, run:

	C:\Program Files (x86)\Development\Wowza\examples\WebcamRecording\install.bat

This will copy the correct folder content to the main Wowza folder:

	wowza\applications\webcamrecording
	wowza\conf\webcamrecording\Application.xml

All content will be recorded to 

	wowza\content
	
However, you can customize this in application's Application.xml file, by editing the 

	Root.Application.Strams.StorageDir

node, to something like:

	<StorageDir>${com.wowza.wms.context.VHostConfigHome}/content/webcamrecording</StorageDir>

You can also set up an application manually. See:

	http://wiki.ensemblevideo.com/index.php?title=Configure_Wowza_Streaming_Server

	
	
Start to record video
---------------------

Now everything is working, we can finally record some video!

Open the project in FlashDevelop, and ensure your settings are correct. We're using:

	serverName: rtmp://localhost/webcamrecording
	streamName: <whatever you want>.mp4

The last part of the server URL should point to an existing application. If you try to record to a different folder, you will get the following error:

	Application folder ([install-location]/applications/webcamrecording) is missing.

Finally, publish the SWF. The app should pop up, and all the correct values should be in place.

	Click Connect
	Check your video size
	Click Record
	Do something interesting
	Click Stop
	Click Play to see your results

Your video will have been saved to the <StorageDir> folder as outlined above, which will be within:

	[installdir]/content/

You can record to subfolders by adding a / to the stream name, so could record by date, user, quality, etc. for example "2014/09/10/your movie.mp4":



Wowza folders
-------------

@see http://www.wowza.com/forums/content.php?321#usersGuideUpgrade_Application_XML

These folders look interesting:

	[install-dir]/conf
	Wowza Media Server configuration files and license keys
	
	[install-dir]/content
	Video on demand files
	
	[install-dir]/logs
	Wowza Media Server log files (if needed for your own billing purposes for clients)
	
	
	
	
	
	
	

