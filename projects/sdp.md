---
layout: post
title: 'Development of a Software Defined Perimeter'
---

### Introduction


#### The Importance of Computer Security
More than ever before, industry and society as a whole are intertwined with computer 
technology. As a result, computer system failures and security breaches have a 
significant impact on both. Poor security procedures might end up costing businesses a 
lot of money. Additionally, they may have a detrimental effect on human activities or 
even human life. One might look to representative recent occurrences in the realm of 
computers to better appreciate the growing need for protection against computer threats.


In May 2017, the WannaCry ransomware worm infected over 300,000 computers by taking 
advantage of a flaw in Microsoft Windows systems. This infection either encrypts the 
victims' data or threatens to disclose it unless a ransom is paid. Public services that 
were employing antiquated software and technology took a severe damage as a result. The 
main  exploits used by this ransomware were EternalBlue and DoublePulsar, which were 
created  by the National Security Agency and became available to the public 
through the Shadow Brokers group, months before the attack.


Fortunately, Microsoft had released patches to fix them. Even though the WannaCry worm 
was dealt with, a lot of users can still be victims of the aforementioned tools. Here 
the key to the exploitation was the outdated software running on the victim’s machines. 
Since a great number of users depend on obsolete operating systems, such attacks can 
happen again. However, this attack demonstrates a common pattern among computer threats. 
When a network of hosts or a host is infected, the damage is inflicted on the machine 
and not the user’s physical self.


Unfortunately, security issues and hacking apply to many more products that are based on
computer technology. Electronic security locks, for example, are widely used by hotels, 
public services etc. On July 2012, at the Black Hat security conference, [Cody Brocious]
(https://www.cbsnews.com/news/
hotel-key-security-flaw-demonstrated-at-black-hat-conference/) presented a mechanism 
able to crack an electronic keycard system developed by a leading figure in the 
electronic locks field. What is perhaps more impressive is that the mechanism used a 
simple Arduino Board. In practice this means that someone with $26 (the price of an 
Arduino) could gain access to a victim’s physical space. Along the same lines, [a 
handful of vulnerabilities](https://technologyandsociety.org/
privacy-nightmare-when-baby-monitors-go-bad/) were found on software running on web 
cameras and baby monitors, allowing hackers to gain control of them. Although only a 
certain brand was affected by this hack, researchers reported that other brands might 
have similar vulnerabilities.

Another disturbing incident recently took place at a university: several Internet of 
Things devices were hacked and used to create a botnet which tried to launch 
denial-of-host attacks on the university’s network by sending multiple [DNS requests]
(http://www.verizonenterprise.com/resources/reports/
rp_data-breach-digest-2017-sneak-peek_xg_en.pdf). Although this attack was not harmful 
to anything other than the university’s network, the possibility of hackers gaining 
access to and controlling a whole team of devices can be alarming.


The aforementioned incidents were down to poorly designed and exploitable systems on the
hacked products. The first example was a common network attack which aimed to acquire
money from its unfortunate victims, and used sophisticated tools in order to gain access 
to their systems. The other examples, despite being even simpler to perpetrate, managed 
to get access to devices interconnected with our daily physical activities: web cameras, 
security locks, university appliances - in other words, Internet of Things (IoT) 
devices. It is crucial to develop mechanisms that prevent such incidents from happening 
and provide secure access to services throughout networks.

#### Building a 'Dark Cloud' Using SDP

All of these attacks have something in common, namely the attacker is aware of important 
information about its targets such as their open ports, message types, applications 
running. This intelligence can be obtained by the services running on the networked 
machines. A solution would be for the services to restrict access only to a set of 
predefined clients. It is obvious, this is a static and highly impractical solution. 


However, it is possible that a more viable and efficient solution exists today.
In an effort to combat the risk of network attacks, the Defense Information System Agency
(DISA) introduced the [Software Defined Perimeter (SDP) project](https://
cloudsecurityalliance.org/artifacts/
software-defined-perimeter-zero-trust-specification-v2/). 


The project’s aim is to create a so-called Black Cloud: a network that cannot be scanned 
by any foreign hosts while providing access to services hidden behind the cloud. A basic 
component of SDP is the Single Packet Authorization (SPA) mechanism, which is used to 
authorize a client before it can actually connect and access the services of a given 
host. More concretely, SPA allows clients to transmit authentication information and 
achieve authentication with another server across closed network ports. Thus, the 
servers can block access to all of their ports and then allow only authenticated users 
to connect with them.


