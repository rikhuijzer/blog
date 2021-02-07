+++
title = "QoS setup using Tomato in combination with an Experiabox"
published = "2015-08-25"
rss = "My first blog post."
image = "/assets/tomato.png"
+++

*This is a copy of my blog post at [Blogspot](https://rikhui.blogspot.com/2015/08/qossetuptomato.html).
It is mostly here for myself, so that I can compare my writing in 2015 with newer writings.*

# Introduction

In this blog my setup for QoS (Quality of Service) will be explained. 
The QoS is used in a home network with five users. 
The home network has an maximum download/upload speed of 650 / 35 kB/s. 
The QoS had to be introduced because of 'slow internet' noticed by the users while browsing websites, gaming or using VoIP. 
This problem was growing ever year because of more clients (i.e. smartphones, tablets and laptops) and data usage (cloud backup, HD stream availability). 
The key in solving the problem is to avoid using too much bandwidth. 
When too much bandwidth is used the data will pile up resulting in slow internet packet delivery. 
To limit the bandwidth it is important to slow down the big users like streaming and cloud backup. 
Last year a solution using the program cFosSpeed was implemented. 
This program ran on all the Windows devices and limited data based on the responsible process. 
Unfortunately the program could not run on android, meaning that those devices weren't limited at all. 
This rendered the solution completely useless. 
The solution now used is based on a router with some advanced firmware. 
The router knows nothing about the responsible processes, but is only looking at the packets. 
This results in a completely platform independent system which works without any set-up at the client side. 

This blog is written for two reasons:

- My own documentation.
- Helping others to achieve the same results.

# Hardware
The hardware used for the QoS is a Netgear WNR2000v2 (2009). Other devices capable of running the necessary firmware are:
Asus RT-N10, Asus RT-N12, Asus RT-N16, Asus WL500GP v1/v2, Asus WL500W, Asus WL500G Deluxe, Asus WL520GU, Buffalo WHR-G54S, Buffalo WHR-HP-G54, D-Link DIR-320, Linksys E1000 v1, Linksys E2000, Linksys E3000, Linksys E4200, Linksys WRT160N v1, Linksys WRT160N v3, Linksys WRT300N v1, Linksys WRT310N v1, Linksys WRT310N v2, Linksys WRT320N, Linksys WRT54G-TM, Linksys WRT54-GL,-GS v1-v4, Linksys WRT610Nv2, Linksys WRTSL54GS, Netgear WNR3500 L, Netgear WNR3500 v2 / U, Ovislink WL1600GL, ZTE ZXV10 H618B.
The Netgear was used in combination with a KPN Arcadyan ARV7519i Experiabox (v7?).
This device is known for its many restrains. The setup could have been a lot easier and tidier with a proper router.
To get a good QoS system all in- and outbound data should run trough the system. Tomato only limits the data trough the WAN port. 
That is why a patch cable should be plugged in the Experiabox (LAN) and the second router (WAN). 
Now the WiFi connection and LAN ports (on the second router) can be used by the clients. 

# Firmware
The most important part in this setup is the [Tomato firmware](http://tomatousb.org/). Visit the TomatoUSB website for info about flashing the firmware on your router. 

# Configuring network
After installation a new subnet will have been created and Tomato will do the DHCP for it. 
This of course is not ideal, see 'Battlefield'. 
Better would be to create a bridge between the two routers. This option is disabled for all Experia boxes [except the V8](https://gathering.tweakers.net/forum/list_messages/1610316). 
So we stick to the default mode. 
In the default mode all clients will get a new IP in another subnet as the Experiabox. 
The default subnet for the Experiabox is 192.168.2.\*, so Tomato probably takes 192.168.1.\*. 
Before connecting all clients to the new subnet it is best to change all the IP's for clients with a static IP. 
The new IP should be somewhere in the new subnet, which is by default between 192.168.1.100 and 192.168.1.199. 
After changing the static IP's it is impossible to access the clients using the Experiabox subnet. 
You can now access the clients by connecting yourself and them to the Tomato router. 
It is also possible to keep some devices connected directly to the Experiabox, they will be accessible from within the Tomato subnet. 
Reaching clients in the Tomato subnet from the Experiabox subnet is not possible.

# Port forwarding
The only problem yet by using two LAN's is Battlefield. 
The game would not connect. 
The easiest and best way to solve this is to enable UPnP on both routers, this is also advised by [Toastman](http://www.linksysinfo.org/index.php?threads/using-qos-tutorial-and-discussion.28349/#post-138449). 
But keep in mind that this is [really not secure](http://security.stackexchange.com/questions/38631/what-are-the-security-implications-of-enabling-upnp-in-my-home-router#38661). 
To manually forward ports first forward from the Experiabox to the Tomato and then from the Tomato to the client.
Don't forget to reboot both routers **and** the client when things don't seem to work as they should.

# Configuring QoS
When all the data is successfully going trough the WAN port on the 
Tomato router the QoS can be enabled. 
To learn a bit more about the working of the system see the QoS tutorial on TomatoUSB.org. 
Don't use the QoS settings described there. 
Some more recent setting by Toastman can be seen in this forumpost.
Keep in mind that his setup is made for up to '400 room residential blocks'. 
So tweaking some of the basic settings is a good idea. 
Note that the classification rules works from top to bottom. 
So all the rules are checked in that way. 
Put the most used rules in your home at the top to save CPU usage. 
Also note that the L7 rules cost relatively much processing power. 
These notes are not very important on slow connections, but I think it is good not to waste processing power.

# Conclusion
I like to note the advantages and disadvantages of the new setup. 
Games run at constant low latencies (~19ms) without spikes, which is a mayor improvement. 
Web browsing feels very responsive, even when torrents are running without limitations on the client side. 
And VoIP seems to work great too. 
This all happens without the CPU load exceeding 10 percent. 
A drawback of the system is that new games or services which need high priority have to be manually added. 
A second drawback is that download speed has decreased by 30 percent. 
The speed can be slightly improved by tweaking the QoS settings. 
The third and last drawback is that it can be very difficult to discover why programs feel slow. 
Is it because the packets are wrongly classified? 
Is it caused by a slow server? 
Or is it caused by the limitations of the network connection?
Overall I'm very pleased with the QoS setup so far.

![Tomato screenshot](/assets/tomato.png)
