# Kindle Battery Test Loop

## About this project
This is a KUAL-based script to test how long your Kindle would last when using [Kindle Weather Stand Project](https://github.com/x-magic/kindle-weather-stand-alone). 

This script has a wakeup time of every 15 minutes instead of the Weather Stand's 1 hour. Honestly, it doesn't make a difference anyway. 

## Reboot the device
In the past you have to force-reboot Kindle with power button if you want to stop the script. 

Now all you need to do is: 

- Press power button to wake up Kindle
- Wait until screen shows "Updating"
- You should have about 5 seconds to press home button (the one with a house icon)
- Press and release the home button several time (to make sure the key press is detected)

And your Kindle will gracefully reboot itself. 

## Disclaimer
This script would disable a lot of system services. It's only tested on Kindle 4 Silver Non-touch version. Use at your own risk! 