The Black Cloud consists of a network of hosts connected together. Every host 
authenticates itself to the others via the SPA authentication mechanism. Each host is 
invisible to illegitimate hosts, since it blocks access to all of its ports, therefore 
the entire Black Cloud structure, since it is composed of such hosts, is theoretically 
invisible. The SDP provides to its clients the ability to request access to different 
services from providers across the Black Cloud network. The services are hidden behind 
the SDP’s complex structure and the clients can not access them directly but through the 
intermediate nodes of the system which are used as gateways.


The SDP is relatively similar to Network Access Control (NAC), namely it tries to define 
a set of protocols/solutions in order to securely connect network nodes to each other 
based on certain policies. However, it can also provide support for network devices, and 
therefore it can be used as an IoT security mechanism. Another advantage that SDP has 
over NAC is that SDP can create secure communication tunnels within its structure, 
between applications (or services) and clients, called Dynamic Tunnel Mode. This is 
similar to a VPN connection and is used to combat most network attacks.

{% include image.html url="https://www.techtarget.com/searchcloudcomputing/definition/software-defined-perimeter-SDP" image="projects/sdp/SDP_figure_1.jpeg" %}


### Singe Packet Authentication (SPA)

#### Concept

In order to exploit a vulnerability, a hacker has to first discover and scan the target 
system. Open ports are a good starting point for the perpetrator since they provide a 
way to discover which services the target machine is providing. One may then check for 
and exploit corresponding service-specific security issues in a variety of ways, e.g., 
sniffing and/or altering transmitted data, performing man-in-the-middle attacks, 
denial-of-service attacks, gaining access or control the target machine via buffer 
overflows, etc.


The process of scanning is quite easy. The attacker can send packets to target open ports
and wait for a response. Based on this response the attacker can gain valuable 
information about which services run on which ports. For example, nmap [20] is an 
excellent tool that automates such processes.


A service that regularly deals with client requests could eliminate the threat of 
scanning by using the firewall to block attackers and allowing firewall access only to 
legitimate clients. However in this scenario, proper users need to authenticate 
themselves before establishing a connection. This concept is called “authentication 
prior to connection”. So far, two implementations exist that try to achieve this: 
Port-Knocking, and its evolution, Single Packet Authorization (SPA)

#### Port Knocking

The first approach that was proposed to achieve authentication prior to connection is 
the so called Port-Knocking Protocol. In order to open a TLS connection with a service 
running on a server, the client first has to send packets to several different ports 
belonging to the server according to a predefined sequence: the ports to be addressed 
and the sequence in which they have to be addressed constitute a secret message/
passphrase. 


The server blocks access to all its ports, but monitors the network traffic towards 
them. When a valid port sequence is identified, the server adds a new firewall rule to 
allow the sender to communicate with the machine. 

{% include image.html text="Indicative port knocking sequence." image="projects/sdp/port_knocking.png" %}

However, the port-knocking sequence can be monitored and replayed by a third party (a
replay-attack). Anyone over a local subnet can monitor each of the clients’ 
transmissions, and then replay the exact same packets to the same ports in order to gain 
access to the system.

{% include image.html text="Replay attack for port knocking." image="projects/sdp/pk_replay.png" %}

Another problem is that the effective information passed from the client to the server is
the port field of the TCP and UDP protocols, which is only 2 bytes long. This means that 
in order to support a secret message or passphrase of size B one must make B/2 separate 
packet transmissions. In fact, the process takes even longer as one needs to introduce a 
time delay between these transmissions, in order to avoid any out-of-order delivery of 
the sequence packets.


Last but not least, client authorization may fail (the server may consider the client as
unauthorized) even if it provides the right sequence of knocks, if a second malicious 
user spoofs fake port-knock requests at the same time. This attack is not as 
sophisticated as a replay attack, but can cause trouble with very little effort/
intelligence on the part of the attacker.

#### SPA

