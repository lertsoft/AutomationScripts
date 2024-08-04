# PiHole_Setup

If you don't have a wire connection to the router you might need to set up a wireless connection. To do so you need to create a [wpa_supplicant.conf](https://github.com/lertsoft/PiHole_Setup/blob/master/wpa_supplicant.conf) and write the script for the wireless connection as shown in the hyperlink.

 Create an ssh file on the boot drive, so that the raspberry pi knows that it is activated.
This is so that I can configure all the setting on my laptop instead of having to connect the Raspberry pi to a screen.
  
  `$ touch ssh`
  
after you turn on the raspberry pi wait a minute or two for it to recognize all the setting.
Proceed to log into your raspberry pi with:

  `$ ssh pi@raspberrypi.local`
 
Press enter / answer yes to the prompts.  When asked for a password,  **raspberry** is the default password.
**If you do not have SSH setup you will need to set it up in your computer to have access to the raspberry pi.**

Check for updates on your raspberry pi.
 
 `$ sudo apt-get update && sudo apt-get upgrade -y`

change your default password
 
 `$ passwd`

install pi_hole on your raspberry pi
 
 `$ curl -sSL https://install.pi-hole.net | bash`



<h4> Blocklist sites 

For [youtube ads](https://www.reddit.com/r/pihole/comments/9w5swx/i_think_ive_managed_to_block_youtube_ads_with/) I just blocked manifest.googlevideo.com, you could be more direct by doing a `nslockup manifest.googlevideo.com` get the ip address and block both.