A new mechanism, the so-called Single Packet Authorization (SPA), which has similarities 
to the port-knocking concept, was presented at the Black Hat conference in 2005 by two 
research groups (MadHat unspecific and Simple Nomad). In the following years, Michael 
Rash used the SPA concept to produce his own implementation (open source, available on 
[Github](https://github.com/mrash/fwknop)) of the protocol, called fwknop. 

Like port-knocking, SPA achieves the authentication of a client to a server. It is 
assumed that they both own a shared secret seed, which is used for the encryption and 
decryption of the exchanged messages.


The server behaves in a similar way to port-knocking. It blocks access to all ports, and 
then passively monitors the network for incoming packets. However, instead of port 
knocks, the server looks for SPA packets. The server also adds new firewall rules to 
allow authenticated clients to connect with it.

{% include image.html text="The SPA Protocol." image="projects/sdp/spa.png" %}

The client sends an SPA packet when it wants to access a specific port on the server. As
in port-knocking, the port to be made eventually accessible to the client, is assumed to 
be agreed a priori by both the client and the server. More specifically, the SPA packet 
includes the following information:
* AID : the unique ID of the client that sends this packet
* RANDOM : a random alphanumeric produced by the client before sending the packet 
* PASSWORD : the password of the client (also known by the server)
* NEW_SEED : the new value of the shared seed for the next transaction
* MD5_HASH : a hash of the previous values


These values are encrypted using the shared secret seed. The SPA packet consists of the 
encrypted values along with the AID of the client that is sent in plaintext (used by the 
server to find the right key for decrypting the packet’s contents).


When a packet with the expected SPA format is received, the server uses the AID value 
that is enclosed in the packet to determine which client supplied it.
The values included in the packet are then decrypted by the server using the shared key 
connected to the client. If the decryption of the values was succesful, the 
authentication of the client completes if: 
* The PASSWORD in the packet matches the one  that is known to server for that client
* The hash of the received values matches the MD5_HASH value received 
* The RANDOM value has not been used in a previous SPA packet sent by this client. 

Following client authentication, the server authorizes the designated port and changes 
their shared secret key to the returned NEW_SEED value.


SPA appears to offer security against the majority of computer network assaults, 
although highly trained hackers can still take advantage of the system. An attacker 
might keep an eye on the network until a client makes an attempt at SPA authentication, 
then wait until the client has been authenticated by the server and has been granted 
access to its firewall before using IP spoofing to hijack the session. If the protected 
service performs its own authentication check, the issue is then resolved. Instead of 
attempting to take over the client's service, the attacker can use IP spoofing to launch 
a DoS assault on the open port. The SPA is therefore vulnerable to DoS attacks, but only 
knowledgeable and experienced hackers can carry them out.


During this project I have attempted to create a version of the SPA library (available 
[here](https://github.com/chocof/spa)) with a few adjustments to the original 
specification. 

### Software Defined Perimeter

#### Concept 

The Software Defined Perimeter (SDP), also called Black Cloud, utilizes the SPA protocol 
in order to provide access to services, by protecting the system from attacks such as 
server scanning, denial of service, operating system and application vulnerability 
exploits, and man- in-the-middle attacks (assuming the attacker is not already inside 
the system).


The Cloud Security Alliance (CSA) has published a software specification document upon 
which this implementation was based. The CSA’s proposal is similar to a DMZ
(demilitarized zone): it isolates one or more services behind a perimeter (the SDP) 
while clients can access and gain access to services only through the gateways of the 
SDP.

{% include image.html text="SDP protecting a service." image="projects/sdp/sdp_in_action.
png" %}

The architecture and functionality of SDP can provide multiple applications such as: 
* **Enterprise Application Isolation**: Highly valuable enterprise applications can be 
isolated be- hind a Black Cloud while allowing authorized clients to access them. 
* **Cloud Technology**: Multiple clients can be connected through a cloud which uses an 
SDP to provide various services to each client dynamically. 
* **Internet of Things**: Everyday objects could be connected to an SDP in order to 
secure data aggregation, component registration and other actions.

#### Architecture

SDP consists of two components: the SDP Controller (sCTL) and the SDP Hosts. An SDP host 
can either be an Initiating Host (IH) or an Accepting Host(AH). The SDP Controller 
(sCTL) manages and authenticates SDP hosts while it also decides which of them 
communicate with each other.


IH represents the client entity. The IH can request access and communicate with services 
via the SDP system. The SDP uses AH as gateways to services (thus they are also refered 
to as SDP Gateways). Their function is similar to a reverse-proxy: they redirect data 
received from clients to the corresponding services and then forward the services 
responses back to the clients. The phrase ’AH protects a service’ is used to symbolize 
that an AH is configured to act as a gateway for a service.


The AH connects and stays connected to an sCTL until its termination. The IH connects to 
the sCTL in order to search for available services. When the IH selects the service it 
wants to use, the sCTL instructs it to connect to the corresponding AH which provides 
these services. 


Both AH and sCTL use the SPA in order to authenticate their clients. This means that 
once started, both hosts will configure their firewall  with a strict DROP-all-packets 
rule. Later on, firewall access will be provided only to authenticated clients.

{% include image.html url="https://www.c-csa.cn/u_file/photo/20210624/fe0730576f.pdf" 
text="SDP architecture as illustrated on CSA’s whitepaper." image="projects/sdp/csa_sdp.
png" %}

You can download the SDP thesis and read more about its architecture, my proposed implementation scheme and various edits I made to the original design <a href="{{ site.github.url }}/assets/pdf/sdp.pdf" download>here</a>.